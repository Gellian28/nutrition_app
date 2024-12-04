import 'package:flutter/material.dart';
import 'package:enutrition_app/widgets/nutritional_survey_form.dart'; // Import the new form widget

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showPrivacyNotice(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Notice'),
          content: const Text(
              'Ako ay nagbibigay ng pahintulot sa Pamahalaan ng Lungsod ng Tayabas sa pagkoleksyon; paggamit ng ayon sa batas, at pagsisiwalat ng aking personal na impormasyon na maaaring kasama ang pangalan, address, petsa ng kapanganaka, numero ng telepono at iba pang detalye. Ang pahintulot na ito ay nagbibigay-daan sa Pamahalaan ng Lungsod ng Tayabas na sumunod sa RA 10173 o mas kilala bilang Data Privacy Act of 2012.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the Nutritional Survey Form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NutritionalSurveyForm(),
                  ),
                );
              },
              child: const Text('Agree'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showPrivacyNotice(context),
          child: const Text('Take Nutritional Survey'),
        ),
      ),
    );
  }
}
