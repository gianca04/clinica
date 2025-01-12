import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:clinica/models/specialists_model.dart';

class SpecialistsService {
  final CollectionReference specialistColletion = FirebaseFirestore.instance.collection('specialists');
  final storageRef = FirebaseStorage.instance.ref();

  // Método para crear un nuevo especialista
  Future<void> addSpecialists(Specialist specialist) async {
    try{
      await specialistColletion.add(specialist.toMap());
    } catch (e){
      throw Exception('Error al agregar el especialista: $e');
    }
  }

  // Método para obtener la lista de paquetes desde Firebase
  Future<List<Specialist>> fetchPackages() async {
    try {
      final querySnapshot = await specialistColletion.get();
      return querySnapshot.docs
          .map((doc) => Specialist.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los especialistas: $e');
    }
  }

  // Método para eliminar un especialista
  Future<void> deletePackage(String specialistsId) async {
    try {
      await specialistColletion.doc(specialistsId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el paquete: $e');
    }
  }

  // Método para actualizar un paquete
  Future<void> updateSpecialists(Specialist specialist) async {
    try {
      await specialistColletion.doc(specialist.id).update(specialist.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el especialista: $e');
    }
  }

  // Método para subir una imagen y obtener su URL
  Future<String> uploadImage(File imageFile, String dni) async {
    try {
      // Reference to Firebase Storage
      final ref = storageRef.child('img_specialists/${dni}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL(); // Obtiene la URL de descarga
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Buscar servicio por nombre
  Future<List<Specialist>> buscarDni(String dni) async {
    try {
      // Realizamos la consulta en Firebase usando el nombre
      QuerySnapshot snapshot = await specialistColletion
          .where('dni', isEqualTo: dni) // Asegúrate de que 'name' es el campo correcto en tu Firestore
          .get();

      // Convertimos los documentos obtenidos en una lista de objetos Service
      return snapshot.docs
          .map((doc) => Specialist.fromMap(doc.data() as String, doc.id as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar el servicio: $e');
    }
  }
}