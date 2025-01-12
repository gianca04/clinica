import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinica/viewmodels/paquete_viewmodel.dart';
import 'package:clinica/views/admin_views/paquetes/form_paquetes.dart';
import 'package:clinica/models/app_color.dart'; // Asegúrate de importar tu clase de colores

class PackagesScreen extends StatefulWidget {
  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  void initState() {
    super.initState();
    // Llamada inicial para cargar los paquetes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PackageViewModel>(context, listen: false).fetchPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Paquetes',
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<PackageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (viewModel.packages.isEmpty) {
            return Center(
                child: Text('No hay paquetes disponibles',
                    style: TextStyle(color: AppColors.textSecondary)));
          }

          return ListView.builder(
            itemCount: viewModel.packages.length,
            itemBuilder: (context, index) {
              final package = viewModel.packages[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: package.imglink.isNotEmpty
                              ? Image.network(
                                  package.imglink,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error,
                                        color: Colors.red, size: 40);
                                  },
                                )
                              : Container(
                                  color: AppColors.inputBackground,
                                  height: 100,
                                  child: Icon(Icons.image_not_supported,
                                      size: 40, color: AppColors.textSecondary),
                                ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                                'Precio: \$${package.price.toStringAsFixed(2)}',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                            SizedBox(height: 4),
                            Text('Especialista DNI: ${package.especialistadni}',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.delete, color: AppColors.textSecondary),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, package);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.primary),
                        onPressed: () {
                          // Navegar al formulario de edición, pasando el paquete actual
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PackageFormScreen(package: package),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega al formulario para registrar un nuevo paquete sin pasar un paquete existente
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackageFormScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
        tooltip: 'Registrar nuevo paquete',
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Paquete',
              style: TextStyle(color: AppColors.textPrimary)),
          content: Text('¿Estás seguro de que deseas eliminar este paquete?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              child:
                  Text('Cancelar', style: TextStyle(color: AppColors.primary)),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Llama al método para eliminar el paquete
                Provider.of<PackageViewModel>(context, listen: false)
                    .deletePackage(package
                        .id); // Asegúrate de tener un método de eliminación
                Navigator.of(context).pop(); // Cierra el diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Paquete eliminado exitosamente',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
