import 'package:euser/global/global.dart';
import 'package:euser/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);

        print("name = " + userModelCurrentInfo!.name.toString());
        print("email = " + userModelCurrentInfo!.email.toString());
        print("phone = " + userModelCurrentInfo!.phone.toString());
        print("id = " + userModelCurrentInfo!.id.toString());
      }
    });
  }
}
