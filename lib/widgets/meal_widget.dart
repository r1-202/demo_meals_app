import 'package:demo_meals_app/screens/details_screen.dart';
import 'package:demo_meals_app/widgets/image_widget.dart';
import 'package:demo_meals_app/widgets/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealWidget extends StatelessWidget {
  final Meal meal;
  final Function onUpdate;

  MealWidget(this.meal, this.onUpdate);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(meal, false, "Meal Details", onUpdate),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 75,
                height: 75,
                child: ImageWidget(meal.strMealThumb),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.strMeal!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${meal.strIngredient1??""},${meal.strIngredient2??""},${meal.strIngredient3??""}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuWidget(meal, onUpdate)
            ],
          ),
        ),
      ),
    );
  }
}
