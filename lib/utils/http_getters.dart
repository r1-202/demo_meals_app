library http_getters;

import 'dart:convert';

import '../models/meal.dart';
import 'package:http/http.dart' as http;

import '../services/database_services.dart';

Future<List<Meal>> getAllMealsHTTP() async {
  List<Meal> list = List<Meal>.empty(growable: true);
  final alphabet = "abcdefghijklmnopqrstuvwxyz"
      .runes
      .map((int rune) => String.fromCharCode(rune));
  for (var c in alphabet) {
    http.Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=$c"));
    if (response.statusCode != 200) {
      continue;
    }
    Map<String, dynamic> jsonMap =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (jsonMap["meals"] == null) continue;
    var listJson = jsonMap["meals"] as List<dynamic>;
    for (var l in listJson) {
      list.add(Meal.fromJson(l));
    }
  }
  return list;
}

Future<void> saveMeals() async {
  var list = await getAllMealsHTTP();
  final db = DatabaseServices();
  for (var meal in list) {
    await db.insertMeal(meal);
  }
}
