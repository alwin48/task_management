import 'package:task_mgmt/models/user_model.dart';

class TaskModel {
  String? uid;
  String? title;
  String? description;
  DateTime? dateCreated;
  List<String>? participantsUid;
  String? manager;
  DateTime? dueDate;
  //TODO: maybe add an image

  TaskModel({required this.uid,this.title,this.dateCreated,this.description,this.dueDate, required this.manager, required this.participantsUid});

  TaskModel.fromMap(Map<String, dynamic> map){
    uid = map["uid"];
    title = map["title"];
    description = map["description"];
    dateCreated = map["dateCreated"];
    dueDate = map["dueDate"];
    manager = map["manager"];
    participantsUid = map["participantsUid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "title": title,
      "description": description,
      "dateCreated": dateCreated,
      "dueDate": dueDate,
      "manager": manager,
      "participantsUid": participantsUid,
    };
  }

}