import 'package:objectbox/objectbox.dart';

@Entity()
class Dish {
  int? id;
  final String name, type;
  final int cost;

  Dish({
    this.id = 0,
    required this.name,
    required this.type,
    required this.cost,
  });
}
