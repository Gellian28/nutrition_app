import 'package:enutrition_app/pages/landingpage.dart';
import 'package:enutrition_app/services/firebase_db.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import all necessary pages
import 'package:enutrition_app/pages/forgotpinpage.dart';
import 'package:enutrition_app/pages/resetpinpage.dart';
import 'package:enutrition_app/pages/loginpage.dart';
import 'package:enutrition_app/pages/registrationpage.dart';
import 'package:enutrition_app/pages/pincreationpage.dart';
// import 'package:enutrition_app/pages/dashboardpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Nutrition',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => _determineInitialPage(),
            );
          case '/registration':
            return MaterialPageRoute(
              builder: (context) => const RegistrationPage(),
            );
          case '/forgotpin':
            return MaterialPageRoute(
              builder: (context) => const ForgotPinPage(),
            );
          case '/resetpin':
            final email = settings.arguments as String? ?? '';
            return MaterialPageRoute(
              builder: (context) => ResetPinPage(email: email),
            );
          case '/pinCreationPage':
            final args = settings.arguments as Map<String, String>?;
            if (args == null) {
              return MaterialPageRoute(
                builder: (context) => const LoginPage(),
              );
            }
            return MaterialPageRoute(
              builder: (context) => PinCreationPage(
                firstname: args['firstname'] ?? '',
                lastname: args['lastname'] ?? '',
                birthday: args['birthday'] ?? '',
                gender: args['gender'] ?? '',
                email: args['email'] ?? '',
                phone: args['phone'] ?? '',
                barangay: args['barangay'] ?? '',
                city: args['city'] ?? '',
                province: args['province'] ?? '',
                postalCode: args['postalCode'] ?? '',
                uid: args['uid'] ?? '',
              ),
            );
          case '/dashboard':
            final args = settings.arguments as Map<String, String>?;
            final uid = args?['uid'] ?? '';
            if (uid.isEmpty) {
              return MaterialPageRoute(
                builder: (context) => const LoginPage(),
              );
            }
            return MaterialPageRoute(
              builder: (context) => DashboardPage(
                uid: uid,
                email: args?['email'] ?? '',
                userDetails: {},
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
        }
      },
      initialRoute: '/',
    );
  }

  Widget _determineInitialPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (authSnapshot.hasData && authSnapshot.data != null) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: fetchUserDetails(authSnapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasData && userSnapshot.data != null) {
                return DashboardPage(
                  uid: authSnapshot.data!.uid,
                  email: authSnapshot.data!.email ?? '',
                  userDetails: userSnapshot.data!,
                );
              }

              // User exists in Firebase Auth but not in Firestore
              return const LoginPage();
            },
          );
        }

        // No authenticated user
        return const LoginPage();
      },
    );
  }
}

Widget _determineInitialPage() {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, authSnapshot) {
      if (authSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (authSnapshot.hasData && authSnapshot.data != null) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserDetails(authSnapshot.data!.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userSnapshot.hasData && userSnapshot.data != null) {
              return DashboardPage(
                uid: authSnapshot.data!.uid,
                email: authSnapshot.data!.email ?? '',
                userDetails: userSnapshot.data!,
              );
            }

            // User exists in Firebase Auth but not in Firestore
            return const LoginPage();
          },
        );
      }

      // No authenticated user
      return const LoginPage();
    },
  );
}
