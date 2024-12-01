import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo extends StatelessWidget {
  final String uid; // Pass the user's unique identifier

  const UserInfo({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('registrations')
          .where('uid', isEqualTo: uid) // Change from 'email' to 'uid'
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No user data available'));
        }

        final userProfile = snapshot.data!.docs.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProfileInfo('Phone', userProfile['phone']),
              buildProfileInfo('Gender', userProfile['gender']),
              buildProfileInfo('Birthday', userProfile['birthday']),
              buildProfileInfo('Barangay', userProfile['barangay']),
              buildProfileInfo('City', userProfile['city']),
              buildProfileInfo('Province', userProfile['province']),
              buildProfileInfo('Postal Code', userProfile['postalCode']),
            ],
          ),
        );
      },
    );
  }

  Widget buildProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
