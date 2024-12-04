import 'package:flutter/material.dart';
import 'package:enutrition_app/services/firebase_db.dart';

class BmiInfo extends StatelessWidget {
  final String email;
  const BmiInfo({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Information'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchBmiDetails(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No BMI information available'));
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Height: ${data['height']} cm'),
              Text('Weight: ${data['weight']} kg'),
              Text('BMI: ${data['bmi']}'),
              Text('Status: ${data['status']}'),
            ],
          );
        },
      ),
    );
  }
}
