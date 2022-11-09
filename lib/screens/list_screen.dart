import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
