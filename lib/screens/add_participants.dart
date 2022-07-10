import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/user_model.dart';

import '../models/chatroom_model.dart';
import '../utils/firebase_helper.dart';

class AddParticipants extends StatefulWidget {
  const AddParticipants({Key? key}) : super(key: key);

  @override
  State<AddParticipants> createState() => _AddParticipantsState();
}

class _AddParticipantsState extends State<AddParticipants> {
  List<UserModel> selectedList = [];
  List<UserModel> userList = [];

  Future<List<UserModel>> getUsers() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
          for(var doc in querySnapshot.docs){
            userList.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
          }
    });
    return userList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                // return ParticipantItem(user: userList[index]);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userList[index].profilepic!),
                    backgroundColor: Colors.grey[500],
                  ),
                  title: Text(userList[index].fullname!),
                  subtitle: Text(userList[index].email!),
                  trailing: Checkbox(
                    checkColor: Colors.white,
                    value: false,
                    onChanged: (bool? value) {
                      if(value!){
                        selectedList.add(userList[index]);
                      } else {
                        selectedList.remove(userList[index]);
                      }
                    },
                  ),
                );
              }
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedList);
        },
        child: const Text("Done"),
    ),
    );
  }
}