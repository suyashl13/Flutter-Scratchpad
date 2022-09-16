import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DishHelper {
  static const String BASE_URL = "http://10.0.2.2:3000/dish";

  static Future getDishes() async {
    try {
      final response = await http.get(Uri.parse(BASE_URL));
      return jsonDecode(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future postDishes(Map dishData) async {
    dishData['cost'] = dishData['cost'].toString();
    debugPrint(dishData.toString());
    try {
      final response = await http.post(Uri.parse(BASE_URL), body: jsonEncode(dishData), headers: {
        'Content-Type': 'application/json'
      });
      if (response.statusCode != 200) {
        throw response.body;
      }
      return jsonDecode(response.body);
    } catch (e) {
      throw e.toString();
    }
  }
}
