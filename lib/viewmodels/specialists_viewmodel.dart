import 'dart:io';

import 'package:clinica/models/specialists_model.dart';
import 'package:clinica/services/specialists_service.dart';
import 'package:flutter/material.dart';

class SpecialistsViewModel extends ChangeNotifier {
  final SpecialistsService _specialistsService = SpecialistsService();
  bool _isLoading = false;
  List<Specialist> _specialists = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Specialist> get specialist => _specialists;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<List<Specialist>> getSpecialistsByDni(String dni) async {
    _setLoading(true);
    try {
      final specialist = await _specialistsService.buscarDni(dni);
      _setError(null); // Limpiar error si se agrega con éxito
      return specialist;
    } catch (e) {
      _setError('Error al buscar el especialista: ${e.toString()}');
      rethrow; // Opcional, si quieres que el error sea propagado
    } finally {
      _setLoading(false);
    }
  }

  // Método para agregar un nuevo paquete
  Future<void> addSpecialist(Specialist specialist) async {
    _setLoading(true);

    try {
      await _specialistsService.addSpecialists(specialist);
      _setError(null); // Limpiar error si se agrega con éxito
    } catch (e) {
      _setError('Error al agregar el paquete: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener los paquetes y notificarlos
  Future<void> fetchSpecialists() async {
    _setLoading(true);
    try {
      _specialists = await _specialistsService.fetchPackages();
      _setError(null); // Limpiar error si se obtienen con éxito
    } catch (e) {
      _setError('Error al obtener los especialistas: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para eliminar un paquete
  Future<void> deleteSpecialist(String specialistId) async {
    _setLoading(true);

    try {
      await _specialistsService.deletePackage(specialistId);
      _specialists.removeWhere((specialist) => specialist.id == specialistId);
      _setError(null); // Limpiar error si se elimina con éxito
    } catch (e) {
      _setError('Error al eliminar el paquete: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para actualizar un paquete
  Future<void> updateSpecialist(Specialist specialist) async {
    _setLoading(true);

    try {
      await _specialistsService.updateSpecialists(specialist);
      int index = _specialists.indexWhere((s) => s.id == specialist.dni);
      if (index != -1) {
        _specialists[index] = specialist; // Actualiza el paquete en la lista
      }
      _setError(null); // Limpiar error si se actualiza con éxito
    } catch (e) {
      _setError('Error al actualizar el paquete: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<String> uploadImage(File imageFile, String dni) async {
    return await _specialistsService.uploadImage(imageFile, dni);
  }
}
