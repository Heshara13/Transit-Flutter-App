import 'package:firebase_auth/firebase_auth.dart';
import 'package:transit_flutter_app/User_Models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentinfo;