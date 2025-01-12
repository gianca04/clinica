import 'package:flutter/material.dart';
import 'package:clinica/models/paquete_model.dart';
import 'package:clinica/viewmodels/paquete_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clinica/models/app_color.dart';

class PackageFormScreen extends StatefulWidget {
  final Package? package;

  const PackageFormScreen({Key? key, this.package}) : super(key: key);

  @override
  _PackageFormScreenState createState() => _PackageFormScreenState();
}

class _PackageFormScreenState extends State<PackageFormScreen> {
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _especialistaDniController;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.package?.description);
    _especialistaDniController = TextEditingController(text: widget.package?.especialistadni);
    _nameController = TextEditingController(text: widget.package?.name);
    _priceController = TextEditingController(text: widget.package?.price.toString());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _especialistaDniController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _savePackage() async {
    if (_formKey.currentState!.validate()) {
      String? imgUrl = widget.package?.imglink;

      if (_imageFile != null) {
        try {
          imgUrl = await Provider.of<PackageViewModel>(context, listen: false).uploadImage(_imageFile!);
        } catch (e) {
          _showErrorDialog(e.toString());
          return;
        }
      }

      final package = Package(
        id: widget.package?.id,
        description: _descriptionController.text,
        especialistadni: _especialistaDniController.text,
        imglink: imgUrl ?? '',
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
      );

      final viewModel = Provider.of<PackageViewModel>(context, listen: false);

      if (widget.package == null) {
        await viewModel.addPackage(package);
      } else {
        await viewModel.updatePackage(package);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.package == null ? 'Paquete agregado con éxito' : 'Paquete actualizado con éxito')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.package == null ? 'Agregar Paquete' : 'Editar Paquete',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Descripción', _descriptionController, 'Por favor ingresa una descripción'),
              SizedBox(height: 16),
              _buildTextField('DNI del Especialista', _especialistaDniController, 'Por favor ingresa el DNI del especialista'),
              SizedBox(height: 16),
              _buildTextField('Nombre', _nameController, 'Por favor ingresa un nombre'),
              SizedBox(height: 16),
              _buildTextField('Precio', _priceController, 'Por favor ingresa un precio', isNumber: true),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image, color: Colors.white),
                  label: Text('Seleccionar Imagen', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: _imageFile != null
                    ? Image.file(_imageFile!, height: 100, width: 100, fit: BoxFit.cover)
                    : widget.package?.imglink != null && widget.package!.imglink.isNotEmpty
                    ? Image.network(widget.package!.imglink, height: 100, width: 100, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 100, color: AppColors.primary),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _savePackage,
                  child: Text(
                    widget.package == null ? 'Agregar Paquete' : 'Actualizar Paquete',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? errorMessage, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: AppColors.textPrimary),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        if (isNumber) {
          final parsedValue = double.tryParse(value);
          if (parsedValue == null || parsedValue <= 0) {
            return 'Por favor ingresa un valor válido';
          }
        }
        return null;
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(message, style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
