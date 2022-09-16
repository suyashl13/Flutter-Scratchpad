import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:objectbox_demo/helpers/DishHelper.dart';

class PostDishConfDialog extends StatelessWidget {
  final dishMap;
  const PostDishConfDialog({required this.dishMap});

  Future _makePost(context) async {
    try {
      await DishHelper.postDishes(dishMap);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Added ${dishMap['name']}")));
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Unable to add dish..")));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Are you sure want to add ? ${dishMap['name']}"),
      actions: [
        TextButton(
            onPressed: () => _makePost(context), child: const Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"))
      ],
    );
  }
}
