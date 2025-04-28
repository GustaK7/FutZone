import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../services/user_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      const userId = '680fcf4be19dd9e7192eef7b'; // ID do usuário no banco de dados
      final userData = await UserService.fetchUserById(userId);
      setState(() {
        _nameController.text = userData['name'] ?? '';
        _phoneController.text = userData['phone']?.toString() ?? '';
        _emailController.text = userData['email'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar informações do usuário: $e')),
      );
    }
  }

  void _updateProfile() async {
    try {
      const userId = '680fcf4be19dd9e7192eef7b';
      await UserService.updateUser(userId, {
        'name': _nameController.text,
        'phone': int.tryParse(_phoneController.text) ?? 0, // Converte para número
        'email': _emailController.text,
      });
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $e')),
      );
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(labelText: 'Senha Atual'),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  const userId = '680fcf4be19dd9e7192eef7b'; // Atualizado com o ID correto
                  await UserService.changePassword(
                    userId,
                    _currentPasswordController.text,
                    _newPasswordController.text,
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Senha alterada com sucesso!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao alterar senha: $e')),
                  );
                }
              },
              child: const Text('Alterar'),
            ),
          ],
        );
      },
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome';
    }
    if (value.length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o telefone';
    }
    if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
      return 'O telefone deve conter entre 8 e 15 dígitos';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o e-mail';
    }
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 56,
                  child: Icon(Icons.person, size: 64),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isEditing) ...[
                Text('Nome: ${_nameController.text}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Telefone: ${_phoneController.text}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('E-mail: ${_emailController.text}',
                    style: const TextStyle(fontSize: 18)),
              ] else ...[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: _validateName,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: _validateEmail,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                      if (!_isEditing) {
                        _updateProfile();
                      }
                    },
                    child: Text(_isEditing ? 'Salvar' : 'Editar Informações'),
                  ),
                  ElevatedButton(
                    onPressed: _showChangePasswordDialog,
                    child: const Text('Alterar Senha'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}