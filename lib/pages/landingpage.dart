import 'package:enutrition_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'add_service_page.dart';
import 'profile_page.dart';
import 'notifications_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  final String uid;
  final String email;

  const DashboardPage(
      {super.key,
      required this.uid,
      required this.email,
      required Map<String, dynamic> userDetails});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const HomePage(),
      ProfilePage(
        uid: widget.uid, // Provide a default empty string if null
      ),
      AddServicePage(uid: widget.uid), // Add null check
      const NotificationsPage(),
      SettingsPage(uid: widget.uid),
    ];
  }

  void _onItemTapped(int index) {
    print("Tapped index: $index");
    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      print("Index out of bounds");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Nutrition', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 128, 168),
        elevation: 0,
      ),
      body: IndexedStack(
        // This will use the _selectedIndex to display the appropriate page.
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
