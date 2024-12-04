// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enutrition_app/pages/profile_widgets/bmi_infos.dart';
import 'package:enutrition_app/pages/profile_widgets/health_history_infos.dart';
import 'package:enutrition_app/pages/profile_widgets/meal_plan_infos.dart';
import 'package:enutrition_app/pages/profile_widgets/user_info_page.dart';
import 'package:enutrition_app/services/firebase_db.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late final Future<Map<String, dynamic>?> userDetails;

  @override
  void initState() {
    super.initState();
    print('User UID: ${widget.uid}'); // Log the UID for verification
    userDetails = fetchUserDetails(widget.uid);
  }

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
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user data available'));
            }

            final userProfile = snapshot.data!;

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
