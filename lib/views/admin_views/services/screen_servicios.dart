import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinica/viewmodels/service_viewmodel.dart';
import 'package:clinica/views/admin_views/services/form_servicios.dart';
import 'package:clinica/models/app_color.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadServices();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadServices() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();
    });
  }

  // Este método se llama cuando el texto de búsqueda cambia
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    if (_searchQuery.isNotEmpty) {
      Provider.of<ServiceViewModel>(context, listen: false)
          .buscarServicio(_searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchField(), // Barra de búsqueda debajo del appBar
          Expanded(child: _buildServiceList()), // Lista de servicios
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Administrar Servicios', style: TextStyle(color: AppColors.textPrimary)),
      backgroundColor: AppColors.primary,
      elevation: 0,
      actions: [
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
          hintText: 'Buscar servicios...',
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

  Widget _buildServiceList() {
    return Consumer<ServiceViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _buildLoadingIndicator();
        }
        if (viewModel.services.isEmpty) {
          return _buildEmptyMessage();
        }
        return _buildServiceListView(viewModel);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Text('No hay servicios disponibles',
          style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildServiceListView(ServiceViewModel viewModel) {
    final filteredServices = _searchQuery.isEmpty
        ? viewModel.services
        : viewModel.services
        .where((service) =>
        service.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredServices.length,
      itemBuilder: (context, index) {
        final service = filteredServices[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(service) {
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
            _buildServiceImage(service),
            SizedBox(width: 16),
            _buildServiceInfo(service),
            _buildActionButtons(service),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage(service) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: service.imagePath.isNotEmpty
          ? Image.network(
        service.imagePath,
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

  Widget _buildServiceInfo(service) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            'Precio: \$${service.price.toStringAsFixed(2)}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Especialista: ${service.name}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(service) {
    return Column(
      children: [
        _buildEditButton(service),
        _buildDeleteButton(service),
      ],
    );
  }

  Widget _buildDeleteButton(service) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () => _showDeleteConfirmationDialog(context, service),
    );
  }

  Widget _buildEditButton(service) {
    return IconButton(
      icon: Icon(Icons.edit, color: AppColors.primary),
      onPressed: () => _navigateToEditScreen(service),
    );
  }

  void _navigateToEditScreen(service) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ServiceFormScreen(service: service)),
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
      MaterialPageRoute(builder: (context) => ServiceFormScreen()),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, service) {
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
            _buildDeleteButtonAction(service),
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

  Widget _buildDeleteButtonAction(service) {
    return TextButton(
      child: Text('Eliminar', style: TextStyle(color: Colors.red)),
      onPressed: () {
        _deletePackage(service);
        Navigator.of(context).pop();
      },
    );
  }

  void _deletePackage(service) {
    Provider.of<ServiceViewModel>(context, listen: false)
        .deletePackage(service.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Paquete eliminado exitosamente',
              style: TextStyle(color: AppColors.textPrimary))),
    );
  }
}
