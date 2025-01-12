import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:clinica/models/appointment_model.dart';
import 'package:clinica/models/app_color.dart';
import '../../../viewmodels/appointment_viewmodel.dart';

class ClientAppointmentFormScreen extends StatefulWidget {
  final String nombreCita;
  final String tipoCita;

  const ClientAppointmentFormScreen({
    Key? key,
    required this.nombreCita,
    required this.tipoCita,
  }) : super(key: key);

  @override
  _ClientAppointmentFormScreenState createState() =>
      _ClientAppointmentFormScreenState();
}

class _ClientAppointmentFormScreenState
    extends State<ClientAppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _clientNameController;
  late TextEditingController _dniController;
  late TextEditingController _telefonoController;
  late DateTime _appointmentDate;

  // Valores predeterminados no editables
  String _estadoPago = 'Pendiente';
  String _status = 'Confirmada';

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _dniController = TextEditingController();
    _telefonoController = TextEditingController();
    _appointmentDate = DateTime.now();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // Método para manejar la creación de la cita
  Future<void> _handleSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final appointment = Appointment(
        id: DateTime.now().toString(),  // Generar un ID único
        clientName: _clientNameController.text,
        appointmentDate: _appointmentDate.toIso8601String(),
        dniCliente: _dniController.text,
        estadoPago: _estadoPago,  // Valor fijo
        status: _status,          // Valor fijo
        telefono: _telefonoController.text,
        tipoCita: widget.tipoCita, // El tipo de cita viene como parámetro
        nombreCita: widget.nombreCita, // El nombre de la cita viene como parámetro
      );

      // Crear la cita a través del ViewModel
      await Provider.of<AppointmentViewModel>(context, listen: false)
          .createAppointment(appointment);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita registrada exitosamente')),
      );
      Navigator.pop(context);  // Volver a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Consulta'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nombre del Cliente', _clientNameController),
              _buildTextField('DNI del Cliente', _dniController),
              _buildTextField('Teléfono', _telefonoController),
              _buildCalendar(),
              _buildReadOnlyField('Nombre de la Cita', widget.nombreCita),
              _buildReadOnlyField('Tipo de Cita', widget.tipoCita),
              // Los campos 'Estado de Pago' y 'Estado de Cita' no son editables
              _buildReadOnlyField('Estado de Pago', _estadoPago),
              _buildReadOnlyField('Estado de la Cita', _status),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleSubmit(context),
                child: Text('Registrar Cita'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label es requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        readOnly: true, // Hacer el campo solo de lectura
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        color: AppColors.inputBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TableCalendar(
            focusedDay: _appointmentDate,
            firstDay: DateTime.utc(2000),
            lastDay: DateTime.utc(2100),
            selectedDayPredicate: (day) => isSameDay(day, _appointmentDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _appointmentDate = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
