import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'package:url_launcher/url_launcher.dart';

const Color _azulJeans = Color(0xFF2B5EA7);
const Color _azulEscuro = Color(0xFF1B3A66);

void main() {
  runApp(const MinionsApp());
}

class MinionsApp extends StatelessWidget {
  const MinionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Minions App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
        ),
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFFFFBE6),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellow,
          foregroundColor: _azulEscuro,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: _azulEscuro,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minions App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),

      body: SingleChildScrollView(

        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFEB3B), Color(0xFFFFF59D)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                children: [

                  _OlhoMinion(),

                  SizedBox(height: 16),

                  Text(
                    'MINIONS',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: _azulEscuro,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Informações, curiosidades e estatísticas '
                    'sobre o filme Minions (2015).',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: _azulEscuro,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const _TituloDePagina('Explore o aplicativo'),

            const SizedBox(height: 16),

            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: SizedBox(
                height: 300,
                child: CarouselView(
                  itemExtent: 260,
                  shrinkExtent: 200,
                  itemSnapping: true,
                  onTap: (indice) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: _secoes[indice].construir),
                    );
                  },
                  children: [
                    for (final info in _secoes) _CartaoDoCarrossel(info),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Image.asset(
              'assets/images/faixa_minions.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}

enum _Secao { enredo, elenco, curiosidades, estatisticas }

class _InfoSecao {
  final _Secao secao;
  final String nome;
  final IconData icone;
  final WidgetBuilder construir;

  final String imagem;

  const _InfoSecao({
    required this.secao,
    required this.nome,
    required this.icone,
    required this.construir,
    required this.imagem,
  });
}

const List<_InfoSecao> _secoes = [
  _InfoSecao(
    secao: _Secao.enredo,
    nome: 'Enredo',
    icone: Icons.movie,
    construir: _criarEnredoPage,
    imagem: 'assets/images/medieval.jpg',
  ),
  _InfoSecao(
    secao: _Secao.elenco,
    nome: 'Elenco',
    icone: Icons.people,
    construir: _criarElencoPage,
    imagem: 'assets/images/steve_carell.webp',
  ),
  _InfoSecao(
    secao: _Secao.curiosidades,
    nome: 'Curiosidades',
    icone: Icons.lightbulb,
    construir: _criarCuriosidadesPage,
    imagem: 'assets/images/curiosidades.jpg',
  ),
  _InfoSecao(
    secao: _Secao.estatisticas,
    nome: 'Estatísticas',
    icone: Icons.bar_chart,
    construir: _criarEstatisticasPage,
    imagem: 'assets/images/capa_filme.jpg',
  ),
];

Widget _criarEnredoPage(BuildContext context) => const EnredoPage();
Widget _criarElencoPage(BuildContext context) => const ElencoPage();
Widget _criarCuriosidadesPage(BuildContext context) =>
    const CuriosidadesPage();
Widget _criarEstatisticasPage(BuildContext context) =>
    const EstatisticasPage();

AppBar _appBarComNavegacao(
  BuildContext context,
  String titulo,
  _Secao secaoAtual,
) {
  return AppBar(
    title: Text(titulo),
    backgroundColor: Colors.yellow,
    leading: IconButton(
      icon: const Icon(Icons.home),
      tooltip: 'Início',
      onPressed: () => Navigator.pop(context),
    ),
    actions: [
      for (final info in _secoes)
        if (info.secao != secaoAtual)
          IconButton(
            icon: Icon(info.icone),
            tooltip: info.nome,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: info.construir),
            ),
          ),
    ],
  );
}

class _CartaoDoCarrossel extends StatelessWidget {
  final _InfoSecao info;

  const _CartaoDoCarrossel(this.info);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        Image.asset(
          info.imagem,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),

        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, _azulEscuro],
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(info.icone, color: Colors.yellow, size: 28),
                const SizedBox(width: 8),
                Text(
                  info.nome,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OlhoMinion extends StatelessWidget {
  const _OlhoMinion();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[600],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(

        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Container(
            width: 34,
            height: 34,
            padding: const EdgeInsets.all(9),

            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF6D4C41),
            ),
            child: Container(

              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnredoBloco {
  final String tipo;
  final String? texto;
  final String? caminho;
  final bool moldura;

  const EnredoBloco({
    required this.tipo,
    this.texto,
    this.caminho,
    this.moldura = false,
  });

  factory EnredoBloco.fromJson(Map<String, dynamic> json) {
    return EnredoBloco(
      tipo: json['EnredoTipo'] as String,
      texto: json['EnredoTexto'] as String?,
      caminho: json['EnredoCaminho'] as String?,
      moldura: json['EnredoMoldura'] as bool? ?? false,
    );
  }
}

Future<List<EnredoBloco>> carregarEnredo() async {
  final String texto = await rootBundle.loadString('assets/data/enredo.json');
  final List<dynamic> lista = jsonDecode(texto) as List<dynamic>;
  return lista
      .map((item) => EnredoBloco.fromJson(item as Map<String, dynamic>))
      .toList();
}

class EnredoPage extends StatelessWidget {
  const EnredoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarComNavegacao(context, 'Enredo', _Secao.enredo),

      body: FutureBuilder<List<EnredoBloco>>(
        future: carregarEnredo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar enredo: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<EnredoBloco> blocos = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const _TituloDePagina('Enredo'),
                const SizedBox(height: 20),
                for (final bloco in blocos) ...[
                  if (bloco.tipo == 'imagem' && bloco.moldura)
                    _ImagemArredondada(bloco.caminho!)
                  else if (bloco.tipo == 'imagem')
                    Image.asset(
                      bloco.caminho!,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    )
                  else
                    _CartaoDeTexto(bloco.texto!),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class CastCard {
  final String castName;
  final String castFunction;
  final String castLink;
  final String castImage;

  const CastCard({
    required this.castName,
    required this.castFunction,
    required this.castLink,
    required this.castImage,
  });

  factory CastCard.fromJson(Map<String, dynamic> json) {
    return CastCard(
      castName: json['CastName'] as String,
      castFunction: json['CastFunction'] as String,
      castLink: json['CastLink'] as String? ?? '',
      castImage: json['CastImage'] as String? ?? '',
    );
  }
}

Future<List<CastCard>> carregarElenco() async {
  final String texto = await rootBundle.loadString('assets/data/cast.json');

  final List<dynamic> lista = jsonDecode(texto) as List<dynamic>;

  return lista
      .map((item) => CastCard.fromJson(item as Map<String, dynamic>))
      .toList();
}

class ElencoPage extends StatelessWidget {
  const ElencoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarComNavegacao(context, 'Elenco', _Secao.elenco),

      body: FutureBuilder<List<CastCard>>(
        future: carregarElenco(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar elenco: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<CastCard> elenco = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.68,
            ),
            itemCount: elenco.length,
            itemBuilder: (context, index) {
              return _CastCardWidget(pessoa: elenco[index]);
            },
          );
        },
      ),
    );
  }
}

class _CastCardWidget extends StatelessWidget {
  final CastCard pessoa;

  const _CastCardWidget({required this.pessoa});

  Future<void> _abrirLink() async {
    if (pessoa.castLink.isEmpty) return;
    final uri = Uri.parse(pessoa.castLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _abrirLink,
      borderRadius: BorderRadius.circular(12),
      child: Container(

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [

            Expanded(
              child: Image.asset(
                pessoa.castImage,
                width: double.infinity,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(
                children: [
                  Text(
                    pessoa.castName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pessoa.castFunction,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CuriosityBox {
  final String curiosityTitle;
  final String curiosityText;

  const CuriosityBox({
    required this.curiosityTitle,
    required this.curiosityText,
  });

  factory CuriosityBox.fromJson(Map<String, dynamic> json) {
    return CuriosityBox(
      curiosityTitle: json['CuriosityTitle'] as String,
      curiosityText: json['CuriosityText'] as String,
    );
  }
}

Future<List<CuriosityBox>> carregarCuriosidades() async {
  final String texto = await rootBundle.loadString('assets/data/curiosities.json');
  final List<dynamic> lista = jsonDecode(texto) as List<dynamic>;
  return lista
      .map((item) => CuriosityBox.fromJson(item as Map<String, dynamic>))
      .toList();
}

class CuriosidadesPage extends StatelessWidget {
  const CuriosidadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarComNavegacao(context, 'Curiosidades', _Secao.curiosidades),

      body: FutureBuilder<List<CuriosityBox>>(
        future: carregarCuriosidades(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar curiosidades: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<CuriosityBox> curiosidades = snapshot.data!;

          return SingleChildScrollView(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Text(
                    'CURIOSIDADES',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: _azulEscuro,
                    ),
                  ),
                ),

                Image.asset(
                  'assets/images/medieval.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 24),

                for (final e in curiosidades.asMap().entries)
                  _CuriosityBoxWidget(numero: e.key + 1, curiosidade: e.value),

                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CuriosityBoxWidget extends StatelessWidget {
  final int numero;
  final CuriosityBox curiosidade;

  const _CuriosityBoxWidget({required this.numero, required this.curiosidade});

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.fromLTRB(16, 0, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: _azulJeans,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              'CURIOSIDADE $numero',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCB2E),
              border: Border.all(color: _azulJeans, width: 6),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFE0A800),
                  offset: Offset(6, 6),
                  blurRadius: 0,
                ),
              ],
            ),

            child: Column(
              children: [
                Text(
                  curiosidade.curiosityTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: _azulEscuro,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  curiosidade.curiosityText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const Map<String, IconData> _iconesPorNome = {
  'calendar_month': Icons.calendar_month,
  'timer': Icons.timer,
  'business': Icons.business,
};

class DadoEstatistica {
  final String icone;
  final String rotulo;
  final String valor;

  const DadoEstatistica({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  factory DadoEstatistica.fromJson(Map<String, dynamic> json) {
    return DadoEstatistica(
      icone: json['DadoIcone'] as String,
      rotulo: json['DadoRotulo'] as String,
      valor: json['DadoValor'] as String,
    );
  }
}

class EstatisticasInfo {
  final String titulo;
  final String capa;
  final List<DadoEstatistica> dados;
  final int notaBananas;
  final int notaTotal;
  final String notaImdb;
  final String siteOficial;

  const EstatisticasInfo({
    required this.titulo,
    required this.capa,
    required this.dados,
    required this.notaBananas,
    required this.notaTotal,
    required this.notaImdb,
    required this.siteOficial,
  });

  factory EstatisticasInfo.fromJson(Map<String, dynamic> json) {
    return EstatisticasInfo(
      titulo: json['EstatTitulo'] as String,
      capa: json['EstatCapa'] as String,
      dados: (json['EstatDados'] as List<dynamic>)
          .map((item) => DadoEstatistica.fromJson(item as Map<String, dynamic>))
          .toList(),
      notaBananas: json['EstatNotaBananas'] as int,
      notaTotal: json['EstatNotaTotal'] as int,
      notaImdb: json['EstatNotaImdb'] as String,
      siteOficial: json['EstatSiteOficial'] as String,
    );
  }
}

Future<EstatisticasInfo> carregarEstatisticas() async {
  final String texto = await rootBundle.loadString('assets/data/estatisticas.json');
  return EstatisticasInfo.fromJson(jsonDecode(texto) as Map<String, dynamic>);
}

class EstatisticasPage extends StatelessWidget {
  const EstatisticasPage({super.key});

  Future<void> _abrirSiteOficial(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarComNavegacao(context, 'Estatísticas', _Secao.estatisticas),

      body: FutureBuilder<EstatisticasInfo>(
        future: carregarEstatisticas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar estatísticas: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final EstatisticasInfo info = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const _TituloDePagina('Estatísticas'),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(info.capa),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.titulo,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: _azulEscuro,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (final dado in info.dados)
                              _LinhaDeDado(
                                _iconesPorNome[dado.icone] ?? Icons.info,
                                dado.rotulo,
                                dado.valor,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Avaliação média',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _azulEscuro,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Bananas(nota: info.notaBananas, total: info.notaTotal),
                      const SizedBox(height: 8),
                      Text(
                        info.notaImdb,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                TextButton.icon(
                  onPressed: () => _abrirSiteOficial(info.siteOficial),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text(
                    'Site Oficial do Filme',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: _azulJeans,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LinhaDeDado extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _LinhaDeDado(this.icone, this.rotulo, this.valor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: _azulJeans),
          const SizedBox(width: 8),
          Expanded(

            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$rotulo: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: valor),
                ],
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bananas extends StatelessWidget {
  final int nota;
  final int total;

  const _Bananas({required this.nota, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < total; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),

            child: Opacity(
              opacity: i < nota ? 1.0 : 0.25,
              child: const Text('🍌', style: TextStyle(fontSize: 34)),
            ),
          ),
      ],
    );
  }
}

class _TituloDePagina extends StatelessWidget {
  final String texto;

  const _TituloDePagina(this.texto);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texto,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: _azulEscuro,
          ),
        ),
        const SizedBox(height: 6),

        Container(
          width: 70,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}

class _ImagemArredondada extends StatelessWidget {
  final String caminho;

  const _ImagemArredondada(this.caminho);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          caminho,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _CartaoDeTexto extends StatelessWidget {
  final String texto;

  const _CartaoDeTexto(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: const Border(
          left: BorderSide(color: Colors.amber, width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        texto,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 17, height: 1.5),
      ),
    );
  }
}
