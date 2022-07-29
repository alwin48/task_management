import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/screens/add_new_employee.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key, required UserModel userModel, required User firebaseUser}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  Widget body = Text("My Page");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Page")),
      body: Center(
        child: body,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Admin Options'),
            ),
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                body = Text("item 1 clicked");
                setState(() {

                });
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Add New Employee"),
              onTap: () {
                body = AddNewEmployee();
                setState(() {

                });
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}