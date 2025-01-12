class Appointment {
  String id;
  String clientName;
  String appointmentDate; // Se usará un formato de fecha como "yyyy-MM-dd"
  String dniCliente;
  String estadoPago; // "Pendiente" o "Pagada"
  String status; // Puede ser "Confirmada", "Cancelada", etc.
  String telefono;
  String tipoCita; // Servicio o paquete
  String nombreCita;

  Appointment({
    required this.id,
    required this.clientName,
    required this.appointmentDate,
    required this.dniCliente,
    required this.estadoPago,
    required this.status,
    required this.telefono,
    required this.tipoCita,
    required this.nombreCita,
  });

  // Para convertir de un mapa a un objeto Appointment (por ejemplo, de JSON)
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      clientName: map['clientName'],
      appointmentDate: map['appointmentDate'],
      dniCliente: map['dniCliente'],
      estadoPago: map['estadoPago'],
      status: map['status'],
      telefono: map['telefono'],
      tipoCita: map['tipoCita'],
      nombreCita: map['nombreCita'],
    );
  }

  // Para convertir de un objeto Appointment a un mapa (por ejemplo, a JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'appointmentDate': appointmentDate,
      'dniCliente': dniCliente,
      'estadoPago': estadoPago,
      'status': status,
      'telefono': telefono,
      'tipoCita': tipoCita,
      'nombreCita': nombreCita,
    };
  }
}
