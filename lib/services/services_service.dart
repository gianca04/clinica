import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:clinica/models/services_model.dart';

class ServicesService {
  final CollectionReference servicesCollection = FirebaseFirestore.instance.collection('services');
  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> addService(Service service) async {
    try {
      await servicesCollection.add(service.toMap());
    } catch (e) {
      throw Exception('Error al agregar un nuevo servicio: $e');
    }
  }

  // Método para obtener la lista de servicios desde Firebase
  Future<List<Service>> fetchServices() async {
    try {
      final querySnapshot = await servicesCollection.get();
      return querySnapshot.docs
          .map((doc) => Service.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los servicios: $e');
    }
  }

  // Método para actualizar un paquete
  Future<void> updateService(Service service) async {
    try {
      await servicesCollection.doc(service.id).update(service.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el paquete: $e');
    }
  }


  // Método para eliminar un servicio
  Future<void> deletePackage(String serviceId) async {
    try {
      await servicesCollection.doc(serviceId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el servicio: $e');
    }
  }

  // Método para subir una imagen y obtener su URL
  Future<String> uploadImage(File imageFile) async {
    try {
      // Reference to Firebase Storage
      final ref = storageRef.child('img_servicios/${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL(); // Obtiene la URL de descarga
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Buscar servicio por nombre
  Future<List<Service>> buscarServicio(String name) async {
    try {
      // Realizamos la consulta en Firebase usando el nombre
      QuerySnapshot snapshot = await servicesCollection
          .where('name', isEqualTo: name) // Asegúrate de que 'name' es el campo correcto en tu Firestore
          .get();

      // Convertimos los documentos obtenidos en una lista de objetos Service
      return snapshot.docs
          .map((doc) => Service.fromMap(doc.data() as String, doc.id as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar el servicio: $e');
    }
  }
}
