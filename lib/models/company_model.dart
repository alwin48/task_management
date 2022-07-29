class CompanyModel {
  String? companyId;
  String? name;
  String? ceoEmail;
  int? noOfLevels;
  int? noOfEmployees;

  CompanyModel({required this.companyId, required this.name, required this.noOfLevels,this.ceoEmail, this.noOfEmployees});

  CompanyModel.fromMap(Map<String, dynamic> map) {
    companyId = map["companyId"];
    name = map["name"];
    noOfLevels = map["noOfLevels"];
    noOfEmployees = map["noOfEmployees"];
    ceoEmail = map["ceoEmail"];
  }

  Map<String, dynamic> toMap() {
    return {
      "companyId": companyId,
      "ceoEmail": ceoEmail,
      "name": name,
      "noOfLevels": noOfLevels,
      "noOfEmployees": noOfEmployees
    };
  }

}