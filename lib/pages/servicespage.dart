import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore.collection('services').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while data is fetching
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if something goes wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Build a list view if data is available
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Text(data['description'] ?? 'No Description'),
                );
              }).toList(),
            );
          } else {
            // Show a message if there are no documents
            return const Center(child: Text('No services found'));
          }
        },
      ),
    );
  }
}
