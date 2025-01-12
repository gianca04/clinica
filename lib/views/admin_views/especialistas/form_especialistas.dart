import 'package:flutter/material.dart';
import 'package:clinica/models/specialists_model.dart';
import 'package:clinica/viewmodels/specialists_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clinica/models/app_color.dart';

class EspecialistFormScreen extends StatefulWidget {
  final Specialist? specialist;

  const EspecialistFormScreen({Key? key, this.specialist}) : super(key: key);

  @override
  _EspecialistFormScreenState createState() => _EspecialistFormScreenState();
}

class _EspecialistFormScreenState extends State<EspecialistFormScreen> {
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _especialistDniController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _infoController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _specialtyController;
  late final TextEditingController _scheduleController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.specialist?.firstName);
    _especialistDniController = TextEditingController(text: widget.specialist?.dni);
    _lastNameController = TextEditingController(text: widget.specialist?.lastName);
    _specialtyController = TextEditingController(text: widget.specialist?.specialty);
    _scheduleController = TextEditingController(text: widget.specialist?.schedule);
    _infoController = TextEditingController(text: widget.specialist?.info);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _especialistDniController.dispose();
    _lastNameController.dispose();
    _specialtyController.dispose();
    _scheduleController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  Future<void> _saveSpecialist() async {
    if (_formKey.currentState!.validate()) {
      String? imgUrl = widget.specialist?.urlFoto;

      if (_imageFile != null) {
        try {
          imgUrl = await Provider.of<SpecialistsViewModel>(context, listen: false).uploadImage(_imageFile!, _especialistDniController.text);
        } catch (e) {
          _showErrorDialog(e.toString());
          return;
        }
      }

      final specialist = Specialist(
          id: widget.specialist?.id,
        dni: _especialistDniController.text,
        firstName: _firstNameController.text,
        info: _infoController.text,
        lastName: _lastNameController.text,
        schedule: _scheduleController.text,
        specialty: _specialtyController.text,
        urlFoto: imgUrl ?? ''
      );

      final viewModel = Provider.of<SpecialistsViewModel>(context, listen: false);

      if (widget.specialist == null) {
        await viewModel.addSpecialist(specialist);
      } else {
        await viewModel.updateSpecialist(specialist);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.specialist == null ? 'Paquete agregado con éxito' : 'Paquete actualizado con éxito')),
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
          widget.specialist == null ? 'Agregar Especialista' : 'Editar Especialista',
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
              _buildTextField('DNI del Especialista', _especialistDniController, 'Por favor ingresa el DNI del especialista'),
              SizedBox(height: 16),
              _buildTextField('Nombre', _firstNameController, 'Por favor ingresa un nombre'),
              SizedBox(height: 16),
              _buildTextField('Apellido', _lastNameController, 'Por favor ingresa los apellidos'),
              SizedBox(height: 16),
              _buildTextField('Información', _infoController, 'Por favor ingresa una descripción'),
              SizedBox(height: 16),
              _buildTextField('Horario', _scheduleController, 'Por favor ingresa un horario'),
              SizedBox(height: 24),
              _buildTextField('Especialidad', _specialtyController, 'Por favor ingresa la especialidad'),
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
                    : widget.specialist?.urlFoto != null && widget.specialist!.urlFoto.isNotEmpty
                    ? Image.network(widget.specialist!.urlFoto, height: 100, width: 100, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 100, color: AppColors.primary),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSpecialist,
                  child: Text(
                    widget.specialist == null ? 'Agregar Paquete' : 'Actualizar Paquete',
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
