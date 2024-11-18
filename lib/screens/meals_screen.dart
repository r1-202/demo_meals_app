import 'package:demo_meals_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/database_services.dart';
import '../widgets/meal_widget.dart';

class MealsScreen extends StatefulWidget {
  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late Future<List<Meal>> futureMeals;

  @override
  void initState() {
    final db = DatabaseServices();
    super.initState();
    futureMeals = db.getMeals();
  }

  void _refreshData() {
    final db = DatabaseServices();
    setState(() {
      futureMeals = db.getMeals();
    });
    print('refreshed\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Meals'),
        ),
        body: Stack(children: [
          Center(
            child: FutureBuilder<List<Meal>>(
              future: futureMeals,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final meals = snapshot.data!;
                  return ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return MealWidget(meal, _refreshData);
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(Meal(), true, "Create Meal", _refreshData)));
              },
              child: Icon(Icons.add),
            ),
          )
        ]));
  }
}
