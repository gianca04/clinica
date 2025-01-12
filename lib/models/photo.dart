class Photo {
  String id;
  String albumId;
  String name;
  String description;
  String imageUrl;

  Photo({
    required this.id,
    required this.albumId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'albumId': albumId,
    };
  }

  factory Photo.fromMap(String id, Map<String, dynamic> map) {
    return Photo(
      id: id,
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      albumId: map['albumId'],
    );
  }
}
