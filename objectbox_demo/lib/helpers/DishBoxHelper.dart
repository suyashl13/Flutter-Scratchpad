import 'package:objectbox_demo/models/Dishes.dart';
import 'package:objectbox_demo/objectbox.g.dart';

class DishBoxHelper {
  static addDish(Map disData) async {
    var store = await openStore();
    var newDish = Dish(
        name: disData['name'], type: disData['type'], cost: disData['cost']);

    return store.box<Dish>().put(newDish);
  }

  static getDishList() async {
    var store = await openStore();
    var dishBox = store.box<Dish>();
    return dishBox.getAll();
  }
}
