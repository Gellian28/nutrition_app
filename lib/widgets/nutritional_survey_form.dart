import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionalSurveyForm extends StatefulWidget {
  final String? documentId; // Add documentId to the constructor

  const NutritionalSurveyForm({super.key, this.documentId});

  @override
  NutritionalSurveyFormState createState() => NutritionalSurveyFormState();
}

class NutritionalSurveyFormState extends State<NutritionalSurveyForm> {
  final _formKey = GlobalKey<FormState>();

  // Document ID to determine whether to create or update
  String? _documentId;

  // Questionnaire responses
  bool? _takingMedications;
  bool? _decreasedAppetite;
  bool? _weightLoss;
  bool? _difficultyBowel;
  bool? _pregnant;
  bool? _breastfeeding;
  bool? _smoking;
  bool? _drinkingAlcohol;
  bool? _sedentary;
  bool? _lightlyActive;
  bool? _moderatelyActive;
  bool? _veryActive;
  bool? _chronicDisease;

  // Additional Medical Conditions
  bool? _arthritis;
  bool? _diabetes;
  bool? _highBloodPressure;
  bool? _cancer;
  bool? _kidneyDisease;
  bool? _asthma;
  bool? _fattyLiver;
  bool? _tuberculosis;
  bool? _obesity;
  String? _otherMedicalConditions; // Text input for other medical conditions

 // Family Health History
  String? _motherAge;
  bool? _motherInGoodHealth;
  String? _motherHealthProblems;
  bool? _motherAlive;

  String? _fatherAge;
  bool? _fatherInGoodHealth;
  String? _fatherHealthProblems;
  bool? _fatherAlive;

  // List to handle siblings
  final List<Map<String, dynamic>> _siblings = [];

  // Privacy agreement
  bool _privacyAgreement = false;

  @override
  void initState() {
    super.initState();
    _documentId = widget.documentId; // Initialize document ID from constructor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Assessment Form', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 247, 128, 168),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Health Questionnaire'),
              _buildYesNoCheckbox('Kasalukuyan bang may iniinum na mga gamot?', (value) => setState(() => _takingMedications = value), _takingMedications),
              _buildYesNoCheckbox('Bumaba ba ang pagkain sa nakalipas na 3 buwan?', (value) => setState(() => _decreasedAppetite = value), _decreasedAppetite),
              _buildYesNoCheckbox('Nakaranas ba ng pagbaba ng timbang?', (value) => setState(() => _weightLoss = value), _weightLoss),
              _buildYesNoCheckbox('Nakaranas ba ng hirap sa pagdumi?', (value) => setState(() => _difficultyBowel = value), _difficultyBowel),
              _buildYesNoCheckbox('Kung babae, ikaw ba ay nagdadalangtao?', (value) => setState(() => _pregnant = value), _pregnant),
              _buildYesNoCheckbox('Kung babae, ikaw ba ay nagpapasuso?', (value) => setState(() => _breastfeeding = value), _breastfeeding),
              _buildYesNoCheckbox('Ikaw ba ay naninigarilyo?', (value) => setState(() => _smoking = value), _smoking),
              _buildYesNoCheckbox('Umiinom ng alak?', (value) => setState(() => _drinkingAlcohol = value), _drinkingAlcohol),

              _buildSectionTitle('Medical Conditions'),
              _buildYesNoCheckbox('Arthritis', (value) => setState(() => _arthritis = value), _arthritis),
              _buildYesNoCheckbox('Diabetes', (value) => setState(() => _diabetes = value), _diabetes),
              _buildYesNoCheckbox('High Blood Pressure', (value) => setState(() => _highBloodPressure = value), _highBloodPressure),
              _buildYesNoCheckbox('Cancer', (value) => setState(() => _cancer = value), _cancer),
              _buildYesNoCheckbox('Kidney Disease', (value) => setState(() => _kidneyDisease = value), _kidneyDisease),
              _buildYesNoCheckbox('Asthma', (value) => setState(() => _asthma = value), _asthma),
              _buildYesNoCheckbox('Fatty Liver', (value) => setState(() => _fattyLiver = value), _fattyLiver),
              _buildYesNoCheckbox('Tuberculosis', (value) => setState(() => _tuberculosis = value), _tuberculosis),
              _buildYesNoCheckbox('Obesity', (value) => setState(() => _obesity = value), _obesity),

              // Additional Medical Condition TextField
              _buildSectionTitle('Kung ang nilagyan ng tsek ay "Mga iba pang sakit", ilagay ang specific medical condition:'),
              _buildTextField(),

              _buildSectionTitle('Physical Activity'),
              _buildYesNoCheckbox('Sedentary - madalas ay naka-upo, kalimitang gawain sa bahay na hindi mabigat', (value) => setState(() => _sedentary = value), _sedentary),
              _buildYesNoCheckbox('Lightly Active - naglalaan ng 30 minuto simpleng ehersisyo araw-araw katulad ng walking, zumba', (value) => setState(() => _lightlyActive = value), _lightlyActive),
              _buildYesNoCheckbox('Moderately Active - mahigit isang oras na ehersisyo katulad ng jogging o lakad-takbo araw-araw', (value) => setState(() => _moderatelyActive = value), _moderatelyActive),
              _buildYesNoCheckbox('Very Active - dalawang oras na ehersisyo katulad ng jogging o lakad-takbo araw-araw', (value) => setState(() => _veryActive = value), _veryActive),
              _buildYesNoCheckbox('Ikaw ba ay nadiagnosed na may acute/chronic disease?', (value) => setState(() => _chronicDisease = value), _chronicDisease),
              _buildSectionTitle('Family Health History'),
              _buildFamilyMemberRow('Nanay', _motherAge, _motherInGoodHealth, _motherHealthProblems, _motherAlive, 
                (age) => setState(() => _motherAge = age), 
                (inGoodHealth) => setState(() => _motherInGoodHealth = inGoodHealth), 
                (healthProblems) => setState(() => _motherHealthProblems = healthProblems), 
                (alive) => setState(() => _motherAlive = alive)),

              _buildFamilyMemberRow('Tatay', _fatherAge, _fatherInGoodHealth, _fatherHealthProblems, _fatherAlive, 
                (age) => setState(() => _fatherAge = age), 
                (inGoodHealth) => setState(() => _fatherInGoodHealth = inGoodHealth), 
                (healthProblems) => setState(() => _fatherHealthProblems = healthProblems), 
                (alive) => setState(() => _fatherAlive = alive)),

                            _buildSiblingsSection(),

              // Button to add new sibling
              ElevatedButton(
                onPressed: _addNewSibling,
                child: const Text('Add Sibling'),
              ),

            _buildSectionTitle('PRIVACY NOTICE'),
              _buildSectionTitle("Ako ay nagbibigay ng pahintulot sa Pamahalaan ng Lungsod ng Tayabas sa pagkoleksyon; paggamit ng ayon sa batas, at pagsisiwalat ng aking personal na impormasyon na maaaring kasama ang pangalan, address, petsa ng kapanganaka, numero ng telepono at iba pang detalye. Ang pahintulot na ito ay nagbibigay-daan sa Pamahalaan ng Lungsod ng Tayabas na sumunod sa RA 10173 o mas kilala bilang Data Privacy Act of 2012."),
              _buildCheckbox('Akoy ay sumasang-ayon sa nakasaad sa Privacy Notice. * ', (value) => setState(() => _privacyAgreement = value!), _privacyAgreement),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 236, 78, 131)),
      ),
    );
  }
   // Build family member row for fixed members (Nanay and Tatay)
  Widget _buildFamilyMemberRow(
      String memberName,
      String? age,
      bool? inGoodHealth,
      String? healthProblems,
      bool? alive,
      Function(String) onAgeChanged,
      Function(bool?) onInGoodHealthChanged,
      Function(String) onHealthProblemsChanged,
      Function(bool?) onAliveChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(memberName),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Edad'),
          onChanged: onAgeChanged,
          initialValue: age,
        ),
        _buildYesNoCheckbox('In Good Health?', onInGoodHealthChanged, inGoodHealth),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Known Health Problems'),
          onChanged: onHealthProblemsChanged,
          initialValue: healthProblems,
        ),
        _buildYesNoCheckbox('Alive?', onAliveChanged, alive),
      ],
    );
  }

  // Build dynamic sibling fields
  Widget _buildSiblingsSection() {
    return Column(
      children: [
        _buildSectionTitle('Siblings'),
        Column(
          children: _siblings.map((sibling) {
            int index = _siblings.indexOf(sibling);
            return _buildSiblingRow(index);
          }).toList(),
        ),
      ],
    );
  }

  // Build row for each sibling
  Widget _buildSiblingRow(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sibling ${index + 1}'),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Edad'),
          onChanged: (value) => setState(() => _siblings[index]['age'] = value),
          initialValue: _siblings[index]['age'],
        ),
        _buildYesNoCheckbox(
            'In Good Health?',
            (value) => setState(() => _siblings[index]['inGoodHealth'] = value),
            _siblings[index]['inGoodHealth']),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Known Health Problems'),
          onChanged: (value) => setState(() => _siblings[index]['healthProblems'] = value),
          initialValue: _siblings[index]['healthProblems'],
        ),
        _buildYesNoCheckbox(
            'Alive?', (value) => setState(() => _siblings[index]['alive'] = value), _siblings[index]['alive']),
        // Button to remove sibling
        ElevatedButton(
          onPressed: () => _removeSibling(index),
          child: const Text('Remove Sibling'),
        ),
      ],
    );
  }

  // Add new sibling
  void _addNewSibling() {
    setState(() {
      _siblings.add({
        'age': null,
        'inGoodHealth': null,
        'healthProblems': null,
        'alive': null,
      });
    });
  }

  // Remove sibling
  void _removeSibling(int index) {
    setState(() {
      _siblings.removeAt(index);
    });
  }


  Widget _buildYesNoCheckbox(String title, Function(bool?) onChanged, bool? value) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        const SizedBox(width: 20),
        Expanded(
          child: Row(
            children: [
              const Text('Yes'),
              Radio<bool>(
                value: true,
                groupValue: value,
                onChanged: onChanged,
              ),
              const Text('No'),
              Radio<bool>(
                value: false,
                groupValue: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Iba pang sakit (if any)'),
      onChanged: (value) {
        setState(() {
          _otherMedicalConditions = value;
        });
      },
    );
  }

  Widget _buildCheckbox(String title, Function(bool?) onChanged, bool value) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _privacyAgreement) {
      _formKey.currentState!.save(); // Save form fields

      // Prepare data for Firestore
      final data = {
        'takingMedications': _takingMedications,
        'decreasedAppetite': _decreasedAppetite,
        'weightLoss': _weightLoss,
        'difficultyBowel': _difficultyBowel,
        'pregnant': _pregnant,
        'breastfeeding': _breastfeeding,
        'smoking': _smoking,
        'drinkingAlcohol': _drinkingAlcohol,
        'sedentary': _sedentary,
        'lightlyActive': _lightlyActive,
        'moderatelyActive': _moderatelyActive,
        'veryActive': _veryActive,
        'chronicDisease': _chronicDisease,
        'arthritis': _arthritis,
        'diabetes': _diabetes,
        'highBloodPressure': _highBloodPressure,
        'cancer': _cancer,
        'kidneyDisease': _kidneyDisease,
        'asthma': _asthma,
        'fattyLiver': _fattyLiver,
        'tuberculosis': _tuberculosis,
        'obesity': _obesity,
        'otherMedicalConditions': _otherMedicalConditions,
        'familyHistory': {
        'mother': {
          'age': _motherAge,
          'inGoodHealth': _motherInGoodHealth,
          'healthProblems': _motherHealthProblems,
          'alive': _motherAlive,
        },
        'father': {
          'age': _fatherAge,
          'inGoodHealth': _fatherInGoodHealth,
          'healthProblems': _fatherHealthProblems,
          'alive': _fatherAlive,
        },
        'siblings': _siblings, // Add dynamic siblings
      },
    };

      try {
        // Create or update the document in Firestore
        if (_documentId != null) {
          // Update existing document
          await FirebaseFirestore.instance
              .collection('health_assessments')
              .doc(_documentId)
              .update(data);
        } else {
          // Create a new document
          await FirebaseFirestore.instance
              .collection('health_assessments')
              .add(data);
        }

        // Show success dialog
        _showSuccessDialog();
      } catch (error) {
        print('Failed to submit the form: $error');
      }
    } else {
      // Handle validation errors
      print('Form is not valid or privacy agreement not checked.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submitted!'),
          content: const Text('MARAMING SALAMAT SA PAGBIBIGAY NG IYONG MGA IMPORMASYON PARA SA DIETARY ASSESSMENT.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _clearFormData(); // Clear form data after closing the dialog
              
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  void _clearFormData() {
  setState(() {
    // Reset all the form fields
    _takingMedications = null;
    _decreasedAppetite = null;
    _weightLoss = null;
    _difficultyBowel = null;
    _pregnant = null;
    _breastfeeding = null;
    _smoking = null;
    _drinkingAlcohol = null;
    _sedentary = null;
    _lightlyActive = null;
    _moderatelyActive = null;
    _veryActive = null;
    _chronicDisease = null;
    _arthritis = null;
    _diabetes = null;
    _highBloodPressure = null;
    _cancer = null;
    _kidneyDisease = null;
    _asthma = null;
    _fattyLiver = null;
    _tuberculosis = null;
    _obesity = null;
    _otherMedicalConditions = null;
    _motherAge = null;
    _motherInGoodHealth = null;
    _motherHealthProblems = null;
    _motherAlive = null;

    _fatherAge = null;
    _fatherInGoodHealth = null;
    _fatherHealthProblems = null;
    _fatherAlive = null;

    // Clear sibling data
    _siblings.clear();
    _privacyAgreement = false; // Reset the privacy agreement checkbox
    _formKey.currentState?.reset(); // Reset the form itself
  });
}
}