import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:clinica/models/appointment_model.dart';
import 'package:clinica/models/app_color.dart';
import '../../../viewmodels/appointment_viewmodel.dart';

class AppointmentFormScreen extends StatefulWidget {
  final Appointment? appointment;

  const AppointmentFormScreen({Key? key, this.appointment}) : super(key: key);

  @override
  _AppointmentFormScreenState createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _clientNameController;
  late TextEditingController _dniController;
  late TextEditingController _telefonoController;
  late TextEditingController _tipoCitaController;
  late TextEditingController _nombreCitaController;
  late DateTime _appointmentDate;

  String _estadoPago = 'Pendiente';  // Valor inicial
  String _status = 'Confirmada';     // Valor inicial

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _clientNameController = TextEditingController(text: widget.appointment!.clientName);
      _dniController = TextEditingController(text: widget.appointment!.dniCliente);
      _telefonoController = TextEditingController(text: widget.appointment!.telefono);
      _tipoCitaController = TextEditingController(text: widget.appointment!.tipoCita);
      _nombreCitaController = TextEditingController(text: widget.appointment!.nombreCita);
      _appointmentDate = DateTime.parse(widget.appointment!.appointmentDate);
      _estadoPago = widget.appointment!.estadoPago;
      _status = widget.appointment!.status;
    } else {
      _clientNameController = TextEditingController();
      _dniController = TextEditingController();
      _telefonoController = TextEditingController();
      _tipoCitaController = TextEditingController();
      _nombreCitaController = TextEditingController();
      _appointmentDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    _tipoCitaController.dispose();
    _nombreCitaController.dispose();
    super.dispose();
  }

  // Método para manejar la creación o actualización de la cita
  Future<void> _handleSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final appointment = Appointment(
        id: widget.appointment?.id ?? DateTime.now().toString(),  // Si es nueva, generamos un ID temporal
        clientName: _clientNameController.text,
        appointmentDate: _appointmentDate.toIso8601String(),
        dniCliente: _dniController.text,
        estadoPago: _estadoPago,  // Usando el valor seleccionado
        status: _status,          // Usando el valor seleccionado
        telefono: _telefonoController.text,
        tipoCita: _tipoCitaController.text,
        nombreCita: _nombreCitaController.text,
      );

      if (widget.appointment == null) {
        // Si es un formulario de creación
        await Provider.of<AppointmentViewModel>(context, listen: false)
            .createAppointment(appointment);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita creada exitosamente')),
        );
      } else {
        // Si es un formulario de edición
        await Provider.of<AppointmentViewModel>(context, listen: false)
            .updateAppointment(appointment.id, appointment);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita actualizada exitosamente')),
        );
      }
      Navigator.pop(context);  // Volver a la pantalla anterior
    }
  }

  // Método para manejar la eliminación de la cita
  Future<void> _handleDelete(BuildContext context) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cita'),
          content: Text('¿Estás seguro de que deseas eliminar esta cita?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      await Provider.of<AppointmentViewModel>(context, listen: false)
          .deleteAppointment(widget.appointment!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita eliminada exitosamente')),
      );
      Navigator.pop(context);  // Volver a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null ? 'Nueva Cita' : 'Editar Cita'),
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
              _buildTextField('Tipo de Cita', _tipoCitaController),
              _buildTextField('Nombre de la Cita', _nombreCitaController),
              _buildCalendar(),
              _buildDropdownField('Estado de Pago', _estadoPago, ['Pendiente', 'Pagada'], (String? newValue) {
                setState(() {
                  _estadoPago = newValue!;
                });
              }),
              _buildDropdownField('Estado de la Cita', _status, ['Confirmada', 'Cancelada'], (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleSubmit(context),
                child: Text(widget.appointment == null ? 'Crear Cita' : 'Actualizar Cita'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              if (widget.appointment != null) ...[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleDelete(context),
                  child: Text('Eliminar Cita'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,  // Botón rojo para eliminar
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ]
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

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label es requerido';
          }
          return null;
        },
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
