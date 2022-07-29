import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/screens/auth/complete_company_registration.dart';
import 'package:task_mgmt/screens/auth/login_screen.dart';
import 'package:task_mgmt/utils/ui_helper.dart';

import '../../../main.dart';
import '../../models/company_model.dart';
import '../../models/user_model.dart';

class RegisterCompany extends StatefulWidget {
  const RegisterCompany({Key? key}) : super(key: key);

  @override
  State<RegisterCompany> createState() => _RegisterCompanyState();
}

class _RegisterCompanyState extends State<RegisterCompany> {

  TextEditingController companyNameController = TextEditingController();
  TextEditingController noOfLevelsController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the data and try again");
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
    String companyId = "";

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {

      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

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
        profilepic: "",
        companyId: companyId,
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        log("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return CompleteCompanyRegistration(userModel: newUser, firebaseUser: credential!.user!);
              }
          ),
        );
      });
    }

  }

  void registerCompany() async {

    UIHelper.showLoadingDialog(context, "Registering Company");
    String companyId = uuid.v1();
    String companyName = companyNameController.text.trim();
    String email = emailController.text.trim();
    int noOfLevels = int.parse(noOfLevelsController.text.trim());


    CompanyModel company = CompanyModel(companyId: companyId,name: companyName, noOfLevels: noOfLevels, ceoEmail: email);
    await FirebaseFirestore.instance.collection("companies").doc(company.companyId).set(company.toMap());

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

                    Text("Register a Company", style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 45,
                        fontWeight: FontWeight.bold
                    ),),

                    Text("You should be a company admin to register a company",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 40,),

                    TextFormField(
                      controller: companyNameController,
                      decoration: const InputDecoration(
                          labelText: "Company Name"
                      ),
                    ),

                    const SizedBox(height: 10,),

                    TextFormField(
                      controller: noOfLevelsController,
                      decoration: const InputDecoration(
                          labelText: "No of Levels"
                      ),
                    ),

                    const SizedBox(height: 10,),

                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          labelText: "Enter your email"
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


                    CupertinoButton(
                      onPressed: () {
                        registerCompany();
                        checkValues();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      child: const Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
