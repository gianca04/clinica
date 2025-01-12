import 'package:clinica/viewmodels/TerapiaViewModel.dart';
import 'package:clinica/viewmodels/album_controller.dart';
import 'package:clinica/viewmodels/photo_controller.dart';
import 'package:clinica/views/admin_views/terapias/album_list_screen.dart';
import 'package:clinica/views/client_views/album_list_screen.dart';
import 'package:clinica/views/client_views/especialistView.dart';
import 'package:clinica/views/client_views/paqueteView.dart';
import 'package:clinica/views/client_views/serviciosView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Importa tus servicios y vistas
import 'package:clinica/services/services_service.dart';
import 'package:clinica/viewmodels/paquete_viewmodel.dart';
import 'package:clinica/viewmodels/service_viewmodel.dart';
import 'package:clinica/viewmodels/specialists_viewmodel.dart';
import 'package:clinica/viewmodels/appointment_viewmodel.dart';
import 'package:clinica/viewmodels/auth_view_model.dart';

import 'views/client_views.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/admin_views/home_screen.dart';
import 'views/admin_views/profile_screen.dart';
import 'views/admin_views/settings_screen.dart';
import 'views/admin_views/especialistas/screen_especialistas.dart';
import 'views/admin_views/paquetes/screen_paquetes.dart';
import 'views/admin_views/services/screen_servicios.dart';
import 'views/admin_views/citas_admin/terapiaView.dart';
import 'views/admin_views/citas_admin/ver_citas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppInitializer());
}

class AppInitializer extends StatelessWidget {
  // Pantalla inicial con FutureBuilder para manejar el estado de inicialización
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Muestra pantalla de carga mientras inicializa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: LoadingScreen());
        }
        // Muestra mensaje de error si la inicialización falla
        if (snapshot.hasError) {
          return MaterialApp(home: ErrorScreen());
        }
        // Inicializa la app una vez que Firebase está listo
        return MyApp();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => PackageViewModel()),
        ChangeNotifierProvider(create: (context) => SpecialistsViewModel()),
        ChangeNotifierProvider(create: (context) => ServiceViewModel()),
        ChangeNotifierProvider(create: (context) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => AlbumController()),
        ChangeNotifierProvider(create: (_) => PhotoController()),
      ],
      child: MaterialApp(
        title: 'Flutter Auth',
        initialRoute: '/homecliente',
        routes: {
          '/homecliente': (context) => HomeScreenCliente(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/homeadmin': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
          '/servicios': (context) => ServicesScreen(),
          '/paquetes': (context) => PackagesScreen(),
          '/especialistas': (context) => SpecialistScreenState(),
          '/citas': (context) => TerapiaCliente(),
          '/settings': (context) => SettingsScreen(),

          '/galeriaScreen': (context) => AlbumListScreen(),

          '/serviciosCliente': (context) => ServicesCliente(),
          '/especialistaCliente': (context) => SpecialistScreenCliente(),
          '/paqueteCliente': (context) => PackagesCliente(),
          '/terapiaCliente': (context) => AlbumListScreenCliente(),
        },
      ),
    );
  }
}

// Pantalla de carga mientras Firebase se inicializa
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// Pantalla de error en caso de que haya problemas con Firebase
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Error al inicializar Firebase")),
    );
  }
}
