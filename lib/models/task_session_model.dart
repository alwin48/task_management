class TaskSessionModel {
  String? uid;
  DateTime? startTime;
  DateTime? endTime;
  String? notes;
  String? taskUid;
  String? userUid;

  TaskSessionModel({required this.uid, this.startTime, this.endTime, this.notes, this.taskUid, this.userUid});

  TaskSessionModel.fromMap(Map<String, dynamic> map) {
    userUid = map["userUid"];
    uid = map["uid"];
    startTime = map["startTime"].toDate();
    endTime = map["endTime"].toDate();
    notes = map["notes"];
    taskUid = map["taskUid"];
  }


  Map<String, dynamic> toMap() {
    return {
      "uid" : uid,
      "startTime" : startTime,
      "endTime" : endTime,
      "notes" : notes,
      "taskUid" : taskUid,
      "userUid" : userUid,
    };
  }
}