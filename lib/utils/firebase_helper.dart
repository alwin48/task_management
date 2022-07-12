import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseHelper {

  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }

  static Future<int> getUsersLength() async {
    int length = 0;
    await FirebaseFirestore.instance.collection("users").get().then((QuerySnapshot querySnapshot) {
      for (var _ in querySnapshot.docs) {
        length++;
      }
    });
    return length;
  }

}