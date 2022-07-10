import 'package:flutter/material.dart';
import 'package:task_mgmt/screens/create_task_screen.dart';

import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

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
                    return const CreateTask(restorationId: 'main');
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
        children: const [

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
