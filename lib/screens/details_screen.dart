import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/database_services.dart';
import '../widgets/image_widget.dart';

class DetailsScreen extends StatefulWidget {
  final Meal meal;
  final bool edit;
  final String title;
  DetailsScreen(this.meal, this.edit, this.title);
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Meal meal;
  late List<String?> measurementList;
  late List<String?> ingredientsList;
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late List<TextEditingController> _ingredientControllerList;
  late List<TextEditingController> _measurementControllerList;

  @override
  void initState() {
    super.initState();
    meal = widget.meal;
    measurementList = meal.getMeasurements();
    ingredientsList = meal.getIngredients();
    _controller1 = TextEditingController(text: meal.strMeal);
    _controller2 = TextEditingController(text: meal.strInstructions);
    _ingredientControllerList = List<TextEditingController>.empty(growable: true);
    for (int i = 0; i < ingredientsList.length; ++i) {
      _ingredientControllerList
          .add(TextEditingController(text: ingredientsList[i]));
    }
    _measurementControllerList = List<TextEditingController>.empty(growable: true);
    for (int i = 0; i < measurementList.length; ++i) {
      _measurementControllerList
          .add(TextEditingController(text: measurementList[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  SizedBox(height: 16),
                  TextField(
                    controller: _controller1,
                    enabled: widget.edit,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        meal.strMeal = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Recipe Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                      child: SizedBox(
                    width: 200,
                    height: 200,
                    child: ImageWidget(meal.strMealThumb),
                  )),
                  TextField(
                    controller: _controller2,
                    enabled: widget.edit,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        meal.strInstructions = value;
                      });
                    },
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Instructions',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                      children: List.generate(ingredientsList.length, (index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: TextField(
                            controller: _ingredientControllerList[index],
                            enabled: widget.edit,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                ingredientsList[index] = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Ingredient ${index + 1}'),
                          )),
                          SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: _measurementControllerList[index],
                            enabled: widget.edit,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                measurementList[index] = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Measurement ${index + 1}'),
                          ))
                        ]);
                  })),
                  if (widget.edit) ...[
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ElevatedButton(
                          onPressed: () {
                            save();
                            Navigator.pop(context, meal);
                          },
                          child: Text('Save')),
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    ])
                  ]
                ]))));
  }

  void save() async {
    meal.setIngredients(ingredientsList);
    meal.setMeasurements(measurementList);
    final db = DatabaseServices();
    int id = await db.getNextId();
    meal.idMeal = id.toString();
    await db.insertMeal(meal);
  }
}
