import '../models/sports_space.dart';
class ReservedSpace {
  final SportsSpace space;
  final DateTime dateTime;
  final int hours;
  ReservedSpace(
      {required this.space, required this.dateTime, required this.hours});
}