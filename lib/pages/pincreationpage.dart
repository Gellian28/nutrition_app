import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enutrition_app/pages/loginpage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PinCreationPage extends StatefulWidget {
  final String uid;
  final String firstname,
      lastname,
      birthday,
      gender,
      phone,
      email,
      barangay,
      city,
      province,
      postalCode;

  const PinCreationPage({
    super.key,
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.gender,
    required this.phone,
    required this.email,
    required this.barangay,
    required this.city,
    required this.province,
    required this.postalCode,
  });

  @override
  PinCreationPageState createState() => PinCreationPageState();
}

class PinCreationPageState extends State<PinCreationPage> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isPinValid = false;

  String _hashPin(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }

  Future<void> _savePin() async {
    String pin = _pinControllers.map((controller) => controller.text).join();

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit PIN')),
      );
      return;
    }

    try {
      // Hash the PIN before storing
      String hashedPin = _hashPin(pin);

      // Update the document using the predefined UID
      await FirebaseFirestore.instance
          .collection('registrations')
          .doc(widget.uid)
          .update({
        'pin': hashedPin,
        'isProfileComplete': true,
      });

      // Navigate to LoginPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN created successfully!')),
      );
    } catch (e) {
      print("Error updating PIN: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update PIN!')),
      );
    }
  }

  void _checkPinValidity() {
    String pin = _pinControllers.map((controller) => controller.text).join();
    setState(() {
      _isPinValid = pin.length == 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Create PIN'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Your 4-Digit PIN',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.pink.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _pinControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          obscureText: true,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.pink.shade100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.pink.shade300),
                            ),
                          ),
                          onChanged: (value) {
                            _checkPinValidity();
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index + 1]);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isPinValid ? _savePin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade200,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.pink.shade100,
                  ),
                  child: const Text('Create PIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
