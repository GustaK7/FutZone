import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

void main() {
  runApp(MyApp());
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
  ReservedSpace({required this.space, required this.dateTime, required this.hours});
}

class NotificationItem {
  final String message;
  final DateTime dateTime;
  NotificationItem({required this.message, required this.dateTime});
}

class AppState extends ChangeNotifier {
  final List<SportsSpace> _spaces = [
    // Futebol
    SportsSpace(
      id: '1',
      name: 'Quadra Society Central',
      pricePerHour: 120.0,
      imageUrl: 'https://media.istockphoto.com/id/1036082216/pt/foto/marking-the-angle-of-the-football-field-with-artificial-surface.jpg?s=1024x1024&w=is&k=20&c=ef4MqwpETI0wnGTJEWB7_n4FNwXZY06YoFHpauZwH2Q=',
      rating: 4.8,
      sportType: 'Futebol',
      description: 'Quadra de futebol society com grama sintética, iluminação e vestiário.',
      hostName: 'Carlos',
      address: 'Rua das Palmeiras, 123, Centro',
    ),
    SportsSpace(
      id: '2',
      name: 'Campo Society Zona Sul',
      pricePerHour: 150.0,
      imageUrl: 'https://media.istockphoto.com/id/1139701786/pt/foto/mini-football-field.jpg?s=1024x1024&w=is&k=20&c=1uJImYvRxQnNcTZMkaOuxM7rm46pnRlmAAgEFiJvVTI=',
      rating: 4.9,
      sportType: 'Futebol',
      description: 'Campo society amplo, com estacionamento e lanchonete.',
      hostName: 'Roberto',
      address: 'Av. Sul, 321, Zona Sul',
    ),
    SportsSpace(
      id: '3',
      name: 'Estádio Arena Fut',
      pricePerHour: 200.0,
      imageUrl: 'https://media.istockphoto.com/id/1468843814/pt/foto/all-weather-artificial-grass-pitch.jpg?s=1024x1024&w=is&k=20&c=jg9K9KiWss723q2YHddMNWnhtLUAjP6VLBRAQW38_xg=',
      rating: 4.7,
      sportType: 'Futebol',
      description: 'Estádio para jogos e eventos, com arquibancada e iluminação profissional.',
      hostName: 'Marcos',
      address: 'Av. das Nações, 1000, Centro',
    ),
    // Beach Tennis
    SportsSpace(
      id: '4',
      name: 'Arena Beach Tennis',
      pricePerHour: 90.0,
      imageUrl: 'https://media.istockphoto.com/id/1289164936/pt/foto/beach-tennis.jpg?s=1024x1024&w=is&k=20&c=MCHqcx-5VlUjsSUNL1YMHuEwgEEt9kR7wR05XNYal9A=',
      rating: 4.6,
      sportType: 'Beach Tennis',
      description: 'Quadra de areia para beach tennis, com estrutura coberta e bar.',
      hostName: 'Fernanda',
      address: 'Av. Atlântica, 456, Praia',
    ),
    SportsSpace(
      id: '5',
      name: 'Beach Tennis Club',
      pricePerHour: 110.0,
      imageUrl: 'https://media.istockphoto.com/id/2173311264/pt/foto/beach-tennis-match.jpg?s=1024x1024&w=is&k=20&c=kQDjf0Jz4uQGxUwJ83Xtc2cXoXlEpM-be8pEMXo4lEM=',
      rating: 4.5,
      sportType: 'Beach Tennis',
      description: 'Clube com várias quadras de beach tennis e área de convivência.',
      hostName: 'Paula',
      address: 'Rua do Sol, 222, Litoral',
    ),
    SportsSpace(
      id: '6',
      name: 'Espaço Beach Pro',
      pricePerHour: 100.0,
      imageUrl: 'https://media.istockphoto.com/id/1351835469/pt/foto/beach-volleyball-court-established-in-the-city.jpg?s=1024x1024&w=is&k=20&c=9nIkVlFOccCmwhEhMZUI3ACMDqiDgVElG7KKVqylyj4=',
      rating: 4.4,
      sportType: 'Beach Tennis',
      description: 'Espaço profissional para beach tennis, com vestiários e estacionamento.',
      hostName: 'Lucas',
      address: 'Av. Praia Grande, 789, Beira Mar',
    ),
    // Vôlei
    SportsSpace(
      id: '7',
      name: 'Quadra de Vôlei Pro',
      pricePerHour: 80.0,
      imageUrl: 'https://plus.unsplash.com/premium_photo-1708696216310-5abfafa9aec9?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      rating: 4.7,
      sportType: 'Vôlei',
      description: 'Quadra de vôlei profissional, piso emborrachado e arquibancada.',
      hostName: 'Juliana',
      address: 'Rua do Esporte, 789, Bairro Novo',
    ),
    SportsSpace(
      id: '8',
      name: 'Vôlei Clube Master',
      pricePerHour: 95.0,
      imageUrl: 'https://plus.unsplash.com/premium_photo-1709303662628-c6460ac28bd5?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      rating: 4.8,
      sportType: 'Vôlei',
      description: 'Clube com quadras de vôlei indoor e outdoor.',
      hostName: 'Ana',
      address: 'Rua das Flores, 333, Centro',
    ),
    SportsSpace(
      id: '9',
      name: 'Arena Vôlei Beach',
      pricePerHour: 85.0,
      imageUrl: 'https://images.unsplash.com/photo-1567880325673-ccc01edca61c?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      rating: 4.6,
      sportType: 'Vôlei',
      description: 'Quadra de vôlei de praia, areia fina e iluminação noturna.',
      hostName: 'Bruno',
      address: 'Av. Beira Rio, 555, Praia',
    ),
  ];
  final List<SportsSpace> _favoritesSpaces = [];
  final List<ReservedSpace> _reservedSpaces = [];
  final List<NotificationItem> _notifications = [];
  String _selectedSport = 'Todos';
  final String _userName = 'Nicollas';
  final String _userEmail = 'nicollas@email.com';
  bool _darkMode = false;
  bool _notificationsEnabled = true;

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
    if (!_reservedSpaces.any((r) => r.space == space && r.dateTime == dateTime)) {
      _reservedSpaces.add(ReservedSpace(space: space, dateTime: dateTime, hours: hours));
      addNotification('Reserva para ${space.name} realizada com sucesso em '
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} às '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}');
      notifyListeners();
    }
  }

  void addNotification(String message) {
    _notifications.insert(0, NotificationItem(message: message, dateTime: DateTime.now()));
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
                brightness: appState.darkMode ? Brightness.dark : Brightness.light,
              ),
            ),
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en', ''),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: MainNavigation(),
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
        page = SportsHomePage();
        break;
      case 1:
        page = FavoritesSpacesPage();
        break;
      case 2:
        page = ProfilePage(); 
        break;
      default:
        page = SportsHomePage();
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
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sports = ['Todos', 'Futebol', 'Beach Tennis', 'Vôlei'];
    final filteredSpaces = appState.spaces.where((space) {
      final query = _searchController.text.toLowerCase();
      return space.name.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Inicie sua busca...',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.notifications),
                      tooltip: 'Notificações',
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => NotificationsPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(position: offsetAnimation, child: child);
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sports.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
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
                          SizedBox(width: 4),
                          Text(sport),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        appState.setSportFilter(sport);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
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
                    ? Center(child: Text('Nenhum espaço encontrado.'))
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredSpaces.length,
                        itemBuilder: (context, index) {
                          final space = filteredSpaces[index];
                          final isFavorite = appState.favoritesSpaces.contains(space);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => SportsSpaceDetailPage(space: space),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(tween);

                                    return SlideTransition(position: offsetAnimation, child: child);
                                  },
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.network(
                                      space.imageUrl,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Center(
                                        child: Icon(Icons.error, size: 50, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                space.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorite ? Colors.red : Colors.grey,
                                              ),
                                              onPressed: () {
                                                appState.toggleFavoriteSpace(space);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(isFavorite ? 'Removido dos favoritos!' : 'Adicionado aos favoritos!')),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'R\$${space.pricePerHour.toStringAsFixed(2)} / hora',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 18),
                                            SizedBox(width: 4),
                                            Text(
                                              space.rating.toStringAsFixed(1),
                                              style: TextStyle(fontWeight: FontWeight.bold),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
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
                ? Center(child: Text('Nenhum espaço favorito ainda.'))
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              builder: (_) => SportsSpaceDetailPage(space: space),
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
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  space.imageUrl,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Center(
                                    child: Icon(Icons.error, size: 50, color: Colors.red),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                child: Text(
                                  space.name,
                                  style: TextStyle(
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
      lastDate: DateTime.now().add(Duration(days: 365)),
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
                title: Text('Selecione o horário'),
                content: DropdownButton<int>(
                  isExpanded: true,
                  value: tempHour,
                  hint: Text('Escolha o horário'),
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
                    child: Text('Cancelar'),
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
                            appState.reserveSpace(widget.space, startDateTime, _hours);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Reserva de $_hours hora(s) para ${_formatDateTime(startDateTime, _hours)} realizada!'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text('Confirmar'),
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
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Text(user[0])),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Row(
                        children: List.generate(
                          stars,
                          (i) => Icon(Icons.star, color: Colors.amber, size: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
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
              padding: EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                        child: Image.network(
                          widget.space.imageUrl,
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.error, size: 50, color: Colors.red),
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
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              appState.toggleFavoriteSpace(widget.space);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(isFavorite ? 'Removido dos favoritos!' : 'Adicionado aos favoritos!')),
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
                            icon: Icon(Icons.arrow_back, color: Colors.black),
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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 22),
                        SizedBox(width: 4),
                        Text(
                          widget.space.rating.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Anfitrião: ${widget.space.hostName}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.space.address,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.map, color: Theme.of(context).colorScheme.primary),
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
                        Text('Avalie este espaço', style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (index) => Icon(Icons.star_border, color: Colors.amber)),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          enabled: false, // Futuramente será habilitado
                          decoration: InputDecoration(
                            hintText: 'Deixe um comentário... (em breve)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comentários', style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 8),
                        _buildComment('João', 5, 'Ótima quadra, muito bem cuidada!'),
                        _buildComment('Maria', 4, 'Espaço bom, mas o estacionamento é pequeno.'),
                        _buildComment('Lucas', 5, 'Voltarei mais vezes! Recomendo.'),
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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
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
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: _hours > 1 ? () => setState(() => _hours--) : null,
                      ),
                      Text('$_hours h', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _hours++),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => _pickDateTime(context),
                        child: Text('Reservar', style: TextStyle(fontSize: 18, color: Colors.white)),
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
      appBar: AppBar(title: Text('Minhas Reservas')),
      body: reserved.isEmpty
          ? Center(child: Text('Nenhuma reserva realizada.'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: reserved.length,
              itemBuilder: (context, index) {
                final reservedSpace = reserved[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        reservedSpace.space.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
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
      appBar: AppBar(title: Text('Central de Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá $userName, como podemos te ajudar?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Digite sua dúvida ou comentário...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _submittedMessage = _controller.text;
                  _controller.clear();
                });
              },
              child: Text('Enviar'),
            ),
            if (_submittedMessage != null && _submittedMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Mensagem enviada: $_submittedMessage', style: TextStyle(color: Colors.green)),
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
      appBar: AppBar(title: Text('Perfil do Usuário')),
      body: Column(
        children: [
          SizedBox(height: 32),
          Center(
            child: CircleAvatar(
              radius: 56,
              child: Icon(Icons.person, size: 64),
            ),
          ),
          SizedBox(height: 16),
          Text(appState.userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(appState.userEmail, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Futuramente: editar perfil
            },
            icon: Icon(Icons.edit),
            label: Text('Editar perfil'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
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
                  MaterialPageRoute(builder: (_) => UserProfilePage()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    child: Text('N', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nicollas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Mostrar perfil', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: ListTile(
                leading: Icon(Icons.home_work_outlined, size: 36, color: Colors.black87),
                title: Text('Anuncie seu espaço'),
                subtitle: Text('É fácil começar a receber reservas e ganhar uma renda extra.'),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SpaceRegisterPage()),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text('Configurações', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Informações pessoais'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UserProfilePage()),
                    );
                  },
                ),
                Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.calendar_month_outlined),
                  title: Text('Minhas reservas'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyReservationsPage()),
                    );
                  },
                ),
                Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Central de ajuda'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HelpCenterPage()),
                    );
                  },
                ),
                Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações do app'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsPage()),
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
      appBar: AppBar(title: Text('Configurações do app')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Modo escuro'),
            value: appState.darkMode,
            onChanged: (value) => appState.toggleDarkMode(value),
            secondary: Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: Text('Notificações'),
            value: appState.notificationsEnabled,
            onChanged: (value) => appState.toggleNotifications(value),
            secondary: Icon(Icons.notifications_active),
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
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _descController.dispose();
    _hostController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Espaço Esportivo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do espaço'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Tipo de esporte'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o tipo' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Valor por hora'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Informe o valor' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o endereço' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
                validator: (v) => v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _hostController,
                decoration: InputDecoration(labelText: 'Nome do anfitrião'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o anfitrião' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'URL da imagem'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a imagem' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final appState = context.read<AppState>();
                    appState.addSpace(SportsSpace(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      pricePerHour: double.tryParse(_priceController.text) ?? 0,
                      imageUrl: _imageController.text,
                      rating: 0,
                      sportType: _typeController.text,
                      description: _descController.text,
                      hostName: _hostController.text,
                      address: _addressController.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: Text('Cadastrar'),
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
      appBar: AppBar(title: Text('Notificações')),
      body: notifications.isEmpty
          ? Center(child: Text('Nenhuma notificação disponível.'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
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