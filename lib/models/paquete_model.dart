class Package {
  final String? id;  // Será opcional para permitir su asignación en Firebase
  final String description;
  final String especialistadni;
  final String imglink;
  final String name;
  final double price;

  Package({
    this.id,
    required this.description,
    required this.especialistadni,
    required this.imglink,
    required this.name,
    required this.price,
  });

  // Convierte el objeto en un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'especialistadni': especialistadni,
      'imglink': imglink,
      'name': name,
      'price': price,
    };
  }

  // Crea un objeto Package desde un mapa
  factory Package.fromMap(String id, Map<String, dynamic> map) {
    return Package(
      id: id,
      description: map['description'] as String,
      especialistadni: map['especialistadni'] as String,
      imglink: map['imglink'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }
}
