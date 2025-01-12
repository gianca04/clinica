import 'package:intl/intl.dart';
import 'package:clinica/models/appointment_model.dart';

class AppointmentService {
  // Lista simulada de citas (normalmente, esto sería una base de datos o API)
  List<Appointment> _appointments = [];

  // Métodos CRUD

  // Crear una nueva cita
  Future<void> createAppointment(Appointment appointment) async {
    // Simulación de guardado de cita
    _appointments.add(appointment);
  }

  // Editar una cita existente
  Future<void> updateAppointment(String id, Appointment updatedAppointment) async {
    int index = _appointments.indexWhere((appointment) => appointment.id == id);
    if (index != -1) {
      _appointments[index] = updatedAppointment;
    }
  }

  // Eliminar una cita
  Future<void> deleteAppointment(String id) async {
    _appointments.removeWhere((appointment) => appointment.id == id);
  }

  // Listar todas las citas
  Future<List<Appointment>> listAppointments() async {
    return _appointments;
  }

  // Buscar cita por DNI del cliente
  Future<List<Appointment>> searchAppointmentByDni(String dni) async {
    return _appointments.where((appointment) => appointment.dniCliente == dni).toList();
  }

  // Buscar citas por rango de fechas (formato "yyyy-MM-dd")
  Future<List<Appointment>> searchAppointmentsByDateRange(DateTime startDate, DateTime endDate) async {
    return _appointments.where((appointment) {
      DateTime appointmentDate = DateFormat('yyyy-MM-dd').parse(appointment.appointmentDate);
      return appointmentDate.isAfter(startDate) && appointmentDate.isBefore(endDate);
    }).toList();
  }

  // Marcar una cita como pagada
  Future<void> markAppointmentAsPaid(String id) async {
    int index = _appointments.indexWhere((appointment) => appointment.id == id);
    if (index != -1) {
      _appointments[index].estadoPago = "Pagada";
    }
  }
}
