//import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/animation.dart';

//import '../config/app_config.dart';

//import '../models/sports_space.dart';
//import '../models/reserved_space.dart';
//import '../models/notification_item.dart';

import '../services/space_service.dart';
//import '../services/user_service.dart';

import '../state/app_state.dart';

class SpaceRegisterPage extends StatefulWidget {
  const SpaceRegisterPage({super.key});

  @override
  State<SpaceRegisterPage> createState() => _SpaceRegisterPageState();
}

class _SpaceRegisterPageState extends State<SpaceRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  final _hostController = TextEditingController();
  File? _pickedImage;
  String? _imageError;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _imageError = null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _descController.dispose();
    _hostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Espaço Esportivo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_pickedImage!,
                              width: 160, height: 120, fit: BoxFit.cover),
                        )
                      : Container(
                          width: 160,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey),
                        ),
                ),
              ),
              if (_imageError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_imageError!,
                      style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Nome do espaço', border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                    labelText: 'Tipo de esporte', border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o tipo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                    labelText: 'Valor por hora',
                    border: OutlineInputBorder(),
                    prefixText: 'R\$ '),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o valor';
                  final value = double.tryParse(v.replaceAll(',', '.'));
                  if (value == null || value <= 0)
                    return 'Informe um valor válido (> 0)';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                    labelText: 'Endereço', border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o endereço' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                    labelText: 'Descrição', border: OutlineInputBorder()),
                maxLines: 2,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                    labelText: 'Nome do anfitrião',
                    border: OutlineInputBorder()),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe o anfitrião'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    try {
                      await SpaceService.createSpace(
                        name: _nameController.text.trim(),
                        type: _typeController.text.trim(),
                        price: double.parse(_priceController.text.replaceAll(',', '.')),
                        address: _addressController.text.trim(),
                        description: _descController.text.trim(),
                        host: _hostController.text.trim(),
                        // Sempre envie uma URL de imagem válida para o backend
                        imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                      );
                      if (mounted) {
                        await context.read<AppState>().fetchSpacesFromBackend();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cadastro realizado!')),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}