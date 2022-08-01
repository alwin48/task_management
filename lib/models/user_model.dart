class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  int? level;
  String? companyId;
  bool? isAdmin = false;

  UserModel({this.uid, this.fullname, this.email, this.profilepic, this.level, this.companyId, this.isAdmin});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
    companyId = map["companyId"];
    level = map["level"];
    isAdmin = map["isAdmin"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "level": level,
      "companyId": companyId,
      "isAdmin": isAdmin,
    };
  }
}