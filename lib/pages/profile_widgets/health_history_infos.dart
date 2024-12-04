import 'package:flutter/material.dart';
import 'package:enutrition_app/services/firebase_db.dart';

class HealthHistoryInfo extends StatelessWidget {
  final String uid;
  const HealthHistoryInfo({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health History'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchHealthHistory(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No health history available'));
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Allergies: ${data['allergies']}'),
              Text('Medical Conditions: ${data['medical_conditions']}'),
              Text('Medications: ${data['medications']}'),
              // Add more fields as necessary
            ],
          );
        },
      ),
    );
  }
}
