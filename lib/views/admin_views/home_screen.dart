import 'package:flutter/material.dart';
import 'package:clinica/models/app_color.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_view_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  'Clínica Virgen de Guadalupe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Inicio',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.medical_services,
              text: 'Servicios',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/servicios');
              },
            ),
            _buildDrawerItem(
              icon: Icons.account_box,
              text: 'Crear nuevo usuario',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signup');
              },
            ),
            _buildDrawerItem(
              icon: Icons.inventory_2,
              text: 'Paquetes',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/paquetes');
              },
            ),
            _buildDrawerItem(
              icon: Icons.add_chart_outlined,
              text: 'El Progreso De Mi Terapia',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/paquetes');
              },
            ),
            _buildDrawerItem(
              icon: Icons.diversity_3,
              text: 'Especialistas',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/especialistas');
              },
            ),
            _buildDrawerItem(
              icon: Icons.assignment_turned_in,
              text: 'Administrar Citas',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/citas');
              },
            ),
            _buildDrawerItem(
              icon: Icons.assignment_turned_in,
              text: 'Galeria Citas',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/galeriaScreen');
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Cerrar Sesión',
              onTap: () async {
                Navigator.pushReplacementNamed(context, '/homecliente');
                Provider.of<AuthViewModel>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 100, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              '¡Bienvenido a Clínica Virgen de Guadalupe!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Nos especializamos en rehabilitación y cuidados para tu salud',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
