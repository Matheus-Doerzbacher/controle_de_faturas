-- Controle de Faturas — schema inicial
-- Rodar via `supabase db push` (com o projeto linkado) ou colar direto no
-- SQL Editor do painel Supabase.

-- ── perfis ──────────────────────────────────────────────────────────────
create table public.perfis (
  id             uuid primary key references auth.users(id) on delete cascade,
  dia_vencimento smallint not null default 20 check (dia_vencimento between 4 and 28),
  idioma         text not null default 'es' check (idioma in ('pt','es')),
  administrador  boolean not null default false,
  criado_em      timestamptz not null default now(),
  atualizado_em  timestamptz not null default now()
);

alter table public.perfis enable row level security;

create policy "perfis_select_proprio" on public.perfis
  for select using (auth.uid() = id);
create policy "perfis_update_proprio" on public.perfis
  for update using (auth.uid() = id) with check (auth.uid() = id);
-- Sem policy de insert/delete: a linha nasce via trigger abaixo (security
-- definer contorna RLS) e some sozinha pelo "on delete cascade" da FK.

create or replace function public.criar_perfil_novo_usuario()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.perfis (id) values (new.id);
  return new;
end;
$$;

create trigger ao_criar_usuario
  after insert on auth.users
  for each row execute function public.criar_perfil_novo_usuario();

-- ── faturas ─────────────────────────────────────────────────────────────
create table public.faturas (
  id            uuid primary key default gen_random_uuid(),
  usuario_id    uuid not null references auth.users(id) on delete cascade,
  tipo          text not null check (tipo in ('entrada','saida')),
  valor         bigint not null check (valor > 0),
  descricao     text not null default '',
  data_fatura   date not null,
  caminho_foto  text,
  criado_em     timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

create index faturas_usuario_data_idx on public.faturas (usuario_id, data_fatura desc);

alter table public.faturas enable row level security;

create policy "faturas_select_proprio" on public.faturas
  for select using (auth.uid() = usuario_id);
create policy "faturas_insert_proprio" on public.faturas
  for insert with check (auth.uid() = usuario_id);
create policy "faturas_update_proprio" on public.faturas
  for update using (auth.uid() = usuario_id) with check (auth.uid() = usuario_id);
create policy "faturas_delete_proprio" on public.faturas
  for delete using (auth.uid() = usuario_id);

create or replace function public.atualizar_data_modificacao()
returns trigger language plpgsql as $$
begin
  new.atualizado_em = now();
  return new;
end;
$$;

create trigger faturas_atualizar_data before update on public.faturas
  for each row execute function public.atualizar_data_modificacao();
create trigger perfis_atualizar_data before update on public.perfis
  for each row execute function public.atualizar_data_modificacao();

-- ── storage: fotos das faturas (privado, uma pasta por usuário) ──────────
insert into storage.buckets (id, name, public)
values ('fotos-faturas', 'fotos-faturas', false)
on conflict (id) do nothing;

create policy "fotos_select_proprio" on storage.objects
  for select to authenticated
  using (bucket_id = 'fotos-faturas' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fotos_insert_proprio" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'fotos-faturas' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fotos_update_proprio" on storage.objects
  for update to authenticated
  using (bucket_id = 'fotos-faturas' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'fotos-faturas' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fotos_delete_proprio" on storage.objects
  for delete to authenticated
  using (bucket_id = 'fotos-faturas' and (storage.foldername(name))[1] = auth.uid()::text);
