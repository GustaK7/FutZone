import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

void main() {
  runApp(const MyApp());
}

class AppConfig {
  static const String backendUrl =
      'http://localhost:3000'; // Corrigido: adicionado os dois pontos
}

class SportsSpace {
  final String id;
  final String name;
  final double pricePerHour;
  final String imageUrl;
  final double rating;
  final String sportType;
  final String description;
  final String hostName;
  final String address;

  SportsSpace({
    required this.id,
    required this.name,
    required this.pricePerHour,
    required this.imageUrl,
    required this.rating,
    required this.sportType,
    required this.description,
    required this.hostName,
    required this.address,
  });
}

class ReservedSpace {
  final SportsSpace space;
  final DateTime dateTime;
  final int hours;
  ReservedSpace(
      {required this.space, required this.dateTime, required this.hours});
}

class NotificationItem {
  final String message;
  final DateTime dateTime;
  NotificationItem({required this.message, required this.dateTime});
}

class SpaceService {
  static Future<List<SportsSpace>> fetchSpaces() async {
    final response =
        await http.get(Uri.parse('${AppConfig.backendUrl}/spaces'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => SportsSpace(
                id: json['_id'] ?? '',
                name: json['name'] ?? '',
                pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
                imageUrl: json['imageUrl'] ?? '',
                rating: (json['rating'] ?? 0).toDouble(),
                sportType: json['sportType'] ?? '',
                description: json['description'] ?? '',
                hostName: json['hostName'] ?? '',
                address: json['address'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Erro ao buscar espaços');
    }
  }

  static Future<void> createSpace({
    required String name,
    required String type,
    required double price,
    required String address,
    required String description,
    required String host,
    required String imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.backendUrl}/spaces'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'sportType': type,
        'pricePerHour': price,
        'address': address,
        'description': description,
        'hostName': host,
        'imageUrl': imageUrl,
        'rating': 0,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar espaço');
    }
  }
}

class UserService {
  static Future<Map<String, dynamic>> fetchUser(String email) async {
    final response =
        await http.get(Uri.parse('${AppConfig.backendUrl}/users?email=$email'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) return data.first;
      throw Exception('Usuário não encontrado');
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }

  static Future<void> updateUser(String id, Map<String, dynamic> update) async {
    final response = await http.put(
      Uri.parse('${AppConfig.backendUrl}/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(update),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }
}

class AppState extends ChangeNotifier {
  List<SportsSpace> _spaces = [];
  final List<SportsSpace> _favoritesSpaces = [];
  final List<ReservedSpace> _reservedSpaces = [];
  final List<NotificationItem> _notifications = [];
  String _selectedSport = 'Todos';
  final String _userName = 'Nicollas';
  final String _userEmail = 'nicollas@email.com';
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _isLoadingSpaces = false;
  String? _spacesError;

  List<SportsSpace> get spaces => _selectedSport == 'Todos'
      ? _spaces
      : _spaces.where((s) => s.sportType == _selectedSport).toList();
  List<SportsSpace> get favoritesSpaces => _favoritesSpaces;
  List<ReservedSpace> get reservedSpaces => _reservedSpaces;
  List<NotificationItem> get notifications => _notifications;
  String get selectedSport => _selectedSport;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoadingSpaces => _isLoadingSpaces;
  String? get spacesError => _spacesError;

  void toggleFavoriteSpace(SportsSpace space) {
    if (_favoritesSpaces.contains(space)) {
      _favoritesSpaces.remove(space);
    } else {
      _favoritesSpaces.add(space);
    }
    notifyListeners();
  }

  void setSportFilter(String sport) {
    _selectedSport = sport;
    notifyListeners();
  }

  void reserveSpace(SportsSpace space, DateTime dateTime, int hours) {
    if (!_reservedSpaces
        .any((r) => r.space == space && r.dateTime == dateTime)) {
      _reservedSpaces
          .add(ReservedSpace(space: space, dateTime: dateTime, hours: hours));
      addNotification('Reserva para ${space.name} realizada com sucesso em '
          '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.year} às '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}');
      notifyListeners();
    }
  }

  void addNotification(String message) {
    _notifications.insert(
        0, NotificationItem(message: message, dateTime: DateTime.now()));
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> fetchSpacesFromBackend() async {
    _isLoadingSpaces = true;
    _spacesError = null;
    notifyListeners();
    try {
      _spaces = await SpaceService.fetchSpaces();
    } catch (e) {
      _spacesError = e.toString();
    }
    _isLoadingSpaces = false;
    notifyListeners();
  }

  void addSpace(SportsSpace space) {
    _spaces.add(space);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Reserva Esportiva',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness:
                    appState.darkMode ? Brightness.dark : Brightness.light,
              ),
            ),
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const SportsHomePage();
        break;
      case 1:
        page = const FavoritesSpacesPage();
        break;
      case 2:
        page = const ProfilePage();
        break;
      default:
        page = const SportsHomePage();
    }
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class SportsHomePage extends StatefulWidget {
  const SportsHomePage({super.key});

  @override
  State<SportsHomePage> createState() => _SportsHomePageState();
}

class _SportsHomePageState extends State<SportsHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
    final sports = ['Todos', 'Futebol', 'Beach Tennis', 'Vôlei'];
    final filteredSpaces = appState.spaces.where((space) {
      final query = _searchController.text.toLowerCase();
      return space.name.toLowerCase().contains(query);
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
          final isMobile = constraints.maxWidth < 600;
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sports.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final sport = sports[index];
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
                      default:
                        icon = Icons.sports;
                    }
                    return ChoiceChip(
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
                    );
                  },
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

// As demais classes permanecem inalteradas
class FavoritesSpacesPage extends StatelessWidget {
  const FavoritesSpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favorites = appState.favoritesSpaces;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Favoritos',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: favorites.isEmpty
                ? const Center(child: Text('Nenhum espaço favorito ainda.'))
                : GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final space = favorites[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SportsSpaceDetailPage(space: space),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  space.imageUrl,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(Icons.error,
                                        size: 50, color: Colors.red),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 6.0),
                                child: Text(
                                  space.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
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
      ),
    );
  }
}

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

// As demais classes permanecem inalteradas
class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  String _formatDateTime(DateTime dateTime, int hours) {
    final end = dateTime.add(Duration(hours: hours));
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - '
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final reserved = context.watch<AppState>().reservedSpaces;
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Reservas')),
      body: reserved.isEmpty
          ? const Center(child: Text('Nenhuma reserva realizada.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reserved.length,
              itemBuilder: (context, index) {
                final reservedSpace = reserved[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        reservedSpace.space.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.error, size: 50, color: Colors.red),
                        ),
                      ),
                    ),
                    title: Text(reservedSpace.space.name),
                    subtitle: Text(
                      'R\$${reservedSpace.space.pricePerHour.toStringAsFixed(2)} / hora\n'
                      'Data: ${_formatDateTime(reservedSpace.dateTime, reservedSpace.hours)}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _controller = TextEditingController();
  String? _submittedMessage;

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AppState>().userName;
    return Scaffold(
      appBar: AppBar(title: const Text('Central de Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá $userName, como podemos te ajudar?',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Digite sua dúvida ou comentário...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _submittedMessage = _controller.text;
                  _controller.clear();
                });
              },
              child: const Text('Enviar'),
            ),
            if (_submittedMessage != null && _submittedMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Mensagem enviada: $_submittedMessage',
                    style: const TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Center(
            child: CircleAvatar(
              radius: 56,
              child: Icon(Icons.person, size: 64),
            ),
          ),
          const SizedBox(height: 16),
          Text(appState.userName,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(appState.userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Futuramente: editar perfil
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar perfil'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Perfil',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications_none, size: 28),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfilePage()),
                );
              },
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    child: Text('N',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nicollas',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Mostrar perfil',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.home_work_outlined,
                    size: 36, color: Colors.black87),
                title: const Text('Anuncie seu espaço'),
                subtitle: const Text(
                    'É fácil começar a receber reservas e ganhar uma renda extra.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SpaceRegisterPage()),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text('Configurações',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Informações pessoais'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const UserProfilePage()),
                    );
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text('Minhas reservas'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MyReservationsPage()),
                    );
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Central de ajuda'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpCenterPage()),
                    );
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configurações do app'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações do app')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo escuro'),
            value: appState.darkMode,
            onChanged: (value) => appState.toggleDarkMode(value),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Notificações'),
            value: appState.notificationsEnabled,
            onChanged: (value) => appState.toggleNotifications(value),
            secondary: const Icon(Icons.notifications_active),
          ),
        ],
      ),
    );
  }
}

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

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<AppState>().notifications;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: notifications.isEmpty
          ? const Center(child: Text('Nenhuma notificação disponível.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(notification.message),
                    subtitle: Text(
                      '${notification.dateTime.day.toString().padLeft(2, '0')}/'
                      '${notification.dateTime.month.toString().padLeft(2, '0')}/'
                      '${notification.dateTime.year} às '
                      '${notification.dateTime.hour.toString().padLeft(2, '0')}:${notification.dateTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
