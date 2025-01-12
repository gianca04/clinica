import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homecliente');
          },
        ),
      ),
      body: Center(
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Clínica Virgen de Guadalupe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushReplacementNamed('/homeadmin');
                      //await authViewModel.signIn(
                      //  emailController.text,
                      //  passwordController.text,
                      //);
                      //if (authViewModel.errorMessage != null) {
                      //  ScaffoldMessenger.of(context).showSnackBar(
                      //    SnackBar(content: Text(authViewModel.errorMessage!)),
                      //  );
                      //} else {
                      //  Navigator.of(context).pushReplacementNamed('/homeadmin');
                      //}
                    },
                    child: Text('Iniciar Sesión'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
