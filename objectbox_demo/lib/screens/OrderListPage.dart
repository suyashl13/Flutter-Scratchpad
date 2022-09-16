import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:objectbox_demo/components/PostDishConfDialog.dart';
import 'package:objectbox_demo/helpers/DishBoxHelper.dart';
import 'package:objectbox_demo/helpers/DishHelper.dart';
import 'package:redis/redis.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final RedisConnection conn = RedisConnection();
  late PubSub pubsub;
  late List dishes;
  bool isLoading = true;
  bool isError = false;

  _initialize() async {
    try {
      List tempDishes = await DishHelper.getDishes();

      Command cmd = await conn.connect(
          'redis-11558.c305.ap-south-1-1.ec2.cloud.redislabs.com', 11558);
      cmd.send_object(['AUTH', '3SSs9XBYAVP5vDOwXKGvDYs0XTq3a6Mh']);
      pubsub = PubSub(cmd);
      pubsub.subscribe(['dish-watch']);
      Stream stream = pubsub.getStream();
      setState(() {
        dishes = tempDishes;
        isLoading = false;
      });
      var streamWithoutErrors = stream.handleError((e) => print("error $e"));
      await for (final msg in streamWithoutErrors) {
        setState(() {
          dishes = [jsonDecode(msg[2]) ,...dishes];
        });
        DishBoxHelper.addDish(jsonDecode(msg[2]));
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? isError
            ? const Center(child: Text("Error"))
            : const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: dishes.length,
          itemBuilder: (context, index) => ListTile(title: Text(dishes[index]['name'])),
          );
  }
}
