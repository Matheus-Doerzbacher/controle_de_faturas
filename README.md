# Controle de Faturas

App em Flutter (iOS, Android, Web) para controlar entrada e saída de faturas
mensais no Paraguai, com backend em Supabase.

## Configuração do Supabase (passo a passo, feito uma única vez)

1. Crie o projeto em [supabase.com](https://supabase.com) (sugestão de
   região: `sa-east-1`).
2. Em **Authentication → Providers → Email**, desative "Allow new users to
   sign up" — o app não tem cadastro público, contas são criadas só pelo
   admin (dentro do app, na tela Admin).
3. Aplique a migration em `supabase/migrations/`:
   ```
   supabase link --project-ref SEU_PROJECT_REF
   supabase db push
   ```
   (ou cole o conteúdo do arquivo `.sql` direto no SQL Editor do painel).
4. Faça o deploy da Edge Function:
   ```
   supabase functions deploy gerenciar-usuarios
   ```
5. Crie sua própria conta em **Authentication → Users → Add user** e depois
   rode no SQL Editor (trocando o e-mail) para virar admin:
   ```sql
   update public.perfis set administrador = true
   where id = (select id from auth.users where email = 'SEU_EMAIL_AQUI');
   ```
6. Copie `env.example.json` para `env.json` e preencha com a URL e a
   **publishable key** do projeto (Project Settings → API).
7. A partir daqui, a conta de teste para compartilhar pode ser criada direto
   pela tela Admin do app — não precisa mexer mais no painel do Supabase.

## Rodando o app

Sempre com `--dart-define-from-file=env.json`:

```
flutter run --dart-define-from-file=env.json
```

Builds:

```
flutter build web --dart-define-from-file=env.json
flutter build apk --dart-define-from-file=env.json
flutter build ios --dart-define-from-file=env.json
```
