class Specialist {

  final String? id;  // Será opcional para permitir su asignación en Firebase
  final String dni;
  final String firstName;
  final String info;
  final String lastName;
  final String schedule;
  final String specialty;
  final String urlFoto;

  Specialist({
    this.id,
    required this.dni,
    required this.firstName,
    required this.info,
    required this.lastName,
    required this.schedule,
    required this.specialty,
    required this.urlFoto,
  });

  Map<String, dynamic> toMap(){
    return {

      'dni': dni,
      'firstName': firstName,
      'info': info,
      'lastName': lastName,
      'schedule': schedule,
      'specialty': specialty,
      'urlFoto': urlFoto,
    };
  }

  factory Specialist.fromMap(String id, Map<String, dynamic> map){
    return Specialist(
        id: id,
        dni: map['dni'] as String,
        firstName: map['firstName'] as String,
        info: map['info'] as String,
        lastName: map['lastName'] as String,
        schedule: map['schedule'] as String,
        specialty: map['specialty'] as String,
        urlFoto: map['urlFoto'] as String
    );
  }
}