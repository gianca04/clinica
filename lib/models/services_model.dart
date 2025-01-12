class Service {
  final String? id;
  final String description;
  final String imagePath;
  final String name;
  final double price;

  Service({
    required this.id,
    required this.description,
    required this.imagePath,
    required this.name,
    required this.price,
  });

  // Factory constructor to create a Service instance from Firestore data
  factory Service.fromMap(String id, Map<String, dynamic> map) {
    return Service(
      id: id,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  // Method to convert Service instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'imagePath': imagePath,
      'name': name,
      'price': price,
    };
  }
}
