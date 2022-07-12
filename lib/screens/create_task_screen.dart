import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/main.dart';
import 'package:task_mgmt/models/task_model.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:task_mgmt/screens/add_participants.dart';
import 'package:task_mgmt/utils/firebase_helper.dart';

class CreateTask extends StatefulWidget {

  final String? restorationId;
  final UserModel userModel;

  const CreateTask({Key? key, required this.userModel, required this.restorationId}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> with RestorationMixin {


  String dateButtonText = 'Select a due date';
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();



  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  late List<String> participants;
  
  int userLength = 0;

  @override
  void initState() {
    getlength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
      ),
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 20,),

                  TextFormField(
                    controller: taskNameController,
                    decoration: const InputDecoration(
                        labelText: "Task Name"
                    ),
                  ),

                  const SizedBox(height: 10,),

                  TextFormField(
                    controller: taskDescriptionController,
                    decoration: const InputDecoration(
                        labelText: "Task Description"
                    ),
                  ),

                  const SizedBox(height: 20,),

                  OutlinedButton(
                    onPressed: () {

                      if(_selectedDate.value.day!=DateTime.now().day) {
                        setState(() {
                          dateButtonText = 'Due Date: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
                        });
                      }
                      _restorableDatePickerRouteFuture.present();
                    },
                    child: Text(dateButtonText),
                  ),

                  OutlinedButton(
                      onPressed: () async {
                        log(userLength.toString());
                        participants = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return AddParticipants(userLength: userLength);
                            }
                            )
                        ) as List<String>;
                      },
                      child: const Text("Add participants")),

                  const SizedBox(height: 20,),

                  CupertinoButton(
                      color: Colors.blue,
                      child: const Text("Create Task"),
                      onPressed: () {
                        TaskModel task = TaskModel(
                            participantsUid: participants,
                            uid: uuid.v1(),
                            title: taskNameController.text.trim(),
                            description: taskDescriptionController.text.trim(),
                            dateCreated: DateTime.now(),
                            manager: widget.userModel.uid,
                            dueDate: _selectedDate.value
                        );

                        FirebaseFirestore.instance.collection("tasks").doc(task.uid).set(task.toMap());
                        Navigator.pop(context);

                      }
                  ),


                  
                ],
              ),
            ),
          )
      ),
    );
  }

  void getlength() async {
    userLength = await FirebaseHelper.getUsersLength();
  }
}
