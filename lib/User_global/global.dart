import 'package:firebase_auth/firebase_auth.dart';
import 'package:transit_flutter_app/User_Models/direction_details_info.dart';
import 'package:transit_flutter_app/User_Models/user_data.dart';
import 'package:transit_flutter_app/User_Models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentinfo;
String userDropOffAddress = "";
DirectionDetailsInfo? tripDirectionDetailsInfo;

UserData onlineUserData = UserData();

String driverCarDetails = "";
String driverName = "";
String driverPhone = "";

double countRatingStars = 0.0;
String titleStarsRating = "";

List driversList = [];
