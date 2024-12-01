import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'landingpage.dart';
import 'registrationpage.dart'; // Ensure this path is correct
import 'forgotpinpage.dart'; // Ensure this path is correct

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _pinControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // void _checkPinAndNavigate() async {
  //   String pin = _pinControllers.map((c) => c.text).join();
  //   var snapshot = await FirebaseFirestore.instance.collection('registrations').where('pin', isEqualTo: pin).get();
  //   if (snapshot.docs.isNotEmpty) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid PIN')));
  //   }
  // }
  void _checkPinAndNavigate() async {
    String pin = _pinControllers.map((c) => c.text).join();
    var snapshot = await FirebaseFirestore.instance
        .collection('registrations')
        .where('pin', isEqualTo: pin)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String uid = snapshot.docs.first.id; // Get the document ID of the user
      String email = snapshot.docs.first['email']; // Get the email of the user
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardPage(
                    uid: uid,
                    email: email,
                    userDetails: {},
                  ) // Pass userId and email
              ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid PIN')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                            child: Column(
                              children: [
                                Text("eNutrition",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.pink.shade800,
                                        fontFamily: 'Inter-Italic',
                                        fontWeight: FontWeight.w900)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: SizedBox(
                                        width: 50,
                                        child: TextField(
                                          controller: _pinControllers[index],
                                          focusNode: _focusNodes[index],
                                          autofocus: index ==
                                              0, // Automatically focus the first pin field
                                          obscureText: true,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 24),
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            counterText: "",
                                          ),
                                          onChanged: (value) {
                                            if (value.length == 1 &&
                                                index < 3) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _focusNodes[index + 1]);
                                            } else if (value.isEmpty &&
                                                index > 0) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _focusNodes[index - 1]);
                                            } else if (index == 3 &&
                                                value.isNotEmpty) {
                                              FocusScope.of(context).unfocus();
                                              _checkPinAndNavigate();
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ElevatedButton(
                                        onPressed: _checkPinAndNavigate,
                                        child: const Text("Login")),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Divider(),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPinPage()),
                                    );
                                  },
                                  child: const Text('Forgot your PIN?'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegistrationPage()),
                                    );
                                  },
                                  child: const Text('No account yet? Sign up'),
                                ),
                              ],
                            ),
                          )
                        ])))))));
  }
}
