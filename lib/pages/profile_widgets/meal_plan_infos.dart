import 'package:flutter/material.dart';
import 'package:enutrition_app/services/firebase_db.dart';

class MealPlanInfo extends StatelessWidget {
  final String uid;
  const MealPlanInfo({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchMealPlan(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No meal plan available'));
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Breakfast: ${data['breakfast']}'),
              Text('Lunch: ${data['lunch']}'),
              Text('Dinner: ${data['dinner']}'),
              Text('Snacks: ${data['snacks']}'),
            ],
          );
        },
      ),
    );
  }
}
