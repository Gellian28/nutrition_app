import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:enutrition_app/widgets/bmi_calculator_widget.dart';

class AddServicePage extends StatelessWidget {
  const AddServicePage({super.key, required String uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nutritional Monitoring'),
          centerTitle: true,
        ),
        body: const BMICalculatorWidget(
          uid: '',
          email: '',
        ));
  }
}
