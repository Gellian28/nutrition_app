import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BmiInfo extends StatelessWidget {
  final String email; // Pass the user's email

  const BmiInfo({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users_bmi')
          .where('email', isEqualTo: email)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No BMI data available'));
        }

        final bmiData = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bmiData.length,
          itemBuilder: (context, index) {
            final data = bmiData[index];
            final bmi = data['bmi'] ?? 0;
            final dateOfMonitoring = data['date_of_monitoring'] ?? '';
            final height = data['height'] ?? 0;
            final weight = data['weight'] ?? 0;
            final nutritionalStatus = data['nutritional_status'] ?? '';
            final timestamp = (data['timestamp'] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text('BMI: ${bmi.toStringAsFixed(2)}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date of Monitoring: $dateOfMonitoring'),
                    Text('Height: $height cm'),
                    Text('Weight: $weight kg'),
                    Text('Nutritional Status: $nutritionalStatus'),
                    Text('Recorded on: ${timestamp.toLocal().toString()}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
