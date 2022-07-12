import 'package:flutter/material.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/screens/create_task_screen.dart';

import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  final UserModel userModel;

  const TasksScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
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
            Icons.ice_skating
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),

          TaskCard(),

        ],
      ),
    );
  }
}
