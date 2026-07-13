import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/tela_admin.dart';
import '../../features/autenticacao/presentation/tela_login.dart';
import '../../features/configuracoes/application/perfil_provider.dart';
import '../../features/configuracoes/presentation/tela_configuracoes.dart';
import '../../features/configuracoes/presentation/tela_trocar_senha.dart';
import '../../features/faturas/domain/fatura.dart';
import '../../features/faturas/presentation/tela_formulario_fatura.dart';
import '../../features/faturas/presentation/tela_inicial.dart';
import '../../features/faturas/presentation/tela_lista_faturas.dart';
import '../supabase/provedores_supabase.dart';

/// Adapta um `Stream` (o `onAuthStateChange` do Supabase) para o
/// `Listenable` que `GoRouter.refreshListenable` espera, disparando uma
/// reavaliação de `redirect` a cada login/logout.
class _OuvinteAutenticacao extends ChangeNotifier {
  _OuvinteAutenticacao(Stream<dynamic> stream) {
    _assinatura = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _assinatura;

  @override
  void dispose() {
    _assinatura.cancel();
    super.dispose();
  }
}

final roteadorAppProvider = Provider<GoRouter>((ref) {
  final client = ref.watch(clienteSupabaseProvider);
  final ouvinte = _OuvinteAutenticacao(client.auth.onAuthStateChange);
  ref.onDispose(ouvinte.dispose);

  return GoRouter(
    initialLocation: '/inicio',
    refreshListenable: ouvinte,
    redirect: (context, state) {
      final logado = client.auth.currentSession != null;
      final indoParaLogin = state.matchedLocation == '/login';

      if (!logado) return indoParaLogin ? null : '/login';
      if (indoParaLogin) return '/inicio';

      final perfil = ref.read(perfilAtualProvider).value;
      final indoParaTrocarSenha = state.matchedLocation == '/trocar-senha';

      // Prioridade máxima: com senha temporária pendente, nenhuma outra
      // rota é alcançável até trocar.
      if (perfil != null && perfil.deveTrocarSenha && !indoParaTrocarSenha) {
        return '/trocar-senha';
      }

      if (state.matchedLocation == '/admin') {
        // Sem confirmação de que é admin, não deixa entrar. A checagem que
        // realmente importa (segurança) acontece de novo no servidor, na
        // Edge Function "gerenciar-usuarios" — isto aqui é só UX.
        if (perfil != null && !perfil.administrador) return '/inicio';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const TelaLogin()),
      GoRoute(
        path: '/inicio',
        builder: (context, state) => const TelaInicial(),
      ),
      GoRoute(
        path: '/faturas',
        builder: (context, state) => const TelaListaFaturas(),
      ),
      GoRoute(
        path: '/faturas/novo',
        builder: (context, state) {
          final tipo = TipoFatura.values.byName(
            state.uri.queryParameters['tipo'] ?? 'entrada',
          );
          return TelaFormularioFatura(tipoInicial: tipo);
        },
      ),
      GoRoute(
        path: '/faturas/editar',
        builder: (context, state) {
          final fatura = state.extra! as Fatura;
          return TelaFormularioFatura(
            tipoInicial: fatura.tipo,
            faturaExistente: fatura,
          );
        },
      ),
      GoRoute(
        path: '/configuracoes',
        builder: (context, state) => const TelaConfiguracoes(),
      ),
      GoRoute(
        path: '/trocar-senha',
        builder: (context, state) => const TelaTrocarSenha(),
      ),
      GoRoute(path: '/admin', builder: (context, state) => const TelaAdmin()),
    ],
  );
});
