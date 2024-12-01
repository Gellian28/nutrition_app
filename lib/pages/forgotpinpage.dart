import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'resetpinpage.dart'; // Ensure you import the ResetPinPage

class ForgotPinPage extends StatefulWidget {
  const ForgotPinPage({super.key});

  @override
  ForgotPinPageState createState() => ForgotPinPageState();
}

class ForgotPinPageState extends State<ForgotPinPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Removed _auth

  Future<void> checkEmailAndNavigate() async {
    try {
      String email = _emailController.text;

      // Fetch user document with matching email from Firestore
      var snapshot = await _firestore
          .collection(
              'registrations') // Assuming 'registrations' collection contains user data
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Email exists, redirect to ResetPinPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResetPinPage(email: email), // Pass email to ResetPinPage
          ),
        );
      } else {
        // Email not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not found!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Forgot PIN'), backgroundColor: Colors.pink),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Enter your email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkEmailAndNavigate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text('Reset Pin'),
            ),
          ],
        ),
      ),
    );
  }
}
