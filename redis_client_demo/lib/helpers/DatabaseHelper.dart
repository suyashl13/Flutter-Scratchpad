import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:redis/redis.dart';

class DatabaseHelper {
  final conn = RedisConnection();

  Future getTodos(int startIndex, int endIndex) async {
    var response;

    var res = await conn.connect(
        'redis-11558.c305.ap-south-1-1.ec2.cloud.redislabs.com', 11558);
    await res.send_object(['AUTH', '3SSs9XBYAVP5vDOwXKGvDYs0XTq3a6Mh']);
    response = await res.send_object(["lrange", "todos", startIndex, endIndex]);

    return response;
  }

  Future postTodo(Map todo) async {
    var res = await conn.connect(
        'redis-11558.c305.ap-south-1-1.ec2.cloud.redislabs.com', 11558);
    await res.send_object(['AUTH', '3SSs9XBYAVP5vDOwXKGvDYs0XTq3a6Mh']);
    await res.send_object(["lpush", "todos", jsonEncode(todo)]);
  }

  Future deleteTodo(int index) async {
    var res = await conn.connect(
        'redis-11558.c305.ap-south-1-1.ec2.cloud.redislabs.com', 11558);
    await res.send_object(['AUTH', '3SSs9XBYAVP5vDOwXKGvDYs0XTq3a6Mh']);
    await res.send_object(["lpop", "todos", index.toString()]);
  }
}
