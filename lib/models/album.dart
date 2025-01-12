class Album {
  String id;
  String name;
  String description;

  Album({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory Album.fromMap(String id, Map<String, dynamic> map) {
    return Album(
      id: id,
      name: map['name'],
      description: map['description'],
    );
  }
}
