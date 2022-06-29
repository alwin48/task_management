import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_mgmt/screens/auth/login_screen.dart';
import 'package:task_mgmt/utils/ui_helper.dart';

import '../../../main.dart';
import '../../models/company_model.dart';

class RegisterCompany extends StatefulWidget {
  const RegisterCompany({Key? key}) : super(key: key);

  @override
  State<RegisterCompany> createState() => _RegisterCompanyState();
}

class _RegisterCompanyState extends State<RegisterCompany> {

  TextEditingController companyNameController = TextEditingController();
  TextEditingController noOfLevelsController = TextEditingController();
  TextEditingController noOfEmployeesController = TextEditingController();

  void registerCompany() async {

    UIHelper.showLoadingDialog(context, "Registering Company");
    String companyId = uuid.v1();
    String companyName = companyNameController.text.trim();
    int noOfLevels = int.parse(noOfLevelsController.text.trim());
    int noOfEmployees = int.parse(noOfEmployeesController.text.trim());


    CompanyModel company = CompanyModel(companyId: companyId,name: companyName, noOfLevels: noOfLevels, noOfEmployees: noOfEmployees);
    await FirebaseFirestore.instance.collection("companies").doc(company.companyId).set(company.toMap());

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) {
            return LoginPage();
          }
      ),
    );


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

                    const SizedBox(height: 10,),

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
                      controller: noOfEmployeesController,
                      decoration: const InputDecoration(
                          labelText: "No of Employees"
                      ),
                    ),

                    const SizedBox(height: 20,),

                    CupertinoButton(
                      onPressed: () {
                        registerCompany();
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
