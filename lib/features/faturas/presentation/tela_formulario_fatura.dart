import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tema_app.dart';
import '../../../core/utils/formatador_moeda.dart';
import '../../../core/utils/seletor_data.dart';
import '../../../l10n/app_localizations.dart';
import '../application/faturas_do_mes_provider.dart';
import '../domain/fatura.dart';
import 'widgets/campo_selecionar_foto.dart';
import 'widgets/visualizar_foto_fatura.dart';

class TelaFormularioFatura extends ConsumerStatefulWidget {
  const TelaFormularioFatura({
    super.key,
    required this.tipoInicial,
    this.faturaExistente,
  });

  final TipoFatura tipoInicial;
  final Fatura? faturaExistente;

  bool get ehEdicao => faturaExistente != null;

  @override
  ConsumerState<TelaFormularioFatura> createState() =>
      _TelaFormularioFaturaState();
}

class _TelaFormularioFaturaState extends ConsumerState<TelaFormularioFatura> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController _controladorValor;
  late final TextEditingController _controladorDescricao;
  late DateTime _dataSelecionada;

  Uint8List? _bytesNovaFoto;
  bool _removerFotoExistente = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final fatura = widget.faturaExistente;
    _controladorValor = TextEditingController(
      text: fatura != null
          ? FormatadorMoeda.agruparMilhares(fatura.valor.toString())
          : '',
    );
    _controladorDescricao = TextEditingController(text: fatura?.descricao ?? '');
    _dataSelecionada = fatura?.dataFatura ?? DateTime.now();
  }

  @override
  void dispose() {
    _controladorValor.dispose();
    _controladorDescricao.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final selecionada = await escolherData(
      context: context,
      dataInicial: _dataSelecionada,
      primeiraData: DateTime(2020),
      ultimaData: DateTime.now(),
    );
    if (selecionada != null) {
      setState(() => _dataSelecionada = selecionada);
    }
  }

  Future<void> _salvar() async {
    final textos = AppLocalizations.of(context)!;
    if (!(_chaveFormulario.currentState?.validate() ?? false)) return;

    setState(() => _salvando = true);

    try {
      final repositorio = ref.read(repositorioFaturasProvider);
      final valor = int.parse(_controladorValor.text.replaceAll('.', ''));

      if (widget.ehEdicao) {
        await repositorio.atualizar(
          fatura: widget.faturaExistente!,
          valor: valor,
          descricao: _controladorDescricao.text.trim(),
          dataFatura: _dataSelecionada,
          bytesNovaFoto: _bytesNovaFoto,
          removerFoto: _removerFotoExistente,
        );
      } else {
        await repositorio.criar(
          tipo: widget.tipoInicial,
          valor: valor,
          descricao: _controladorDescricao.text.trim(),
          dataFatura: _dataSelecionada,
          bytesFoto: _bytesNovaFoto,
        );
      }

      ref.invalidate(faturasDoMesProvider);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(textos.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _excluir() async {
    final textos = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(textos.deleteConfirmTitle),
        content: Text(textos.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(textos.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(textos.deleteButton),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _salvando = true);
    try {
      await ref
          .read(repositorioFaturasProvider)
          .excluir(widget.faturaExistente!);
      ref.invalidate(faturasDoMesProvider);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(textos.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context)!;
    final ehEntrada = widget.tipoInicial == TipoFatura.entrada;

    final titulo = widget.ehEdicao
        ? textos.editInvoiceTitle
        : (ehEntrada ? textos.newEntradaTitle : textos.newSaidaTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          if (widget.ehEdicao)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _salvando ? null : _excluir,
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TemaApp.larguraMaximaConteudo,
            ),
            child: Form(
              key: _chaveFormulario,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _controladorValor,
                            keyboardType: TextInputType.number,
                            inputFormatters: [MascaraValorGuarani()],
                            decoration: InputDecoration(
                              labelText: textos.amountLabel,
                              prefixText: 'Gs. ',
                              prefixIcon: const Icon(
                                Icons.payments_outlined,
                              ),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) {
                                return textos.amountRequired;
                              }
                              final numero = int.tryParse(
                                valor.replaceAll('.', ''),
                              );
                              if (numero == null || numero <= 0) {
                                return textos.amountInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _escolherData,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: textos.dateLabel,
                                prefixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                ),
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down,
                                ),
                              ),
                              child: Text(_formatarData(_dataSelecionada)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _controladorDescricao,
                            decoration: InputDecoration(
                              labelText: textos.descriptionLabel,
                              hintText: textos.descriptionHint,
                              prefixIcon: const Icon(
                                Icons.description_outlined,
                              ),
                            ),
                            validator: (valor) =>
                                (valor == null || valor.trim().isEmpty)
                                ? textos.descriptionRequired
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _construirSecaoFoto(context),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _salvando ? null : _salvar,
                    child: _salvando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(textos.saveButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirSecaoFoto(BuildContext context) {
    final textos = AppLocalizations.of(context)!;

    if (_bytesNovaFoto != null) {
      return CampoSelecionarFoto(
        bytesAtuais: _bytesNovaFoto,
        aoSelecionar: (bytes) => setState(() => _bytesNovaFoto = bytes),
        aoRemover: () => setState(() {
          _bytesNovaFoto = null;
          _removerFotoExistente = true;
        }),
      );
    }

    final caminhoExistente = widget.faturaExistente?.caminhoFoto;
    if (caminhoExistente != null && !_removerFotoExistente) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.photoLabel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              VisualizarFotoFatura(caminhoFoto: caminhoExistente),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton.filled(
                  icon: const Icon(Icons.close),
                  tooltip: textos.removePhotoButton,
                  onPressed: () =>
                      setState(() => _removerFotoExistente = true),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return CampoSelecionarFoto(
      bytesAtuais: null,
      aoSelecionar: (bytes) => setState(() {
        _bytesNovaFoto = bytes;
        _removerFotoExistente = false;
      }),
      aoRemover: () {},
    );
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }
}
