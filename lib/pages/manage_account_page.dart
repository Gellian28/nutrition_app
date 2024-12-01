import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginpage.dart'; // Ensure this path is correct

class ManageAccountPage extends StatelessWidget {
  const ManageAccountPage({super.key});

  Future<void> logoutUser(BuildContext context) async {
    // Replace this with your logic to get the current user's email
    String currentUserEmail = 'user@example.com'; 

    try {
      // Get the user's document from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('email', isEqualTo: currentUserEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Update the user document to mark them as logged out
        await userDoc.reference.update({'loggedIn': false}); // Assuming you have a loggedIn field

        // Log additional info about the logout
        print('User logged out: ${userDoc['firstname']} ${userDoc['lastname']}');
      }

      // After updating Firestore, navigate back to the login page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );

    } catch (e) {
      print("Error during logout: $e");
      // Handle any errors (optional)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Account'),
        backgroundColor: const Color.fromARGB(255, 247, 128, 168),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Manage your account settings here.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logoutUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 238, 70, 126),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
