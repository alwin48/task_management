import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/models/user_model.dart';
import 'package:share_plus/share_plus.dart';

import 'auth/login_screen.dart';

class NewEmployeeCreds extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const NewEmployeeCreds({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<NewEmployeeCreds> createState() => _NewEmployeeCredsState();
}

class _NewEmployeeCredsState extends State<NewEmployeeCreds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if(!mounted) return;
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    }
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 20),

              Text("Email: ${widget.userModel.email!}"),

              SizedBox(height: 20,),

              Text("Password: 112233"),

              SizedBox(height: 20,),

              CupertinoButton(
                color: Colors.blue,
                child: Text("Share details"),
                onPressed: () {
                  Share.share('Email: ${widget.userModel.email!},\nPassword: 112233');
                }
              ),




            ],
          ),
        ),
      ),
    );
  }
}
