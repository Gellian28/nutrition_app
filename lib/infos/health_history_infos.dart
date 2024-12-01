import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthHistoryInfo extends StatelessWidget {
  final String uid; // Pass the user's email

  const HealthHistoryInfo({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('health_assessments')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No health history data available'));
        }

        final healthHistoryData = snapshot.data!.docs;

        return ListView.builder(
          itemCount: healthHistoryData.length,
          itemBuilder: (context, index) {
            final data = healthHistoryData[index];

            // Retrieve health information
            final height = data['height'] ?? 'N/A';
            final weight = data['weight'] ?? 'N/A';
            final bmi = data['bmi'] ?? 'N/A';
            final takingMedications = data['takingMedications'] ?? 'N/A';
            final decreasedAppetite = data['decreasedAppetite'] ?? 'N/A';
            final weightLoss = data['weightLoss'] ?? 'N/A';
            final difficultyBowel = data['difficultyBowel'] ?? 'N/A';
            final pregnant = data['pregnant'] ?? 'N/A';
            final breastfeeding = data['breastfeeding'] ?? 'N/A';
            final smoking = data['smoking'] ?? 'N/A';
            final drinkingAlcohol = data['drinkingAlcohol'] ?? 'N/A';
            final chronicDisease = data['chronicDisease'] ?? 'N/A';

            // Family health history
            final familyHistory = data['familyHistory'] ?? {};
            final father = familyHistory['father'] ?? {};
            final mother = familyHistory['mother'] ?? {};
            final siblings = familyHistory['siblings'] ?? [];

            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Personal Health Information:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Height: $height cm'),
                    Text('Weight: $weight kg'),
                    Text('BMI: $bmi'),
                    Text('Taking Medications: $takingMedications'),
                    Text('Decreased Appetite: $decreasedAppetite'),
                    Text('Weight Loss: $weightLoss'),
                    Text('Difficulty Bowel: $difficultyBowel'),
                    Text('Pregnant: $pregnant'),
                    Text('Breastfeeding: $breastfeeding'),
                    Text('Smoking: $smoking'),
                    Text('Drinking Alcohol: $drinkingAlcohol'),
                    Text('Chronic Disease: $chronicDisease'),
                    const SizedBox(height: 16.0),
                    const Text('Family Health History:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Father:'),
                    Text('  Age: ${father['age'] ?? 'N/A'}'),
                    Text('  Alive: ${father['alive'] ?? 'N/A'}'),
                    Text(
                        '  Health Problems: ${father['healthProblems'] ?? 'N/A'}'),
                    const SizedBox(height: 8.0),
                    const Text('Mother:'),
                    Text('  Age: ${mother['age'] ?? 'N/A'}'),
                    Text('  Alive: ${mother['alive'] ?? 'N/A'}'),
                    Text(
                        '  Health Problems: ${mother['healthProblems'] ?? 'N/A'}'),
                    const SizedBox(height: 8.0),
                    const Text('Siblings:'),
                    for (final sibling in siblings)
                      Text(
                          '  ${sibling['gender']}: Age: ${sibling['age']}, Alive: ${sibling['alive']}, Health Problems: ${sibling['healthProblems']}'),
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
