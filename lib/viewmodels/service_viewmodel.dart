import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clinica/models/services_model.dart';
import 'package:clinica/services/services_service.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServicesService _servicesService = ServicesService();
  bool _isLoading = false;
  List<Service> _services = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Service> get services => _services;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Método para agregar un nuevo servicio
  Future<void> addPackage(Service service) async {
    _setLoading(true);

    try {
      await _servicesService.addService(service);
      _setError(null); // Limpiar error si se agrega con éxito
    } catch (e) {
      _setError('Error al agregar el servicio: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener los servicios y notificarlos
  Future<void> fetchServices() async {
    _setLoading(true);
    print("Fetching services...");
    try {
      _services = await _servicesService.fetchServices();
      print("Services fetched: $_services");
      _setError(null);
    } catch (e) {
      _setError('Error al obtener los servicios: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para eliminar un servicio
  Future<void> deletePackage(String packageId) async {
    _setLoading(true);

    try {
      await _servicesService.deletePackage(packageId);
      _services.removeWhere((package) => package.id == packageId);
      _setError(null); // Limpiar error si se elimina con éxito
    } catch (e) {
      _setError('Error al eliminar el servicio: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para actualizar un servicio
  Future<void> updatePackage(Service service) async {
    _setLoading(true);

    try {
      await _servicesService.updateService(service);
      int index = _services.indexWhere((p) => p.id == service.id);
      if (index != -1) {
        _services[index] = service; // Actualiza el servicio en la lista
      }
      _setError(null); // Limpiar error si se actualiza con éxito
    } catch (e) {
      _setError('Error al actualizar el servicio: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Subir imagen
  Future<String> uploadImage(File imageFile) async {
    return await _servicesService.uploadImage(imageFile);
  }

  // Buscar servicio por nombre
  Future<void> buscarServicio(String name) async {
    _setLoading(true);

    try {
      // Realizamos la consulta en Firestore usando el nombre
      QuerySnapshot snapshot = await  _servicesService.servicesCollection// Asegúrate de que 'services' es el nombre correcto de la colección
          .where('name', isGreaterThanOrEqualTo: name)
          .get();

      // Convertimos los documentos obtenidos en una lista de objetos Service
      _services = snapshot.docs
          .map((doc) => Service.fromMap(doc.data() as String, doc.id as Map<String, dynamic>))
          .toList();

      _setError(null); // Limpiar error si se obtiene la búsqueda con éxito
    } catch (e) {
      _setError('Error al buscar el servicio: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
}
