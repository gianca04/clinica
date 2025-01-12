import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/photo_service.dart';
import '../models/photo.dart';

class PhotoController with ChangeNotifier {
  final PhotoService _photoService = PhotoService();

  Future<void> createPhoto(String albumId, String name, String description, Uint8List file) async {
    String imageUrl = await _photoService.uploadImage(file, name);
    final photo = Photo(
      id: '',
      albumId: albumId,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
    await _photoService.createPhoto(photo);
  }

  Future<void> deletePhoto(String id) async {
    await _photoService.deletePhoto(id);
  }

  Stream<List<Photo>> getPhotos(String albumId) {
    return _photoService.getPhotos(albumId);
  }
}
