import 'package:flutter/material.dart';
import 'package:task_mgmt/models/task_model.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/utils/firebase_helper.dart';

class TaskDetail extends StatefulWidget {

  final TaskModel task;
  const TaskDetail({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title!),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.task.title!),
          Text(widget.task.description!),
          Text(widget.task.dueDate.toString()),
          Text(widget.task.dateCreated.toString()),
          Text("Participants"),
          Flexible(
            child: ListView.builder(
              itemCount: widget.task.participantsUid?.length,
              itemBuilder: (context, index){
                return FutureBuilder(
                    future: FirebaseHelper.getUserModelById(widget.task.participantsUid![index]),
                    builder: (context, user) {
                      if(user.hasData) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                user.data!.profilepic!),
                          ),
                          title: Text(user.data!.fullname!),
                          onTap: () {},
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
  }
}
