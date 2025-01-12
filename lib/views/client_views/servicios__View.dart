import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinica/viewmodels/service_viewmodel.dart';
import 'package:clinica/views/admin_views/services/form_servicios.dart';
import 'package:clinica/models/app_color.dart';

class ServicesCliente extends StatefulWidget {
  @override
  _ServicesClienteState createState() => _ServicesClienteState();
}

class _ServicesClienteState extends State<ServicesCliente> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Servicios',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<ServiceViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (viewModel.services.isEmpty) {
            return Center(
                child: Text(
                  'No hay servicios disponibles',
                  style: TextStyle(color: AppColors.textSecondary),
                ));
          }

          return ListView.builder(
            itemCount: viewModel.services.length,
            itemBuilder: (context, index) {
              final service = viewModel.services[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: service.imagePath.isNotEmpty
                              ? Image.network(
                            service.imagePath,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
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
                            height: 80,
                            width: 80,
                            child: Icon(Icons.image_not_supported,
                                size: 40, color: AppColors.textSecondary),
                          ),
                        ),
                        title: Text(
                          service.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: \$${service.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: AppColors.textSecondary),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Especialista DNI: ${service.name}',
                                style: TextStyle(
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors.textSecondary.withOpacity(0.5),
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          service.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServiceFormScreen()),
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
          title: Text(
            'Eliminar Servicio',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar este servicio?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Provider.of<ServiceViewModel>(context, listen: false)
                    .deletePackage(package.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Servicio eliminado exitosamente',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
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
