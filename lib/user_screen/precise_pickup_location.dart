import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'dart:core';
import 'package:geocoding/geocoding.dart'; // Updated package
import 'package:transit_flutter_app/User_Infohandler/app_info.dart';
import '../user_assistants/assistant_methods.dart';
import '../user_models/directions.dart';
import 'package:provider/provider.dart';

class PrecisePickupScreen extends StatefulWidget {
  const PrecisePickupScreen({super.key});

  @override
  State<PrecisePickupScreen> createState() => _PrecisePickupScreenState();
}

class _PrecisePickupScreenState extends State<PrecisePickupScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();

  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  double bottomPaddingOfMap = 0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  // Method to locate the user's current position
  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
  }

  // Method to get address from latitude and longitude
  Future<void> getAddressFromLatLng() async {
    if (pickLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pickLocation!.latitude,
          pickLocation!.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

          setState(() {
            Directions userPickUpAddress = Directions();
            userPickUpAddress.locationLatitude = pickLocation!.latitude;
            userPickUpAddress.locationLongitude = pickLocation!.longitude;
            userPickUpAddress.locationName = address;

            //Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
          });
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 100;
              });
              locateUserPosition();
            },
            onCameraMove: (CameraPosition position) {
              if (pickLocation != position.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Image.asset("images/pick.png", height: 45, width: 45),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                Provider.of<AppInfo>(context).userPickUpLocation != null
                    ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
                    : "Not getting Address",
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: Text("Set Location"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
