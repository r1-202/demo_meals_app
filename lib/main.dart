import 'dart:io';

import 'package:demo_meals_app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/meal.dart';
import 'utils/http_getters.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/meals_screen.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getBool('saved') ?? false;
  if (!saved) {
    await saveMeals();
    await prefs.setBool('saved', true);
  }
  final db = DatabaseServices();
  db.deleteAllMeals();
  Meal meal = Meal();
  meal.strMeal = "Meal Name 1";
  meal.idMeal = "1";
  await db.insertMeal(meal);
  meal.strMeal = "Meal Name 2";
  meal.idMeal = "2";
  await db.insertMeal(meal);
  meal.strMeal = "Meal Name 3";
  meal.idMeal = "3";
  await db.insertMeal(meal);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Meals App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MealsScreen());
  }
}
