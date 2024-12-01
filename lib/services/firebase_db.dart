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
Future<Map<String, List<Map<String, dynamic>>>>
    fetchDataFromMultipleCollections() async {
  var collectionNames = [
    'registrations',
    'health_assessments',
    'users',
  ];

  Map<String, List<Map<String, dynamic>>> allData = {};

  for (var collectionName in collectionNames) {
    var documents = await fetchDocumentsFromCollection(collectionName);
    allData[collectionName] = documents;
  }

  return allData;
}

Future<Map<String, dynamic>?> fetchUserDetails(String uid) async {
  if (uid.isEmpty) {
    print("Error: UID is empty");
    return null; // Return null if UID is empty
  }

  try {
    // Attempt to fetch the user's details from the 'users' collection
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      // Return the user details if the document exists
      return userDoc.data() as Map<String, dynamic>?;
    } else {
      print("Error: User document does not exist for UID: $uid");
      return null;
    }
  } catch (e) {
    print("Error fetching user details: $e");
    return null; // Handle any other errors gracefully
  }
}
