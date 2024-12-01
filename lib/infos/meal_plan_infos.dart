import 'package:flutter/material.dart';

class MealPlanInfo extends StatelessWidget {
  final String uid; // Pass the user's UUID

  const MealPlanInfo({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // Here, you would typically fetch meal plans from Firestore using the user's email.
    // For now, we will display a placeholder message.
    return const Center(child: Text('Meal Plan will be displayed here.'));
  }
}
