// Edge Function "gerenciar-usuarios" — única peça do sistema que usa a
// service_role key. Sem cadastro público no app: criar/remover contas passa
// sempre por aqui, e só depois de confirmar (via RLS, com o client do
// próprio chamador) que quem está pedindo é um admin (`perfis.administrador`).
//
// SUPABASE_URL, SUPABASE_ANON_KEY e SUPABASE_SERVICE_ROLE_KEY já vêm
// injetadas automaticamente pela plataforma — nada a configurar como secret.
import { createClient } from "npm:@supabase/supabase-js@2";

const urlSupabase = Deno.env.get("SUPABASE_URL")!;
const chaveAnonima = Deno.env.get("SUPABASE_ANON_KEY")!;
const chaveServiceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const cabecalhosCors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function respostaOk(corpo: unknown) {
  return new Response(JSON.stringify(corpo), {
    status: 200,
    headers: { ...cabecalhosCors, "Content-Type": "application/json" },
  });
}

function respostaErro(mensagem: string, status: number) {
  return new Response(JSON.stringify({ erro: mensagem }), {
    status,
    headers: { ...cabecalhosCors, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: cabecalhosCors });
  }
  if (req.method !== "POST") {
    return respostaErro("Método não suportado", 405);
  }

  const cabecalhoAuth = req.headers.get("Authorization");
  if (!cabecalhoAuth) {
    return respostaErro("Não autenticado", 401);
  }

  // Client autenticado como o próprio chamador — checar se é admin lendo
  // "perfis" com esse client garante que a checagem respeita a RLS (um
  // usuário só enxerga a própria linha).
  const clienteChamador = createClient(urlSupabase, chaveAnonima, {
    global: { headers: { Authorization: cabecalhoAuth } },
  });

  const { data: dadosUsuario, error: erroUsuario } = await clienteChamador
    .auth.getUser();
  if (erroUsuario || !dadosUsuario?.user) {
    return respostaErro("Não autenticado", 401);
  }

  const { data: perfil, error: erroPerfil } = await clienteChamador
    .from("perfis")
    .select("administrador")
    .eq("id", dadosUsuario.user.id)
    .single();

  if (erroPerfil || !perfil?.administrador) {
    return respostaErro("Acesso restrito a administradores", 403);
  }

  let corpo: Record<string, unknown>;
  try {
    corpo = await req.json();
  } catch {
    return respostaErro("Corpo da requisição inválido", 400);
  }

  // Só a partir daqui usamos a service_role key, e só porque já confirmamos
  // acima (via RLS) que o chamador é admin.
  const clienteAdmin = createClient(urlSupabase, chaveServiceRole);
  const acao = corpo.acao;

  if (acao === "listar") {
    const { data, error } = await clienteAdmin.auth.admin.listUsers();
    if (error) return respostaErro(error.message, 500);
    const usuarios = data.users.map((usuario) => ({
      id: usuario.id,
      email: usuario.email,
      criadoEm: usuario.created_at,
    }));
    return respostaOk({ usuarios });
  }

  if (acao === "criar") {
    const email = corpo.email;
    const senha = corpo.senha;
    if (
      typeof email !== "string" ||
      typeof senha !== "string" ||
      senha.length < 6
    ) {
      return respostaErro(
        "E-mail e senha (mínimo 6 caracteres) são obrigatórios",
        400,
      );
    }
    const { data, error } = await clienteAdmin.auth.admin.createUser({
      email,
      password: senha,
      email_confirm: true,
    });
    if (error) return respostaErro(error.message, 400);
    return respostaOk({
      usuario: { id: data.user?.id, email: data.user?.email },
    });
  }

  if (acao === "remover") {
    const usuarioId = corpo.usuarioId;
    if (typeof usuarioId !== "string") {
      return respostaErro("usuarioId é obrigatório", 400);
    }
    if (usuarioId === dadosUsuario.user.id) {
      return respostaErro("Você não pode remover sua própria conta", 400);
    }
    const { error } = await clienteAdmin.auth.admin.deleteUser(usuarioId);
    if (error) return respostaErro(error.message, 400);
    return respostaOk({ sucesso: true });
  }

  return respostaErro("Ação desconhecida", 400);
});
