import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String? department;
  String name = '';
  String phone = '';
  int? age;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                      hintText: 'Enter your phone number',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        age = int.parse(value);
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                      hintText: '',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: department,
              items: [
                DropdownMenuItem(
                  child: Text('HR'),
                  value: 'HR',
                ),
                DropdownMenuItem(
                  child: Text('Finance'),
                  value: 'Finance',
                ),
                DropdownMenuItem(
                  child: Text('Housekeeping'),
                  value: 'Housekeeping',
                ),
                DropdownMenuItem(
                  child: Text('Marketing'),
                  value: 'Marketing',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  department = value as String?;
                });
              },
              hint: Text('Select Department'),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  users
                      .add({
                        'name': name,
                        'phone': phone,
                        'age': age,
                        'department': department,
                        'pfpUrl':
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                      })
                      .then((value) => print("User Added"))
                      .catchError(
                          (error) => print("Failed to add user: $error"));
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data!.size,
                    itemBuilder: (_, i) {
                      QueryDocumentSnapshot fetchedUser = snap.data!.docs[i];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailsScreen(
                                        name: fetchedUser['name'],
                                        phone: fetchedUser['phone'],
                                        age: fetchedUser['age'].toString(),
                                        department: fetchedUser['department'],
                                        pfpUrl: fetchedUser['pfpUrl'],
                                      )));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(fetchedUser['pfpUrl'] ??
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                        ),
                        title: Text(fetchedUser['name'] ?? 'Vaibhav'),
                        subtitle: Text(fetchedUser['department'] ?? 'hr'),
                        trailing: Text('${fetchedUser['age']}'),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen(
      {required this.age,
      required this.department,
      required this.name,
      required this.pfpUrl,
      required this.phone,
      super.key});
  final String? department;
  final String? name;
  final String? age;
  final String? pfpUrl;
  final String? phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(pfpUrl ??
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              name ?? 'Vaibhav',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text('Age: $age'),
            SizedBox(height: 5),
            Text('Phone number: $phone'),
            SizedBox(height: 5),
            Text('Department: $department'),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
