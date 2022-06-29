import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import '../../utils/ui_helper.dart';
import 'complete_profile_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else if(password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch", "The passwords you entered do not match!");
    }
    else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: email,
          fullname: "",
          profilepic: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        log("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return CompleteProfile(userModel: newUser, firebaseUser: credential!.user!);
              }
          ),
        );
      });
    }

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

  Future<List<String>> getLevels() async {
    late int lev;
    List<String> levels = ["Select a Level"];

    //TODO: correct this function
    await FirebaseFirestore.instance
        .collection("companies")
        .where("name.$dropdownvalue", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
          for(var doc in querySnapshot.docs) {
            lev = doc["noOfLevels"];
            break;
          }
        }
    );

    for(int i=0;i<lev;i++){
      levels.add(i.toString());
    }

    return levels;
  }

  String dropdownvalue = 'Select a Company';
  String level = "Select a Level";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Text("Task Management", style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 45,
                      fontWeight: FontWeight.bold
                  ),),

                  const SizedBox(height: 10,),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email Address"
                    ),
                  ),

                  const SizedBox(height: 10,),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password"
                    ),
                  ),

                  const SizedBox(height: 10,),

                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Confirm Password"
                    ),
                  ),

                  const SizedBox(height: 20,),

                  FutureBuilder(
                    future: getCompanyNames(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return DropdownButtonFormField(
                          value: dropdownvalue,
                          items: snapshot.data?.map<DropdownMenuItem<String>>((String company) {
                            return DropdownMenuItem(
                              value: company,
                              child: Text(company),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() =>dropdownvalue = value!
                            );
                          },
                        );
                      }
                      return const CircularProgressIndicator();
                    },
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

                  const SizedBox(height: 20,),

                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text("Sign Up"),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text("Already have an account?", style: TextStyle(
              fontSize: 16
          ),),

          CupertinoButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Log In", style: TextStyle(
                fontSize: 16
            ),),
          ),

        ],
      ),
    );
  }
}
