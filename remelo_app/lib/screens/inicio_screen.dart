import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, String>> promociones = [
    {'titulo': 'Nuevas camisetas 3D', 'imagen': 'promo1.jpg'},
    {'titulo': '20% de descuento', 'imagen': 'promo2.jpg'},
    {'titulo': 'Diseños personalizados', 'imagen': 'promo3.jpg'},
  ];

  final List<Map<String, String>> loMasTop = [
    {'nombre': 'Camiseta negra', 'precio': '\$35.000', 'imagen': 'producto1.jpg'},
    {'nombre': 'Camiseta blanca', 'precio': '\$40.000', 'imagen': 'producto2.jpg'},
    {'nombre': 'Camiseta personalizada', 'precio': '\$50.000', 'imagen': 'producto3.jpg'},
    {'nombre': 'Camiseta oversize', 'precio': '\$45.000', 'imagen': 'producto4.jpg'},
    {'nombre': 'Camiseta gráfica', 'precio': '\$38.000', 'imagen': 'producto5.jpg'},
    {'nombre': 'Camiseta urbana', 'precio': '\$42.000', 'imagen': 'producto6.jpg'},
  ];

  final List<Map<String, String>> especiales = [
    {'nombre': 'Madre', 'precio': '\$39.000', 'imagen': 'especial1.jpg'},
    {'nombre': 'Halloween', 'precio': '\$41.000', 'imagen': 'especial2.jpg'},
    {'nombre': 'Navidad', 'precio': '\$42.000', 'imagen': 'especial3.jpg'},
    {'nombre': 'San Valentín', 'precio': '\$43.000', 'imagen': 'especial4.jpg'},
    {'nombre': 'Pascua', 'precio': '\$44.000', 'imagen': 'especial5.jpg'},
    {'nombre': 'Año nuevo', 'precio': '\$45.000', 'imagen': 'especial6.jpg'},
  ];

  final List<Map<String, String>> deportivas = [
    {'nombre': 'Fútbol', 'precio': '\$39.000', 'imagen': 'deporte1.jpg'},
    {'nombre': 'Basket', 'precio': '\$41.000', 'imagen': 'deporte2.jpg'},
    {'nombre': 'Running', 'precio': '\$42.000', 'imagen': 'deporte3.jpg'},
    {'nombre': 'Gym', 'precio': '\$43.000', 'imagen': 'deporte4.jpg'},
    {'nombre': 'Skate', 'precio': '\$44.000', 'imagen': 'deporte5.jpg'},
    {'nombre': 'Ciclismo', 'precio': '\$45.000', 'imagen': 'deporte6.jpg'},
  ];

  final List<Map<String, String>> cineAnime = [
    {'nombre': 'Naruto', 'precio': '\$55.000', 'imagen': 'cine1.jpg'},
    {'nombre': 'Goku', 'precio': '\$56.000', 'imagen': 'cine2.jpg'},
    {'nombre': 'Luffy', 'precio': '\$57.000', 'imagen': 'cine3.jpg'},
    {'nombre': 'Spiderman', 'precio': '\$58.000', 'imagen': 'cine4.jpg'},
    {'nombre': 'Batman', 'precio': '\$59.000', 'imagen': 'cine5.jpg'},
    {'nombre': 'Ironman', 'precio': '\$60.000', 'imagen': 'cine6.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        final nextPage = (_currentIndex + 1) % promociones.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() => _currentIndex = nextPage);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _abrirPaginaWeb() async {
    final Uri url = Uri.parse('http://127.0.0.1:8000');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir la URL';
    }
  }

  Widget _buildSeccion(String titulo, List<Map<String, String>> productos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            'assets/images/${producto['imagen']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(producto['nombre']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(producto['precio']!),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _abrirPaginaWeb,
                              child: const Text('Ver en Web'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                minimumSize: const Size.fromHeight(30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: ListView(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: promociones.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final promo = promociones[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset('assets/images/${promo['imagen']}', fit: BoxFit.cover),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Text(
                            promo['titulo']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              promociones.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          _buildSeccion('Lo más TOP', loMasTop),
          _buildSeccion('Camisetas fechas especiales', especiales),
          _buildSeccion('Camisetas deportivas', deportivas),
          _buildSeccion('Camisetas Cine y Anime', cineAnime),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
