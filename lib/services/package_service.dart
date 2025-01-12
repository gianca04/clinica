import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinica/models/paquete_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PackageService {
  final CollectionReference packagesCollection = FirebaseFirestore.instance.collection('packages');
  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

  // Método para agregar un nuevo paquete
  Future<void> addPackage(Package package) async {
    try {
      await packagesCollection.add(package.toMap());
    } catch (e) {
      throw Exception('Error al agregar el paquete: $e');
    }
  }

  // Método para obtener la lista de paquetes desde Firebase
  Future<List<Package>> fetchPackages() async {
    try {
      final querySnapshot = await packagesCollection.get();
      return querySnapshot.docs
          .map((doc) => Package.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los paquetes: $e');
    }
  }

  // Método para eliminar un paquete
  Future<void> deletePackage(String packageId) async {
    try {
      await packagesCollection.doc(packageId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el paquete: $e');
    }
  }

  // Método para actualizar un paquete
  Future<void> updatePackage(Package package) async {
    try {
      await packagesCollection.doc(package.id).update(package.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el paquete: $e');
    }
  }

  // Método para subir una imagen y obtener su URL
  Future<String> uploadImage(File imageFile) async {
    try {
      // Reference to Firebase Storage
      final ref = storageRef.child('img_paquetes/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL(); // Obtiene la URL de descarga
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }
}
