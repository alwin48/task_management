import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewEmployee extends StatefulWidget {
  const AddNewEmployee({Key? key}) : super(key: key);

  @override
  State<AddNewEmployee> createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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

          SizedBox(height: 20,),

          TextField(
            controller: fullNameController,
            decoration: const InputDecoration(
              labelText: "Enter Level of Employee",
            ),
          ),

          SizedBox(height: 40,),

          CupertinoButton(
            color: Colors.blue,
              child: Text("Create Employee"),
              onPressed: (){}
          ),
        ],
      ),
    );
  }
}
