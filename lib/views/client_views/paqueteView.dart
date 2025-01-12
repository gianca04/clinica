import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinica/viewmodels/paquete_viewmodel.dart';
import 'package:clinica/models/app_color.dart';

import 'form_citaCliente.dart'; // Asegúrate de importar tu clase de colores

class PackagesCliente extends StatefulWidget {
  @override
  _PackagesClienteState createState() => _PackagesClienteState();
}

class _PackagesClienteState extends State<PackagesCliente> {
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
        title: Text(
          'Paquetes Clínicos',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: Consumer<PackageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (viewModel.packages.isEmpty) {
            return Center(child: Text('No hay paquetes disponibles', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: viewModel.packages.length,
              itemBuilder: (context, index) {
                final package = viewModel.packages[index];
                return Card(
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
                        // Imagen grande del paquete
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: package.imglink.isNotEmpty
                              ? Image.network(
                            package.imglink,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image_not_supported, size: 40, color: AppColors.textSecondary);
                            },
                          )
                              : Container(
                            height: 200,
                            color: AppColors.inputBackground,
                            child: Icon(Icons.image_not_supported, size: 50, color: AppColors.textSecondary),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Nombre del paquete
                        Text(
                          package.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6),

                        // Descripción del paquete (expande con un botón si es larga)
                        _buildDescription(package.description),
                        SizedBox(height: 8),

                        // Etiquetas de precio y especialista
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTag('Precio', 'S/. ${package.price.toStringAsFixed(2)}'),
                            _buildTag('Especialista', package.especialistadni),

                          ],
                        ),
                        SizedBox(height: 12),

                        // Botón de "Me Interesa"
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {

                              // Navegar a ClientAppointmentFormScreen y pasar los parámetros
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClientAppointmentFormScreen(
                                    nombreCita: package.name,
                                    tipoCita: "Paquete",
                                  ),
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Me Interesa',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Widget para manejar la descripción larga y un botón de "ver más"
  Widget _buildDescription(String description) {
    final bool isLongDescription = description.length > 100; // Ajusta según lo que consideres largo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLongDescription ? description.substring(0, 100) + '...' : description,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        if (isLongDescription)
          GestureDetector(
            onTap: () {
              // Aquí podrías expandir la descripción o mostrar los detalles completos
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Descripción Completa"),
                    content: SingleChildScrollView(
                      child: Text(description),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cerrar"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'Ver más...',
              style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  // Widget para las etiquetas de precio y especialista
  Widget _buildTag(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.label, size: 16, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            '$title: $value',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
