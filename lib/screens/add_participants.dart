import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/user_model.dart';

import '../models/chatroom_model.dart';
import '../utils/firebase_helper.dart';

class AddParticipants extends StatefulWidget {

  final int userLength;
  const AddParticipants({Key? key, required this.userLength}) : super(key: key);

  @override
  State<AddParticipants> createState() => _AddParticipantsState();


}

class _AddParticipantsState extends State<AddParticipants> {
  List<String> selectedList = [];
  List<UserModel> userList = [];

  @override
  void initState() {

    loadList();


    super.initState();
  }

  loadList() async {
    await getUsers();
  }

  Future<List<UserModel>> getUsers() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
          for(var doc in querySnapshot.docs){
            userList.add(UserModel.fromMap(doc.data() as Map<String, dynamic>));
          }
    });

    log(check.toString());
    return userList;
  }

  late List<bool> check = List<bool>.generate(widget.userLength, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  UserModel user = UserModel.fromMap(snapshot.data!.docs[index].data());
                  // return ParticipantItem(user: userList[index]);

                  return ListTile(

                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          user.profilepic!),
                      backgroundColor: Colors.grey[500],
                    ),
                    title: Text(user.fullname!),
                    subtitle: Text(user.email!),
                    trailing: Checkbox(
                      checkColor: Colors.white,
                      value: check[index],
                      onChanged: (bool? value) {
                        setState(() {
                          check[index] = !check[index];
                        });
                        if (value!) {
                          if(!selectedList.contains(user.uid)){
                            selectedList.add(user.uid!);
                          }
                          log(selectedList.toString());
                        } else {
                          selectedList.remove(user.uid);
                        }
                      },
                    ),
                  );
                }
            );

          }
          else {
            return const CircularProgressIndicator();
          }
        }
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