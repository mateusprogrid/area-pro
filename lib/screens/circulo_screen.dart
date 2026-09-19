import 'dart:math' as math;

import 'package:flutter/material.dart';

// ============================================================================
// MODELO
// ============================================================================
class ResultadoCirculo {
  final double raio;
  final double area;
  final String material;
  final double desperdicio;
  final double areaComDesperdicio;
  final double? precoPorMetroQuadrado;
  final double? custoEstimado;

  ResultadoCirculo({
    required this.raio,
    required this.area,
    required this.material,
    required this.desperdicio,
    required this.areaComDesperdicio,
    this.precoPorMetroQuadrado,
    this.custoEstimado,
  });
}

// ============================================================================
// TELA
// ============================================================================
class CirculoScreen extends StatefulWidget {
  const CirculoScreen({super.key});

  @override
  State<CirculoScreen> createState() => _CirculoScreenState();
}

class _CirculoScreenState extends State<CirculoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _raioController = TextEditingController();
  final _precoController = TextEditingController();
  final _desperdicioController = TextEditingController(text: '10');

  String _materialSelecionado = 'Piso';

  ResultadoCirculo? _resultado;

  // ==========================================================================
  // MATERIAL
  // ==========================================================================
  void _selecionarMaterial(String? material) {
    if (material == null) return;

    setState(() {
      _materialSelecionado = material;

      switch (material) {
        case 'Piso':
          _desperdicioController.text = '10';
          break;

        case 'Revestimento':
          _desperdicioController.text = '12';
          break;

        case 'Tinta':
          _desperdicioController.text = '5';
          break;

        case 'Madeira':
          _desperdicioController.text = '15';
          break;

        case 'Personalizado':
          _desperdicioController.text = '';
          break;
      }

      _resultado = null;
    });
  }

  // ==========================================================================
  // CÁLCULO
  // ==========================================================================
  void _calcularArea() {
    if (!_formKey.currentState!.validate()) return;

    final raio = double.parse(
      _raioController.text.replaceAll(',', '.'),
    );

    final desperdicio = double.parse(
      _desperdicioController.text.replaceAll(',', '.'),
    );

    final area = math.pi * raio * raio;

    final areaComDesperdicio =
        area + (area * desperdicio / 100);

    double? precoPorMetroQuadrado;
    double? custoEstimado;

    if (_precoController.text.trim().isNotEmpty) {
      precoPorMetroQuadrado = double.parse(
        _precoController.text.replaceAll(',', '.'),
      );

      custoEstimado =
          areaComDesperdicio * precoPorMetroQuadrado;
    }

    setState(() {
      _resultado = ResultadoCirculo(
        raio: raio,
        area: double.parse(
          area.toStringAsFixed(2),
        ),
        material: _materialSelecionado,
        desperdicio: desperdicio,
        areaComDesperdicio: double.parse(
          areaComDesperdicio.toStringAsFixed(2),
        ),
        precoPorMetroQuadrado: precoPorMetroQuadrado,
        custoEstimado: custoEstimado != null
            ? double.parse(
                custoEstimado.toStringAsFixed(2),
              )
            : null,
      );
    });
  }

  // ==========================================================================
  // VALIDAÇÕES
  // ==========================================================================
  String? _validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe um valor';
    }

    final numero = double.tryParse(
      valor.replaceAll(',', '.'),
    );

    if (numero == null || numero <= 0) {
      return 'Digite um valor maior que zero';
    }

    return null;
  }

  String? _validarPreco(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return null;
    }

    final numero = double.tryParse(
      valor.replaceAll(',', '.'),
    );

    if (numero == null || numero <= 0) {
      return 'Digite um preço válido';
    }

    return null;
  }

  String? _validarDesperdicio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a margem de desperdício';
    }

    final numero = double.tryParse(
      valor.replaceAll(',', '.'),
    );

    if (numero == null || numero < 0 || numero > 100) {
      return 'Informe um percentual entre 0 e 100';
    }

    return null;
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================
  @override
  void dispose() {
    _raioController.dispose();
    _precoController.dispose();
    _desperdicioController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // INTERFACE
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ÁreaPro',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8FAFC),
                  Color(0xFFF1F5F9),
                  Color(0xFFEFF6FF),
                ],
              ),
            ),
          ),

          const Positioned(
            top: -90,
            right: -70,
            child: _BackgroundOrb(
              size: 230,
              color: Color(0x332563EB),
            ),
          ),

          const Positioned(
            top: 340,
            left: -110,
            child: _BackgroundOrb(
              size: 260,
              color: Color(0x2214B8A6),
            ),
          ),

          const Positioned(
            bottom: -110,
            right: -80,
            child: _BackgroundOrb(
              size: 280,
              color: Color(0x222563EB),
            ),
          ),

          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  32,
                ),
                children: [
                  const Text(
                    'Calcule áreas e custos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Ideal para jardins, piscinas e outras superfícies circulares.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.75),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        _IconBox(),

                        SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Área do Círculo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                'Fórmula: π × raio²',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const _SectionTitle(
                    titulo: 'Medidas',
                    subtitulo:
                        'Informe a dimensão da superfície.',
                  ),

                  const SizedBox(height: 18),

                  const _LabelCampo('Raio'),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _raioController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ex.: 4',
                      prefixIcon:
                          Icon(Icons.radio_button_unchecked),
                      suffixText: 'm',
                    ),
                    validator: _validarNumero,
                  ),

                  const SizedBox(height: 32),

                  const _SectionTitle(
                    titulo: 'Material',
                    subtitulo:
                        'Escolha o material usado na superfície.',
                  ),

                  const SizedBox(height: 18),

                  const _LabelCampo('Tipo de material'),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _materialSelecionado,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.category_outlined,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Piso',
                        child: Text('Piso'),
                      ),
                      DropdownMenuItem(
                        value: 'Revestimento',
                        child: Text('Revestimento'),
                      ),
                      DropdownMenuItem(
                        value: 'Tinta',
                        child: Text('Tinta'),
                      ),
                      DropdownMenuItem(
                        value: 'Madeira',
                        child: Text('Madeira'),
                      ),
                      DropdownMenuItem(
                        value: 'Personalizado',
                        child: Text('Personalizado'),
                      ),
                    ],
                    onChanged: _selecionarMaterial,
                  ),

                  const SizedBox(height: 18),

                  const _LabelCampo(
                    'Margem de desperdício',
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _textoDesperdicio(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _desperdicioController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ex.: 10',
                      prefixIcon: Icon(Icons.percent),
                      suffixText: '%',
                    ),
                    validator: _validarDesperdicio,
                  ),

                  const SizedBox(height: 18),

                  const _LabelCampo('Preço por m²'),

                  const SizedBox(height: 6),

                  const Text(
                    'Opcional — preencha para estimar o custo total.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _precoController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ex.: 85,00',
                      prefixIcon:
                          Icon(Icons.attach_money),
                      prefixText: 'R\$ ',
                    ),
                    validator: _validarPreco,
                  ),

                  const SizedBox(height: 28),

                  ElevatedButton.icon(
                    onPressed: _calcularArea,
                    icon: const Icon(
                      Icons.calculate_outlined,
                    ),
                    label: const Text(
                      'Calcular estimativa',
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_resultado != null)
                    _buildResultado(_resultado!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TEXTO DE AJUDA
  // ==========================================================================
  String _textoDesperdicio() {
    switch (_materialSelecionado) {
      case 'Piso':
        return 'Sugestão para piso: 10% para cortes e perdas.';

      case 'Revestimento':
        return 'Sugestão para revestimento: 12% para recortes e acabamento.';

      case 'Tinta':
        return 'Sugestão para pintura: 5% de margem adicional.';

      case 'Madeira':
        return 'Sugestão para madeira: 15% para cortes, encaixes e perdas.';

      default:
        return 'Defina manualmente a margem que deseja considerar.';
    }
  }

  // ==========================================================================
  // RESULTADO
  // ==========================================================================
  Widget _buildResultado(ResultadoCirculo r) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.80),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF16A34A),
              ),

              SizedBox(width: 8),

              Text(
                'Resultado da estimativa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          const Text(
            'Área calculada',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${r.area.toStringAsFixed(2)} m²',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Material recomendado',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D4ED8),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${r.areaComDesperdicio.toStringAsFixed(2)} m²',
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E40AF),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${r.material} • ${r.desperdicio.toStringAsFixed(0)}% de margem',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),

          if (r.custoEstimado != null) ...[
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custo estimado',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF047857),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _formatarMoeda(
                      r.custoEstimado!,
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF065F46),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${r.areaComDesperdicio.toStringAsFixed(2)} m² × ${_formatarMoeda(r.precoPorMetroQuadrado!)} / m²',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF8FAFC).withOpacity(0.90),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _linhaResultado(
                  'Raio',
                  '${r.raio.toStringAsFixed(2)} m',
                ),

                const SizedBox(height: 10),

                _linhaResultado(
                  'Material',
                  r.material,
                ),

                const SizedBox(height: 10),

                _linhaResultado(
                  'Margem',
                  '${r.desperdicio.toStringAsFixed(0)}%',
                ),

                const SizedBox(height: 10),

                _linhaResultado(
                  'Material necessário',
                  '${r.areaComDesperdicio.toStringAsFixed(2)} m²',
                ),

                if (r.precoPorMetroQuadrado != null) ...[
                  const SizedBox(height: 10),

                  _linhaResultado(
                    'Preço por m²',
                    _formatarMoeda(
                      r.precoPorMetroQuadrado!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // FORMATAÇÃO
  // ==========================================================================
  String _formatarMoeda(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');

    final inteiro = partes[0];
    final decimal = partes[1];

    final buffer = StringBuffer();

    for (int i = 0; i < inteiro.length; i++) {
      final posicao = inteiro.length - i;

      buffer.write(inteiro[i]);

      if (posicao > 1 && posicao % 3 == 1) {
        buffer.write('.');
      }
    }

    return 'R\$ ${buffer.toString()},$decimal';
  }

  Widget _linhaResultado(
    String titulo,
    String valor,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF64748B),
          ),
        ),

        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// COMPONENTES
// ============================================================================
class _SectionTitle extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const _SectionTitle({
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitulo,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _LabelCampo extends StatelessWidget {
  final String texto;

  const _LabelCampo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF334155),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF2563EB).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.circle_outlined,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _BackgroundOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 90,
              spreadRadius: 30,
            ),
          ],
        ),
      ),
    );
  }
}