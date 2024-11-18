import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal.dart';

class DatabaseServices {
  static Database? _database;

  // Singleton pattern
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meals.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE meals(
            idMeal TEXT PRIMARY KEY,
            strMeal TEXT,
            strDrinkAlternate TEXT,
            strCategory TEXT,
            strArea TEXT,
            strInstructions TEXT,
            strMealThumb TEXT,
            strTags TEXT,
            strYoutube TEXT,
            strIngredient1 TEXT,
            strIngredient2 TEXT,
            strIngredient3 TEXT,
            strIngredient4 TEXT,
            strIngredient5 TEXT,
            strIngredient6 TEXT,
            strIngredient7 TEXT,
            strIngredient8 TEXT,
            strIngredient9 TEXT,
            strIngredient10 TEXT,
            strIngredient11 TEXT,
            strIngredient12 TEXT,
            strIngredient13 TEXT,
            strIngredient14 TEXT,
            strIngredient15 TEXT,
            strIngredient16 TEXT,
            strIngredient17 TEXT,
            strIngredient18 TEXT,
            strIngredient19 TEXT,
            strIngredient20 TEXT,
            strMeasure1 TEXT,
            strMeasure2 TEXT,
            strMeasure3 TEXT,
            strMeasure4 TEXT,
            strMeasure5 TEXT,
            strMeasure6 TEXT,
            strMeasure7 TEXT,
            strMeasure8 TEXT,
            strMeasure9 TEXT,
            strMeasure10 TEXT,
            strMeasure11 TEXT,
            strMeasure12 TEXT,
            strMeasure13 TEXT,
            strMeasure14 TEXT,
            strMeasure15 TEXT,
            strMeasure16 TEXT,
            strMeasure17 TEXT,
            strMeasure18 TEXT,
            strMeasure19 TEXT,
            strMeasure20 TEXT,
            strSource TEXT,
            strImageSource TEXT,
            strCreativeCommonsConfirmed TEXT,
            dateModified TEXT
          );
        ''');
      },
    );
  }

  // Insert a meal into the database
  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    await db.insert(
      'meals',
      meal.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all meals from the database
  Future<List<Meal>> getMeals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meals');

    return List.generate(maps.length, (i) {
      return Meal.fromJson(maps[i]);
    });
  }

  // Get a meal by its ID
  Future<Meal?> getMealById(String idMeal) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      where: 'idMeal = ?',
      whereArgs: [idMeal],
    );

    if (maps.isNotEmpty) {
      return Meal.fromJson(maps.first);
    }
    return null;
  }

  // Update a meal
  Future<void> updateMeal(Meal meal) async {
    final db = await database;
    await db.update(
      'meals',
      meal.toJson(),
      where: 'idMeal = ?',
      whereArgs: [meal.idMeal],
    );
  }

  // Delete a meal by its ID
  Future<void> deleteMeal(String idMeal) async {
    final db = await database;
    await db.delete(
      'meals',
      where: 'idMeal = ?',
      whereArgs: [idMeal],
    );
  }

  // Delete all meals
  Future<void> deleteAllMeals() async {
    final db = await database;
    await db.delete('meals');
  }

  Future<int> getNextId() async {
    final db = await database;
    var result =
        await db.rawQuery('SELECT MAX(CAST(idMeal AS INTEGER)) FROM meals');

    // If the result is null, set the next id to 1
    int nextId = 1;
    if (result.isNotEmpty &&
        result[0]['MAX(CAST(idMeal AS INTEGER))'] != null) {
      nextId =
          int.tryParse(result[0]['MAX(CAST(idMeal AS INTEGER))'].toString())! +
              1;
    }
    return nextId;
  }
}
