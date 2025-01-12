import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clinica/views/login_screen.dart';
import 'package:clinica/views/signup_screen.dart';
class HomeScreenCliente extends StatelessWidget {
  const HomeScreenCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login'
              );
            },
          ),

        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.pink[100],
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Clínica de Terapia Física & Rehabilitación\nVirgen de Guadalupe',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Image.asset('assets/logo.png', height: 50),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildImageButton(
                      context,
                      'assets/specialists.jpg',
                      'Conoce a los Especialistas',
                          () => Navigator.pushNamed(context, '/especialistaCliente'),
                    ),
                    const SizedBox(height: 16),
                    _buildImageButton(
                      context,
                      'assets/services.jpg',
                      'Todos los Servicios',
                          () => Navigator.pushNamed(context, '/serviciosCliente'),
                    ),
                    const SizedBox(height: 16),
                    _buildImageButton(
                      context,
                      'assets/packages.jpg',
                      'Paquetes / Promociones',
                            () => Navigator.pushNamed(context, '/paqueteCliente'),
                    ),
                    const SizedBox(height: 16),
                    _buildImageButton(
                      context,
                      'assets/gallery.jpg',
                      'El progreso de tu Terapia',
                            () => Navigator.pushNamed(context, '/terapiaCliente'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircularIconButton('assets/facebook_logo.jpg', () => _launchURL('https://www.facebook.com/TerapiaFisicaVirgenGuadalupe')),
                    _buildCircularIconButton('assets/whatsapp_logo.png', () => _launchURL('https://wa.me/921047618')),
                    _buildCircularIconButton('assets/location_logo.png', () => _launchURL('https://maps.app.goo.gl/wWPjoBegaPpvWJiVA')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(BuildContext context, String imagePath, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIconButton(String imagePath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
