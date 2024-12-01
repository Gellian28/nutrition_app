import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResetPinPage extends StatefulWidget {
  final String email; // Accept email from ForgotPinPage
  const ResetPinPage({super.key, required this.email});

  @override
  ResetPinPageState createState() => ResetPinPageState();
}

class ResetPinPageState extends State<ResetPinPage> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  Future<void> _resetPin() async {
    String pin = _pinControllers.map((controller) => controller.text).join();

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit PIN.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var userDocument = await _firestore
          .collection('registrations')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userDocument.docs.isNotEmpty) {
        // Update the PIN in Firestore
        await userDocument.docs.first.reference.update({'pin': pin});

        // Automatically redirect to the login page after successful PIN reset
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset PIN: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset PIN'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _pinControllers[index],
                    focusNode: index == 0
                        ? _focusNode1
                        : index == 1
                            ? _focusNode2
                            : index == 2
                                ? _focusNode3
                                : _focusNode4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Text('Reset PIN'),
            ),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
