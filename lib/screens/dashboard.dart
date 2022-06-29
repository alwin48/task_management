import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mgmt/screens/tasks_screen.dart';

import '../models/user_model.dart';
import 'chat_screen.dart';

class Dashboard extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Dashboard({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(userModel: widget.userModel, firebaseUser: widget.firebaseUser),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyStatefulWidget({super.key, required this.userModel, required this.firebaseUser});


  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      TasksScreen(),
      Center(
        child: Text(
          'Settings',
          style: optionStyle,
        ),
      ),
      ChatScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
