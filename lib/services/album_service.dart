import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/album.dart';

class AlbumService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Crear un nuevo álbum
  Future<void> createAlbum(Album album) async {
    try {
      await _db.collection('albums').add(album.toMap());
    } catch (e) {
      throw Exception('Error creando el álbum: $e');
    }
  }

  // Obtener un solo álbum por su ID
  Future<Album?> getAlbumById(String id) async {
    try {
      final doc = await _db.collection('albums').doc(id).get();
      if (doc.exists) {
        return Album.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      } else {
        return null; // Si no existe el álbum, retorna null
      }
    } catch (e) {
      throw Exception('Error obteniendo el álbum: $e');
    }
  }


  // Obtener todos los álbumes
  Stream<List<Album>> getAlbums() {
    return _db.collection('albums').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Album.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Actualizar un álbum
  Future<void> updateAlbum(String id, Album album) async {
    try {
      await _db.collection('albums').doc(id).update(album.toMap());
    } catch (e) {
      throw Exception('Error actualizando el álbum: $e');
    }
  }



  // Eliminar un álbum
  Future<void> deleteAlbum(String id) async {
    try {
      await _db.collection('albums').doc(id).delete();
    } catch (e) {
      throw Exception('Error eliminando el álbum: $e');
    }
  }
}
