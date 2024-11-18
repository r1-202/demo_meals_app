import 'package:demo_meals_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/database_services.dart';

class PopupMenuWidget extends StatelessWidget {
  final Meal meal;
  final Function onUpdate;
  PopupMenuWidget(this.meal, this.onUpdate);

  void editMeal(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailsScreen(meal, true, "Edit Meal", onUpdate)));
  }

  void removeMeal() async {
    final db = DatabaseServices();
    await db.deleteMeal(meal.idMeal!);
    onUpdate();
  }

  void favoriteMeal() {}

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert),
      onSelected: (int value) {
        switch (value) {
          case 1:
            // Call method for Edit
            editMeal(context);
          case 2:
            // Call method for Remove
            removeMeal();
          case 3:
            // Call method for Favorite
            favoriteMeal();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: Text('Edit'),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text('Remove'),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text('Favorite'),
        ),
      ],
    );
  }
}
