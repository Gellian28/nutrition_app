import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:enutrition_app/infos/user_info_page.dart';
import 'package:enutrition_app/infos/bmi_infos.dart'; // Import the new BmiPage
import 'package:enutrition_app/infos/health_history_infos.dart'; // Import the new HealthHistoryPage
import 'package:enutrition_app/infos/meal_plan_infos.dart'; // Import the new MealPlanPage

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          buildProfileHeader(),
          buildButtonGroup(),
        ],
      ),
    );
  }

  // Header displaying user info
  Widget buildProfileHeader() {
    return Container(
      color: Colors.pink,
      height: 160,
      child: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('registrations')
              .where('uid', isEqualTo: widget.uid)
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

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    userProfile['firstname'][0],
                    style: const TextStyle(fontSize: 30, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${userProfile['firstname']} ${userProfile['lastname']}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  userProfile['email'],
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Vertical Button Layout
  Widget buildButtonGroup() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextButton(
            onPressed: () => navigateToNewPage(UserInfo(uid: widget.uid)),
            child: const Text('User Information'),
          ),
          TextButton(
            onPressed: () => navigateToNewPage(BmiInfo(email: widget.uid)),
            child: const Text('BMI'),
          ),
          TextButton(
            onPressed: () =>
                navigateToNewPage(HealthHistoryInfo(uid: widget.uid)),
            child: const Text('Health History'),
          ),
          TextButton(
            onPressed: () => navigateToNewPage(MealPlanInfo(uid: widget.uid)),
            child: const Text('Meal Plan'),
          ),
        ],
      ),
    );
  }

  // Method to navigate to a new page
  void navigateToNewPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
