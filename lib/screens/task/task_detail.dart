import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/task_model.dart';
import 'package:task_mgmt/models/task_session_model.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/utils/firebase_helper.dart';

class TaskDetail extends StatefulWidget {

  final TaskModel task;
  const TaskDetail({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  late Widget task_details;
  late Widget participants = Padding(
    padding: EdgeInsets.all(8.0),
    child: Column(
      children: [
        SizedBox(height: 20,),
        Text(
          "Participants",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,

          ),
        ),

        Flexible(
          child: ListView.builder(
              itemCount: widget.task.participantsUid?.length,
              itemBuilder: (context, index){
                return FutureBuilder(
                    future: FirebaseHelper.getUserModelById(widget.task.participantsUid![index]),
                    builder: (context, user) {
                      if(user.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  user.data!.profilepic!),
                            ),
                            title: Text(user.data!.fullname!),
                            onTap: () {},
                          ),
                        );
                      }
                      else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                );
              }
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task Details"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.task)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.assessment_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  SizedBox(height: 10,),

                  Text(
                    widget.task.title!,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text(
                    widget.task.description!,

                  ),

                  SizedBox(height: 10,),

                  Text(
                    "Due date: ${widget.task.dueDate!.day}/${widget.task.dueDate!.month}/${widget.task.dueDate!.year}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text(
                    "Date created: ${widget.task.dateCreated!.day}/${widget.task.dateCreated!.month}/${widget.task.dateCreated!.year}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]
                    ),
                  ),

                  SizedBox(height: 20,),

                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: (){

                        },
                        child: Text("Start Session")
                      ),
                      ElevatedButton(onPressed: (){}, child: Text("End Session")),
                      ElevatedButton(onPressed: (){}, child: Text("Edit Task"))
                    ],
                  )

                ],
              ),
            ),
            participants,
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text("Task Sessions"),
                  Flexible(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("tasks").doc(widget.task.uid).collection("session").snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              TaskSessionModel taskSession = TaskSessionModel.fromMap(snapshot.data!.docs[index].data());
                              log(taskSession.notes!);
                              // return ListTile(
                              //   leading: Text(taskSession.startTime.toString()),
                              //   trailing: Text(taskSession.endTime.toString()),
                              //   subtitle: Text(taskSession.notes!),
                              // );
                              return Center(
                                child: Text(taskSession.notes!),
                              );
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
            ),
          ],
        ),
      ),
    );
  }
}


