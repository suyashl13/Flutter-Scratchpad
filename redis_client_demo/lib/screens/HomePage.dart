import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redis/redis.dart';
import 'package:redis_client_demo/helpers/DatabaseHelper.dart';
import 'package:redis_client_demo/screens/PubSubDemo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? todoList;

  _init() async {
    List _todoList = await DatabaseHelper().getTodos(0, 10);
    try {
      setState(() {
        todoList = _todoList;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Redis DB Demo", style: TextStyle(fontSize: 16)),
        ),
        body: todoList == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoList!.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(jsonDecode(todoList![index])['todo']),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.maxFinite,
                    child: MaterialButton(
                      color: Colors.green,
                      child: const Text("Pub-Sub Demo"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PubSubDemo()));
                      },
                    ),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final ranString = "DEMO : ${Random().nextInt(100)}";
            await DatabaseHelper().postTodo({'todo': ranString});
          },
          child: const Icon(Icons.add),
        ),
      );
}
