import 'package:flutter/material.dart';
import 'package:objectbox_demo/components/PostDishConfDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dishes = [
    {
      "name": "Tea",
      "type": "Breakfast",
      "cost": 15,
    },
    {
      "name": "Coffee",
      "type": "Breakfast",
      "cost": 20,
    },
    {
      "name": "Cup Cake",
      "type": "Breakfast",
      "cost": 20,
    },
    {
      "name": "Pizza",
      "type": "Snacks",
      "cost": 200,
    },
    {
      "name": "Burger",
      "type": "Breakfast",
      "cost": 150,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dishes.length,
      itemBuilder: (context, index) => ListTile(
        title: Text("${dishes[index]['name']}"),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => PostDishConfDialog(dishMap: dishes[index]));
        },
      ),
    );
  }
}
