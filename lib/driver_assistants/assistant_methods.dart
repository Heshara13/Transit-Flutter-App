import 'package:transit_flutter_app/User_global/global.dart';
import 'package:transit_flutter_app/User_global/map_key.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:transit_flutter_app/driver_assistants/request_assistant.dart';
import 'package:transit_flutter_app/driver_infoHandler/app_info.dart';
import 'package:transit_flutter_app/driver_models/directions.dart';
import 'package:transit_flutter_app/driver_models/user_model.dart';

class AssistantMethods {
  static Future<void> readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      print("No user is currently logged in.");
      return;
    }

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

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

  static Future<String> searchAddressForGeographicCordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error occured. Faild. No Response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

  static Future<List<PointLatLng>?> obtainOriginToDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapkey,
        PointLatLng(originPosition.latitude, originPosition.longitude),
        PointLatLng(
            destinationPosition.latitude, destinationPosition.longitude));
    return result.points;
  }

  static pauseLiveLocationUpdate() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }

}
