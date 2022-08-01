import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/screens/task/create_task_screen.dart';

import '../../models/company_model.dart';
import '../../models/task_model.dart';
import '../../widgets/task_card.dart';
import '../add_new_employee.dart';
import '../auth/login_screen.dart';

class TasksScreen extends StatefulWidget {
  final UserModel userModel;

  const TasksScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  late CompanyModel company;

  setCompany() async {
    DocumentSnapshot companydoc = await FirebaseFirestore.instance.collection("companies").doc(widget.userModel.companyId).get();
    company = CompanyModel.fromMap(companydoc.data() as Map<String, dynamic>);
  }

  @override
  void initState() {
    setCompany();
    super.initState();
  }

  getDrawer() {
    if(widget.userModel.isAdmin!=null){
      if(widget.userModel.isAdmin!) {
        return Drawer(
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
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Add New Employee"),
                onTap: () {

                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddNewEmployee(company: company);
                  }));
                },
              ),
            ],
          ),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(),
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if(!mounted) return;
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    }
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return CreateTask(restorationId: 'main', userModel: widget.userModel);
                  }
              )
          );
        },
        backgroundColor: Colors.lightBlue,
        child: const Icon(
            Icons.add_task
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),

          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      TaskModel task = TaskModel.fromMap(snapshot.data!.docs[index].data());
                      return Center(child: TaskCard(task: task));
                    },
                  );
                }
                else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          )



        ],
      ),
    );
  }
}
