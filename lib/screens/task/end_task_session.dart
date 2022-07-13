import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/task_session_model.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/utils/firebase_helper.dart';

class EndTaskSession extends StatefulWidget {

  final TaskSessionModel taskSession;

  const EndTaskSession({Key? key, required this.taskSession}) : super(key: key);

  @override
  State<EndTaskSession> createState() => _EndTaskSessionState();
}

class _EndTaskSessionState extends State<EndTaskSession> {

  TextEditingController notesController = TextEditingController();
  late UserModel user = FirebaseHelper.getUserModelById(widget.taskSession.userUid!) as UserModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("Start Time : ${widget.taskSession.startTime.toString()}"),
              SizedBox(height: 10,),
              Text("End Time : ${widget.taskSession.endTime.toString()}"),
              SizedBox(height: 10,),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/64238983?s=48&v=4"),
                ),
                title: Text("User"),
                subtitle: Text("Alwin"),
              ),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  label: Text("Enter any notes")
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                widget.taskSession.notes = notesController.text.trim();
                await FirebaseFirestore.instance.collection("tasks").doc(widget.taskSession.taskUid).collection("session").doc(widget.taskSession.uid).set(widget.taskSession.toMap());
                Navigator.pop(context);
              }, child: Text("Done")),
            ],
          ),
        ),
      ),
    );
  }
}
