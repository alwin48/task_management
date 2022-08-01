import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/company_model.dart';
import 'package:task_mgmt/screens/new_emp_credentials.dart';

import '../models/user_model.dart';
import '../utils/ui_helper.dart';
import 'auth/complete_profile_screen.dart';

class AddNewEmployee extends StatefulWidget {

  final CompanyModel company;

  const AddNewEmployee({Key? key, required this.company}) : super(key: key);

  @override
  State<AddNewEmployee> createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  String level = "Select a Level";

  void checkValues() {

    if(userNameController.text == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the data and try again");
    }
    else {
      signUp("${userNameController.text.trim()}@gm.me", level);
    }
  }

  void signUp(String email, String level) async {
    UserCredential? credential;
    String? companyId = widget.company.companyId;
    int lvl = int.parse(level.toString().trim());

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: "112233");

    } on FirebaseAuthException catch(ex) {

      Navigator.pop(context);
      UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: fullNameController.text.trim(),
        profilepic: "",
        companyId: companyId,
        level: lvl,
        isAdmin: false,
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        log("New User Created!");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) {
                return NewEmployeeCreds(userModel: newUser, firebaseUser: credential!.user!);
              }
          ),
        );
      });
    }

  }

  Future<List<String>> getLevels() async {
    late int lev=-1;
    List<String> levels = ["Select a Level"];

    //TODO: correct this function
    await FirebaseFirestore.instance
        .collection("companies")
        .where("name", isEqualTo: widget.company.name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for(var doc in querySnapshot.docs) {
        lev = doc["noOfLevels"];
        break;
      }
    }
    );

    for(int i=1;i<=lev;i++){
      levels.add(i.toString());
    }

    return levels;
  }

  Future<List<String>> getCompanyNames() async {

    List<String> companyNames = ['Select a Company'];

    await FirebaseFirestore.instance
        .collection("companies")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        companyNames.add(doc["name"]);
      }
    });
    return companyNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Full Name of Employee",
              ),
            ),

            SizedBox(height: 20,),

            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: "Enter username for email",
              ),
            ),

            const SizedBox(height: 20,),

            FutureBuilder(
              future: getLevels(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return DropdownButtonFormField(
                    value: level,
                    items: snapshot.data?.map<DropdownMenuItem<String>>((String company) {
                      return DropdownMenuItem(
                        value: company,
                        child: Text(company),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() =>level = value!
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),

            SizedBox(height: 40,),

            CupertinoButton(
              color: Colors.blue,
                child: Text("Create Employee"),
                onPressed: (){
                  checkValues();
                }
            ),
          ],
        ),
      ),
    );
  }
}
