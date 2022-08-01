
class TaskModel {
  String? uid;
  String? title;
  String? description;
  DateTime? dateCreated;
  List<String>? participantsUid;
  String? manager;
  int? managerLevel;
  DateTime? dueDate;
  //TODO: maybe add an image

  TaskModel({required this.uid,this.title,this.dateCreated,this.description,this.dueDate, required this.manager, required this.participantsUid, required this.managerLevel});

  TaskModel.fromMap(Map<String, dynamic> map){
    uid = map["uid"];
    title = map["title"];
    managerLevel = map["managerLevel"];
    description = map["description"];
    dateCreated = map["dateCreated"].toDate();
    dueDate = map["dueDate"].toDate();
    manager = map["manager"];
    List<dynamic> temp = map["participantsUid"];
    participantsUid = temp.map((e)=>e.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "managerLevel": managerLevel,
      "title": title,
      "description": description,
      "dateCreated": dateCreated,
      "dueDate": dueDate,
      "manager": manager,
      "participantsUid": participantsUid,
    };
  }

}