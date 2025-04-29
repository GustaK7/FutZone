import 'package:flutter/material.dart';

import 'package:futzone/models/notification_item.dart';
import 'package:futzone/models/reserved_space.dart';
import 'package:futzone/models/sports_space.dart';

import 'package:futzone/services/space_service.dart';
import 'package:futzone/services/user_service.dart';

class AppState extends ChangeNotifier {
  List<SportsSpace> _spaces = [];
  final List<SportsSpace> _favoritesSpaces = [];
  final List<ReservedSpace> _reservedSpaces = [];
  final List<NotificationItem> _notifications = [];
  String _selectedSport = 'Todos';
  String? _userName; // Nome do usuário logado
  String? _userEmail; // E-mail do usuário logado
  String? _userId; // ID do usuário logado
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _isLoadingSpaces = false;
  String? _spacesError;

  // Getters
  List<SportsSpace> get spaces => _selectedSport == 'Todos'
      ? _spaces
      : _spaces.where((s) => s.sportType == _selectedSport).toList();
  List<SportsSpace> get favoritesSpaces => _favoritesSpaces;
  List<ReservedSpace> get reservedSpaces => _reservedSpaces;
  List<NotificationItem> get notifications => _notifications;
  String get selectedSport => _selectedSport;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoadingSpaces => _isLoadingSpaces;
  String? get spacesError => _spacesError;

  // Métodos
  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  Future<void> fetchUserData(String userId) async {
    try {
      final userData = await UserService.fetchUserById(userId); // Busca os dados do usuário no banco
      _userName = userData['name'] ?? 'Usuário';
      _userEmail = userData['email'] ?? 'email@exemplo.com';
      notifyListeners(); // Notifica os widgets que dependem do AppState
    } catch (e) {
      debugPrint('Erro ao buscar dados do usuário: $e');
    }
  }

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