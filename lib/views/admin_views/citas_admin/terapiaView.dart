import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/appointment_model.dart';
import '../../../../../models/app_color.dart';
import '../../../../../viewmodels/appointment_viewmodel.dart';
import 'package:clinica/views/admin_views/citas_admin/ver_citas.dart';

class TerapiaCliente extends StatefulWidget {
  @override
  _TerapiaClienteState createState() => _TerapiaClienteState();
}

class _TerapiaClienteState extends State<TerapiaCliente> {
  final TextEditingController _dniController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final appointmentViewModel = Provider.of<AppointmentViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar mi Cita',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Búsqueda de Citas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Búsqueda por DNI
            _buildSearchBar(context, appointmentViewModel),
            const SizedBox(height: 16),

            // Filtros de Fecha
            _buildDateFilters(context, appointmentViewModel),
            const SizedBox(height: 16),

            // Lista de Citas
            Expanded(
              child: appointmentViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : appointmentViewModel.appointments.isEmpty
                  ? const Center(
                child: Text(
                  'No se encontraron citas.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: appointmentViewModel.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointmentViewModel.appointments[index];
                  return _buildAppointmentCard(context, appointment);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentFormScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Registrar nueva cita',
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppointmentViewModel appointmentViewModel) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _dniController,
            decoration: InputDecoration(
              labelText: 'Buscar por DNI',
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.primary),
          onPressed: () {
            if (_dniController.text.isNotEmpty) {
              appointmentViewModel.searchAppointmentsByDni(_dniController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, ingresa un DNI válido')),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.clear, color: AppColors.textSecondary),
          onPressed: () {
            _dniController.clear();
            appointmentViewModel.loadAppointments(); // Trae todas las citas nuevamente
          },
        ),
      ],
    );
  }

  Widget _buildDateFilters(BuildContext context, AppointmentViewModel appointmentViewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => _selectDate(context, isStartDate: true),
          icon: const Icon(Icons.date_range, color: AppColors.primary),
          label: Text(
            _startDate != null
                ? 'Inicio: ${_startDate!.toLocal()}'.split(' ')[0]
                : 'Fecha Inicio',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
        TextButton.icon(
          onPressed: () => _selectDate(context, isStartDate: false),
          icon: const Icon(Icons.date_range, color: AppColors.primary),
          label: Text(
            _endDate != null
                ? 'Fin: ${_endDate!.toLocal()}'.split(' ')[0]
                : 'Fecha Fin',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            if (_startDate != null && _endDate != null) {
              appointmentViewModel.searchAppointmentsByDateRange(_startDate!, _endDate!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seleccione ambas fechas')),
              );
            }
          },
          child: const Text('Filtrar'),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(appointment.clientName[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          appointment.clientName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Fecha: ${appointment.appointmentDate}'),
            Text('DNI: ${appointment.dniCliente}'),
            Text('Estado de pago: ${appointment.estadoPago}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentFormScreen(appointment: appointment)),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }
}
