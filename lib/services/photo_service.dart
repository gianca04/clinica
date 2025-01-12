import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../models/photo.dart';

class PhotoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Subir una foto a Firebase Storage
  Future<String> uploadImage(Uint8List file, String fileName) async {
    try {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('photos/$fileName')
          .putData(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error subiendo la imagen: $e');
    }
  }

  // Crear una nueva foto en Firestore
  Future<void> createPhoto(Photo photo) async {
    try {
      await _db.collection('photos').add(photo.toMap());
    } catch (e) {
      throw Exception('Error creando la foto: $e');
    }
  }

  // Obtener las fotos de un álbum
  Stream<List<Photo>> getPhotos(String albumId) {
    return _db
        .collection('photos')
        .where('albumId', isEqualTo: albumId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Photo.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Eliminar una foto
  Future<void> deletePhoto(String id) async {
    try {
      await _db.collection('photos').doc(id).delete();
    } catch (e) {
      throw Exception('Error eliminando la foto: $e');
    }
  }
}
