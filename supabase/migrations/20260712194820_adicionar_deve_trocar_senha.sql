-- Toda conta nova (criada pelo admin com senha temporária) deve trocar a
-- senha no primeiro login. O default 'true' cobre tanto contas futuras
-- quanto as já existentes.
alter table public.perfis
  add column deve_trocar_senha boolean not null default true;
