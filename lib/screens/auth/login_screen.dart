import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/screens/dashboard.dart';
import 'package:task_mgmt/screens/auth/register_company_screen.dart';
import 'package:task_mgmt/screens/auth/signup_screen.dart';

import '../../models/user_model.dart';
import '../../utils/ui_helper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging In..");

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      // Close the loading dialog
      Navigator.pop(context);

      // Show Alert Dialog
      UIHelper.showAlertDialog(context, "An error occurred", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // Go to HomePage
      log("Log In Successful!");
      if(!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return Dashboard(userModel: userModel, firebaseUser: credential!.user!);
            }
        ),
      );
    }
  }

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

                  const SizedBox(height: 20,),

                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text("Log In"),
                  ),

                  TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return const RegisterCompany();
                              }
                          ),
                        );
                      },
                      child: const Text("Register a Company")
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

          const Text("Don't have an account?", style: TextStyle(
              fontSize: 16
          ),),

          CupertinoButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return const SignUpPage();
                    }
                ),
              );
            },
            child: const Text("Sign Up", style: TextStyle(
                fontSize: 16
            ),),
          ),

        ],
      ),
    );
  }
}