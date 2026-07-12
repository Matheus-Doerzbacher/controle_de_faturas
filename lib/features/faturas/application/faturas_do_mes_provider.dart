import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/provedores_supabase.dart';
import '../data/repositorio_faturas.dart';
import '../domain/fatura.dart';

final repositorioFaturasProvider = Provider<RepositorioFaturas>((ref) {
  return RepositorioFaturas(ref.watch(clienteSupabaseProvider));
});

final faturasDoMesProvider = FutureProvider.family<List<Fatura>, DateTime>((
  ref,
  mes,
) {
  return ref.watch(repositorioFaturasProvider).buscarPorMes(mes);
});
