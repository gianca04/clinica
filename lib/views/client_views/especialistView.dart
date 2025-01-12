import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinica/viewmodels/specialists_viewmodel.dart';
import 'package:clinica/models/app_color.dart';

import '../../models/specialists_model.dart';

class SpecialistScreenCliente extends StatefulWidget {
  @override
  _SpecialistScreenState createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreenCliente> {
  @override
  void initState() {
    super.initState();
    // Llamada inicial para cargar los especialistas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpecialistsViewModel>(context, listen: false).fetchSpecialists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Especialistas', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<SpecialistsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (viewModel.specialist.isEmpty) {
            return Center(child: Text('No hay especialistas disponibles', style: TextStyle(color: AppColors.textSecondary)));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: viewModel.specialist.length,
              itemBuilder: (context, index) {
                final specialist = viewModel.specialist[index];
                return _buildSpecialistCard(context, specialist);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialistCard(BuildContext context, Specialist specialist) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Imagen de perfil más grande y estilizada
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: specialist.urlFoto.isNotEmpty
                      ? Image.network(
                    specialist.urlFoto,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 80,
                    width: 80,
                    color: AppColors.inputBackground,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre completo del especialista
                      Text(
                        '${specialist.firstName} ${specialist.lastName}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4),
                      // Especialidad
                      Text(
                        specialist.specialty,
                        style: TextStyle(fontSize: 14, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(height: 16),
            // Información adicional
            _buildInfoRow('DNI:', specialist.dni),
            _buildInfoRow('Horario:', specialist.schedule),
            SizedBox(height: 16),
            Text(
              specialist.info,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            
          ],
        ),
      ),
    );
  }

  // Widget para mostrar las filas de información (DNI, horario, etc.)
  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
