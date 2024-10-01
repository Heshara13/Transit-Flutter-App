  import 'package:demo03/User_Models/user_model.dart';
import 'package:demo03/User_global/global.dart';
import 'package:firebase_database/firebase_database.dart';

class AssistantMethods {
    static Future<void> readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      print("No user is currently logged in.");
      return;
    }

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid);

    try {
      DatabaseEvent event = await userRef.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        userModelCurrentinfo = UserModel.fromSnapshot(snapshot);
        print("User info loaded: ${userModelCurrentinfo.toString()}");
      } else {
        print("User data not found in database for UID: ${currentUser!.uid}");
      }
    } catch (error) {
      print("Failed to load user info: $error");
    }
  }
  }
  