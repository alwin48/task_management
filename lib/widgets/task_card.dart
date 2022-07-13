import 'package:flutter/material.dart';
import 'package:task_mgmt/main.dart';
import 'package:task_mgmt/models/task_model.dart';
import 'package:task_mgmt/models/task_session_model.dart';
import 'package:task_mgmt/screens/task/task_detail.dart';

import '../screens/task/end_task_session.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  String startButtonText = "Start";
  TaskSessionModel taskSession = TaskSessionModel(uid: uuid.v1());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return TaskDetail(task: widget.task);
                }
            )
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.task),
              title: Text(widget.task.title!),
              subtitle: Text(
                'Due Date: ${widget.task.dueDate?.day}/${widget.task.dueDate
                    ?.month}/${widget.task.dueDate?.year}',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.task.description!,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  // color: const Color(0xFF6200EE),
                  onPressed: () {
                    taskSession.startTime = DateTime.now();
                    taskSession.taskUid = widget.task.uid;
                    setState(() {
                      startButtonText = "Started session";
                    });
                  },
                  child: Text(startButtonText),
                ),
                TextButton(
                    onPressed: () async {
                      taskSession.endTime = DateTime.now();
                      setState((){
                        startButtonText = "Start";
                      });
                      await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return EndTaskSession(taskSession: taskSession);
                      })
                      );
                    },
                    child: const Text("End")),
                TextButton(
                  // textColor: const Color(0xFF6200EE),
                  onPressed: () {
                    // Perform some action
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
