class TaskModel {
  String uid;
  String? title;
  String? description;
  DateTime? dateCreated;
  //TODO : Add users and manager
  DateTime? dueDate;
  //TODO: maybe add an image

  TaskModel({required this.uid,this.title,this.dateCreated,this.description,this.dueDate});

}