import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinica/viewmodels/photo_controller.dart';
import 'package:clinica/models/photo.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/album.dart';
import '../../../services/album_service.dart';

class PhotoListScreen extends StatefulWidget {
  final String albumId;

  PhotoListScreen({required this.albumId});

  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  Album? album;

  @override
  void initState() {
    super.initState();
    _loadAlbum();
  }

  Future<void> _loadAlbum() async {
    final fetchedAlbum = await AlbumService().getAlbumById(widget.albumId);
    setState(() {
      album = fetchedAlbum;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: album == null
              ? CircularProgressIndicator() // Mostrar indicador de carga
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                album!.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                album!.description,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PhotoController>(
          builder: (context, photoController, child) {
            return StreamBuilder<List<Photo>>(
              stream: photoController.getPhotos(widget.albumId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay fotos en este álbum.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final photos = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return GestureDetector(
                      onTap: () => _showPhotoDetails(context, photo),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                photo.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    photo.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    photo.description,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadPhotoDialog(context),
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _showPhotoDetails(BuildContext context, Photo photo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(photo.imageUrl),
              SizedBox(height: 8),
              Text(
                photo.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(photo.description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<PhotoController>(context, listen: false)
                    .deletePhoto(photo.id);
                Navigator.pop(context);
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUploadPhotoDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Subir Nueva Foto'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre de la Foto'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  _selectedImage =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: Text('Seleccionar Foto'),
              ),
              if (_selectedImage != null)
                Text('Foto seleccionada: ${_selectedImage!.name}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final description = descriptionController.text;
                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    _selectedImage != null) {
                  final fileBytes = await _selectedImage!.readAsBytes();
                  await context.read<PhotoController>().createPhoto(
                        widget.albumId,
                        name,
                        description,
                        fileBytes,
                      );
                  Navigator.pop(context);
                }
              },
              child: Text('Subir'),
            ),
          ],
        );
      },
    );
  }
}
