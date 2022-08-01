import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_mgmt/screens/performance.dart';
import 'package:task_mgmt/screens/task/tasks_screen.dart';

import '../models/company_model.dart';
import '../models/user_model.dart';
import 'add_new_employee.dart';
import 'chat/chat_screen.dart';

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
    final List<Widget> widgetOptions = <Widget>[
      TasksScreen(userModel: widget.userModel),
      SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleBarChart.withRandomData(),
          ),
        ),
      ),
      ChatScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Performance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
