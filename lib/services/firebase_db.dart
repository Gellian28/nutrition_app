import 'package:cloud_firestore/cloud_firestore.dart';

// Function to fetch all collections' documents without displaying them
Future<List<Map<String, dynamic>>> fetchDocumentsFromCollection(
    String collectionName) async {
  try {
    // Fetch all documents in the collection
    var collection =
        await FirebaseFirestore.instance.collection(collectionName).get();

    // Check if there are any documents
    if (collection.docs.isEmpty) {
      return [];
    }

    // Return the documents' data
    return collection.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching documents from $collectionName: $e');
    return [];
  }
}

// Function to fetch data from multiple collections

Future<Map<String, dynamic>?> fetchUserDetails(String uid) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('registrations')
        .doc(uid)
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      print('Error: User document does not exist for UID: $uid');
      return null;
    }
  } catch (e) {
    print('Error fetching user details: $e');
    return null;
  }
}

// Fetch BMI details
Future<Map<String, dynamic>?> fetchBmiDetails(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('users_bmi').doc(uid).get();
    if (snapshot.exists) {
      return snapshot.data();
    } else {
      print('Error: User document does not exist for UID: $uid');
      return null;
    }
  } catch (e) {
    print('Error fetching user details: $e');
    return null;
  }
}

// Fetch health history details
Future<Map<String, dynamic>?> fetchHealthHistory(String uid) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('health_assessments')
        .doc(uid)
        .get();

    return snapshot.exists ? snapshot.data() : null;
  } catch (e) {
    print('Error fetching health history: $e');
    return null;
  }
}

// Fetch meal plan details
Future<Map<String, dynamic>?> fetchMealPlan(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('mealPlans').doc(uid).get();

    return snapshot.exists ? snapshot.data() : null;
  } catch (e) {
    print('Error fetching meal plan: $e');
    return null;
  }
}
