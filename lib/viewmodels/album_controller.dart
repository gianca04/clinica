import 'package:flutter/material.dart';
import '../services/album_service.dart';
import '../models/album.dart';

class AlbumController with ChangeNotifier {
  final AlbumService _albumService = AlbumService();

  Future<void> createAlbum(String name, String description) async {
    final album = Album(id: '', name: name, description: description);
    await _albumService.createAlbum(album);
  }

  Future<void> updateAlbum(String id, String name, String description) async {
    final album = Album(id: id, name: name, description: description);
    await _albumService.updateAlbum(id, album);
  }

  Future<void> deleteAlbum(String id) async {
    await _albumService.deleteAlbum(id);
  }

  Stream<List<Album>> getAlbums() {
    return _albumService.getAlbums();
  }

  Future<Album?> getAlbum(String id) {
    return _albumService.getAlbumById(id);
  }
}
