class CompanyModel {
  String? companyId;
  String? name;
  int? noOfLevels;
  int? noOfEmployees;

  CompanyModel({required this.companyId, required this.name, required this.noOfLevels, this.noOfEmployees});

  CompanyModel.fromMap(Map<String, dynamic> map) {
    companyId = map["companyId"];
    name = map["name"];
    noOfLevels = map["noOfLevels"];
    noOfEmployees = map["noOfEmployees"];
  }

  Map<String, dynamic> toMap() {
    return {
      "companyId": companyId,
      "name": name,
      "noOfLevels": noOfLevels,
      "noOfEmployees": noOfEmployees
    };
  }

}