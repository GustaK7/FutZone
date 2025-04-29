import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

import 'sports_space_detail_page.dart';
import 'notifications_page.dart';

class SportsHomePage extends StatefulWidget {
  const SportsHomePage({super.key});

  @override
  State<SportsHomePage> createState() => _SportsHomePageState();
}

class _SportsHomePageState extends State<SportsHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Buscar espaços do backend ao iniciar
    Future.microtask(() => context.read<AppState>().fetchSpacesFromBackend());
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sports = ['Todos', 'Futebol', 'Beach Tennis', 'Vôlei', 'Vôlei na Areia', 'Futebol na Areia', 'Basquete', 'Futsal'];
    // Filtrar espaços com base no esporte selecionado usando switch case
    final filteredSpaces = appState.spaces.where((space) {
      switch (appState.selectedSport) {
        case 'Futebol':
          return space.sportType == 'Futebol';
        case 'Beach Tennis':
          return space.sportType == 'Beach Tennis';
        case 'Vôlei':
          return space.sportType == 'Vôlei';
        case 'Vôlei na Areia':
          return space.sportType == 'Vôlei na Areia';
        case 'Futebol na Areia':
          return space.sportType == 'Futebol na Areia';
        case 'Basquete':
          return space.sportType == 'Basquete';
        case 'Futsal':
          return space.sportType == 'Futsal';
        case 'Todos':
        default:
          return true; // Retorna todos os espaços
      }
    }).toList();

    if (appState.isLoadingSpaces) {
      return Center(child: CircularProgressIndicator());
    }
    if (appState.spacesError != null) {
      return Center(
          child: Text('Erro ao carregar espaços: \\${appState.spacesError}'));
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          //final isMobile = constraints.maxWidth < 600;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Inicie sua busca...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      tooltip: 'Notificações',
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const NotificationsPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: sports.map((sport) {
                        final isSelected = appState.selectedSport == sport;
                        IconData icon;
                        switch (sport) {
                          case 'Futebol':
                            icon = Icons.sports_soccer;
                            break;
                          case 'Beach Tennis':
                            icon = Icons.sports_tennis;
                            break;
                          case 'Vôlei':
                            icon = Icons.sports_volleyball;
                            break;
                          case 'Vôlei na Areia':
                            icon = Icons.beach_access;
                            break;
                          case 'Futebol na Areia':
                            icon = Icons.sports_soccer; // Corrigido para usar o prefixo correto 'Icons'
                            break;
                          case 'Basquete':
                            icon = Icons.sports_basketball;
                            break;
                          case 'Futsal':
                            icon = Icons.sports_soccer; // Ícone de futebol para Futsal
                            break;
                          default:
                            icon = Icons.sports;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Icon(icon, size: 20),
                                const SizedBox(width: 4),
                                Text(sport),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              appState.setSportFilter(sport);
                            },
                            selectedColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey.shade200,
                            labelStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredSpaces.isEmpty
                    ? const Center(child: Text('Nenhum espaço encontrado.'))
                    : ListView.builder(
                        itemCount: filteredSpaces.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final space = filteredSpaces[index];
                          final isFavorite =
                              appState.favoritesSpaces.contains(space);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      SportsSpaceDetailPage(space: space),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                        position: offsetAnimation,
                                        child: child);
                                  },
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      space.imageUrl,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                        child: Icon(Icons.error,
                                            size: 50, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                space.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                appState
                                                    .toggleFavoriteSpace(space);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(isFavorite
                                                          ? 'Removido dos favoritos!'
                                                          : 'Adicionado aos favoritos!')),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'R\$${space.pricePerHour.toStringAsFixed(2)} / hora',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber, size: 18),
                                            const SizedBox(width: 4),
                                            Text(
                                              space.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}