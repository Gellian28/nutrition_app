import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BMICalculatorWidget extends StatefulWidget {
  final String uid;
  final String email;

  const BMICalculatorWidget(
      {super.key, required this.uid, required this.email});

  @override
  _BMICalculatorWidgetState createState() => _BMICalculatorWidgetState();
}

class _BMICalculatorWidgetState extends State<BMICalculatorWidget> {
  // Form and Firestore setup
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for input fields
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  // BMI calculation variables
  double? _bmi;
  String _bmiCategory = "";

  // State variables
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set current date by default
    dateController.text = _getCurrentDate();

    // Fetch user details
    _fetchUserDetails();
  }

  // Get current date in yyyy-MM-dd format
  String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Fetch user details from registrations collection
  Future<void> _fetchUserDetails() async {
    try {
      var userDoc =
          await _firestore.collection('registrations').doc(widget.uid).get();

      if (userDoc.exists) {
        setState(() {
          genderController.text = userDoc.data()?['gender'] ?? '';
          ageController.text = userDoc.data()?['age']?.toString() ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  // Date picker method
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Calculate BMI and save data
  void calculateBMI() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse input values
      double height =
          double.parse(heightController.text) / 100; // Convert to meters
      double weight = double.parse(weightController.text);
      int age = int.parse(ageController.text);

      // Calculate BMI
      double bmi = weight / (height * height);

      // Update state with BMI results
      setState(() {
        _bmi = double.parse(bmi.toStringAsFixed(2));
        _bmiCategory = _getBMICategory(_bmi!);
      });

      // Save BMI data to Firestore
      await _saveBMIData(height * 100, weight, age);
    } catch (e) {
      // Show error if calculation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calculating BMI: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Determine BMI category
  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal Weight";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  // Save BMI data to Firestore
  Future<void> _saveBMIData(double height, double weight, int age) async {
    try {
      // Reference to BMI Categories
      DocumentReference? bmiCategoryRef = await _findBMICategoryReference();

      // Save BMI entry
      DocumentReference bmiEntryRef =
          await _firestore.collection('users_bmi').add({
        'uid': widget.uid,
        'email': widget.email,
        'height': height,
        'weight': weight,
        'bmi': _bmi,
        'bmiCategory': _bmiCategory,
        'date_of_monitoring': dateController.text,
        'age': age,
        'gender': genderController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'bmiCategoryRef': bmiCategoryRef,
      });

      // Create Health Assessment
      await _createHealthAssessment(bmiEntryRef);

      // Create Notification
      await _createNotification();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('BMI data saved successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving BMI data: $e')),
      );
    }
  }

  // Find BMI Category Reference
  // Future<DocumentReference?> _findBMICategoryReference() async {
  //   try {
  //     var bmiCategories = await _firestore
  //         .collection('bmi_categories')
  //         .where('min_value', isLessThanOrEqualTo: _bmi!)
  //         .where('max_value', isGreaterThan: _bmi!)
  //         .limit(1)
  //         .get();

  //     return bmiCategories.docs.isNotEmpty
  //         ? bmiCategories.docs.first.reference
  //         : null;
  //   } catch (e) {
  //     print('Error finding BMI category: $e');
  //     return null;
  //   }
  // }

  Future<DocumentReference?> _findBMICategoryReference() async {
    try {
      var bmiCategories = await _firestore
          .collection('bmi_categories')
          .where('min_value', isLessThanOrEqualTo: _bmi!)
          .where('max_value', isGreaterThan: _bmi!)
          .limit(1)
          .get();

      return bmiCategories.docs.isNotEmpty
          ? bmiCategories.docs.first.reference
          : null;
    } catch (e) {
      print('Error finding BMI category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error: Please ensure the BMI category index exists.')),
      );
      return null;
    }
  }

  // Create Health Assessment
  Future<void> _createHealthAssessment(DocumentReference bmiEntryRef) async {
    await _firestore.collection('health_assessments').add({
      'uid': widget.uid,
      'bmi_entry_ref': bmiEntryRef,
      'bmi': _bmi,
      'bmi_category': _bmiCategory,
      'assessment_date': dateController.text,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Create Notification
  Future<void> _createNotification() async {
    await _firestore.collection('notifications').add({
      'uid': widget.uid,
      'type': 'bmi_update',
      'message': 'Your BMI has been updated. Current category: $_bmiCategory',
      'created_at': FieldValue.serverTimestamp(),
      'is_read': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date of Monitoring
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date of Monitoring',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Age Input
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  int? age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Height Input
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  double? height = double.tryParse(value);
                  if (height == null || height <= 0 || height > 300) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Weight Input
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  double? weight = double.tryParse(value);
                  if (weight == null || weight <= 0 || weight > 600) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Calculate BMI Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: calculateBMI,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Calculate BMI',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

              // BMI Result Display
              if (_bmi != null) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'BMI: ${_bmi!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Category: $_bmiCategory',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    heightController.dispose();
    weightController.dispose();
    dateController.dispose();
    ageController.dispose();
    genderController.dispose();
    super.dispose();
  }
}
