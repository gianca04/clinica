import 'dart:io';
import 'package:clinica/views/admin_views/especialistas/form_especialistas.dart';
import 'package:flutter/material.dart';
import 'package:clinica/models/paquete_model.dart';
import 'package:clinica/services/package_service.dart';
import 'package:provider/provider.dart';
import 'package:clinica/models/app_color.dart';
import 'package:clinica/models/specialists_model.dart';
import '../views/admin_views/paquetes/form_paquetes.dart';

class PackageViewModel extends ChangeNotifier {

  final PackageService _packageService = PackageService();


  bool _isLoading = false;
  List<Package> _packages = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Package> get packages => _packages;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Método para agregar un nuevo paquete
  Future<void> addPackage(Package package) async {
    _setLoading(true);

    try {
      await _packageService.addPackage(package);
      _setError(null); // Limpiar error si se agrega con éxito
    } catch (e) {
      _setError('Error al agregar el paquete: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener los paquetes y notificarlos
  Future<void> fetchPackages() async {
    _setLoading(true);

    try {
      _packages = await _packageService.fetchPackages();
      _setError(null); // Limpiar error si se obtienen con éxito
    } catch (e) {
      _setError('Error al obtener los paquetes: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para eliminar un paquete
  Future<void> deletePackage(String packageId) async {
    _setLoading(true);

    try {
      await _packageService.deletePackage(packageId);
      _packages.removeWhere((package) => package.id == packageId);
      _setError(null); // Limpiar error si se elimina con éxito
    } catch (e) {
      _setError('Error al eliminar el paquete: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para actualizar un paquete
  Future<void> updatePackage(Package package) async {
    _setLoading(true);

    try {
      await _packageService.updatePackage(package);
      int index = _packages.indexWhere((p) => p.id == package.id);
      if (index != -1) {
        _packages[index] = package; // Actualiza el paquete en la lista
      }
      _setError(null); // Limpiar error si se actualiza con éxito
    } catch (e) {
      _setError('Error al actualizar el paquete: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Método para subir imagen
  Future<String> uploadImage(File imageFile) async {
    return await _packageService.uploadImage(imageFile);
  }
}

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPackages();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadPackages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PackageViewModel>(context, listen: false).fetchPackages();
    });
  }

  // Este método se llama cuando el texto de búsqueda cambia
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    // Aquí el método de búsqueda quedaría vacío
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchField(), // Barra de búsqueda debajo del appBar
          Expanded(child: _buildPackageList()), // Lista de paquetes
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Paquetes', style: TextStyle(color: AppColors.textPrimary)),
      backgroundColor: AppColors.primary,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: AppColors.textPrimary),
          onPressed: () {}, // Acción de configuración
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Buscar paquetes...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: AppColors.inputBackground,
        ),
      ),
    );
  }

  Widget _buildPackageList() {
    return Consumer<PackageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _buildLoadingIndicator();
        }
        if (viewModel.packages.isEmpty) {
          return _buildEmptyMessage();
        }
        return _buildPackageListView(viewModel);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Text('No hay paquetes disponibles',
          style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildPackageListView(PackageViewModel viewModel) {
    final filteredPackages = _searchQuery.isEmpty
        ? viewModel.packages
        : viewModel.packages
            .where((package) =>
                package.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        return _buildPackageCard(package);
      },
    );
  }

  Widget _buildPackageCard(package) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppColors.inputBackground,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPackageImage(package),
            SizedBox(width: 16),
            _buildPackageInfo(package),
            _buildActionButtons(package),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageImage(package) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: package.imagePath.isNotEmpty
          ? Image.network(
              package.imagePath,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported,
                    size: 40, color: AppColors.textSecondary);
              },
            )
          : Container(
              color: AppColors.inputBackground,
              width: 100,
              height: 100,
              child: Icon(Icons.image_not_supported,
                  size: 40, color: AppColors.textSecondary),
            ),
    );
  }

  Widget _buildPackageInfo(package) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            'Precio: \$${package.price.toStringAsFixed(2)}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Especialista: ${package.specialistName}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(package) {
    return Column(
      children: [
        _buildEditButton(package),
        _buildDeleteButton(package),
      ],
    );
  }

  Widget _buildDeleteButton(package) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () => _showDeleteConfirmationDialog(context, package),
    );
  }

  Widget _buildEditButton(package) {
    return IconButton(
      icon: Icon(Icons.edit, color: AppColors.primary),
      onPressed: () => _navigateToEditScreen(package),
    );
  }

  void _navigateToEditScreen(package) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PackageFormScreen(package: package)),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToCreateScreen,
      child: Icon(Icons.add),
      backgroundColor: AppColors.primary,
      tooltip: 'Registrar nuevo paquete',
    );
  }

  void _navigateToCreateScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PackageFormScreen()),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Paquete',
              style: TextStyle(color: AppColors.textPrimary)),
          content: Text('¿Estás seguro de que deseas eliminar este paquete?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            _buildCancelButton(),
            _buildDeleteButtonAction(package),
          ],
        );
      },
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      child: Text('Cancelar', style: TextStyle(color: AppColors.primary)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildDeleteButtonAction(package) {
    return TextButton(
      child: Text('Eliminar', style: TextStyle(color: Colors.red)),
      onPressed: () {
        _deletePackage(package);
        Navigator.of(context).pop();
      },
    );
  }

  void _deletePackage(package) {
    Provider.of<PackageViewModel>(context, listen: false)
        .deletePackage(package.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Paquete eliminado exitosamente',
              style: TextStyle(color: AppColors.textPrimary))),
    );
  }
}
