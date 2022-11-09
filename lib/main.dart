import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internshala/screens/add_screen.dart';

import 'screens/list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: const [
                  AddScreen(),
                  ListScreen(),
                ],
              ),
            ),
            BottomNavigationBar(
              onTap: ((value) {
                _pageController.jumpToPage(value);
                setState(() {
                  _selectedIndex = value;
                });
              }),
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.add_circle_outline), label: 'Add'),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.library_books_outlined),
                    label: 'List'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
