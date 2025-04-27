//import 'dart:convert';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/animation.dart';

//import '../config/app_config.dart';

import '../models/sports_space.dart';
//import '../models/reserved_space.dart';
//import '../models/notification_item.dart';

//import '../services/space_service.dart';
//import '../services/user_service.dart';

import '../state/app_state.dart';

class SportsSpaceDetailPage extends StatefulWidget {
  final SportsSpace space;
  const SportsSpaceDetailPage({super.key, required this.space});

  @override
  State<SportsSpaceDetailPage> createState() => _SportsSpaceDetailPageState();
}

class _SportsSpaceDetailPageState extends State<SportsSpaceDetailPage> {
  int _hours = 1;

  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );
    if (pickedDate != null) {
      int? selectedHour;
      await showDialog(
        context: context,
        builder: (context) {
          int? tempHour = selectedHour;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Selecione o horário'),
                content: DropdownButton<int>(
                  isExpanded: true,
                  value: tempHour,
                  hint: const Text('Escolha o horário'),
                  items: List.generate(17, (i) => 7 + i).map((hour) {
                    return DropdownMenuItem(
                      value: hour,
                      child: Text('${hour.toString().padLeft(2, '0')}:00'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tempHour = value;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: tempHour != null
                        ? () {
                            selectedHour = tempHour;
                            final startDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              selectedHour!,
                              0,
                            );
                            final appState = context.read<AppState>();
                            appState.reserveSpace(
                                widget.space, startDateTime, _hours);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Reserva de $_hours hora(s) para ${_formatDateTime(startDateTime, _hours)} realizada!'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Confirmar'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  String _formatDateTime(DateTime dateTime, int hours) {
    final end = dateTime.add(Duration(hours: hours));
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildComment(String user, int stars, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Text(user[0])),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(
                          stars,
                          (i) => const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isFavorite = appState.favoritesSpaces.contains(widget.space);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32)),
                        child: Image.network(
                          widget.space.imageUrl,
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child:
                                Icon(Icons.error, size: 50, color: Colors.red),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 24,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              appState.toggleFavoriteSpace(widget.space);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(isFavorite
                                        ? 'Removido dos favoritos!'
                                        : 'Adicionado aos favoritos!')),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      widget.space.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.space.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.85),
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 22),
                        const SizedBox(width: 4),
                        Text(
                          widget.space.rating.toStringAsFixed(2),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        Icon(Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Anfitrião: ${widget.space.hostName}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.85),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.red, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.space.address,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.85),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.map,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            // Futuramente abrirá o mapa
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avalie este espaço',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                              5,
                              (index) => const Icon(Icons.star_border,
                                  color: Colors.amber)),
                        ),
                        const SizedBox(height: 8),
                        const TextField(
                          enabled: false, // Futuramente será habilitado
                          decoration: InputDecoration(
                            hintText: 'Deixe um comentário... (em breve)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comentários',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        _buildComment(
                            'João', 5, 'Ótima quadra, muito bem cuidada!'),
                        _buildComment('Maria', 4,
                            'Espaço bom, mas o estacionamento é pequeno.'),
                        _buildComment(
                            'Lucas', 5, 'Voltarei mais vezes! Recomendo.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'R\$${widget.space.pricePerHour.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        'por hora',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed:
                            _hours > 1 ? () => setState(() => _hours--) : null,
                      ),
                      Text('$_hours h', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _hours++),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => _pickDateTime(context),
                        child: const Text('Reservar',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}