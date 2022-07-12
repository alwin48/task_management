
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
    dateCreated = map["dateCreated"].toDate();
    dueDate = map["dueDate"].toDate();
    manager = map["manager"];
    List<dynamic> temp = map["participantsUid"];
    participantsUid = temp.map((e)=>e.toString()).toList();
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