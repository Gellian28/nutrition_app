import 'package:flutter/material.dart';
import 'package:enutrition_app/services/firebase_db.dart';

class UserInfo extends StatelessWidget {
  final String uid;
  const UserInfo({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserDetails(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user information available'));
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('First Name: ${data['firstname']}'),
              Text('Last Name: ${data['lastname']}'),
              Text('Email: ${data['email']}'),
              Text('Phone: ${data['phone']}'),
              // Add more fields as necessary
            ],
          );
        },
      ),
    );
  }
}
