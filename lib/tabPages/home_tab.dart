import 'dart:async';

import 'package:drivers/Assistants/assistant_methods.dart';
import 'package:drivers/global/global.dart';
import 'package:drivers/screens/secondvilo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Assistants/black_theme_google_map.dart';
import '../pushNotification/push_notification_system.dart';
import '../screens/login_screen.dart';
import '../screens/new_trip_screen.dart';
import '../splashScreen/splash_screen.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.2691, 121.4113),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String? statusText;
  Color? buttonColor;
  bool? isDriverActive;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    print("This is our address = " + humanReadableAddress);

    AssistantMethods.readDriverRatings(context);
    getUserInfoAndCheckBlockStatus1();
    cancel();
    getUserInfoAndCheckBlockStatus();

  }

  getUserInfoAndCheckBlockStatus() async
  {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        if((snap.snapshot.value as Map)["blockStatus"] == "no")
        {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
            userPhone = (snap.snapshot.value as Map)["phone"];
          });
        }
        else
        {
          FirebaseAuth.instance.signOut();

          Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));

          Fluttertoast.showToast(msg: "You are Blocked");
        }
      }
      else
      {
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    });
  }

  void cancel() async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        double ratingsToUser = double.parse((snap.snapshot.value as Map)["ratingsCancel"] ?? "0");
        if (ratingsToUser <= 3) {
          // Update blockStatus to 'yes' if ratingsToUser is below 1
          usersRef.update({"blockStatus": "yes","cancel": "0"}).then((_) {
            setState(() {
              userName = (snap.snapshot.value as Map)["name"];
              userPhone = (snap.snapshot.value as Map)["phone"];
            });
          });
        }

      }
    });
  }

  void getUserInfoAndCheckBlockStatus1() async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        double ratingsToUser = double.parse((snap.snapshot.value as Map)["ratings"] ?? "0");
        if (ratingsToUser <= 3) {
          // Update blockStatus to 'yes' if ratingsToUser is below 1
          usersRef.update({"blockStatus": "yes"}).then((_) {
            setState(() {
              userName = (snap.snapshot.value as Map)["name"];
              userPhone = (snap.snapshot.value as Map)["phone"];
            });
          });
        }

       }
    });
  }

  block2ndViolation() async
  {
    DatabaseReference secondsvio = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await secondsvio.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        if((snap.snapshot.value as Map)["ratings"] == "no" && ["counter"] == 1 )
        {

          if (secondsvio == 1) {
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c)=> ViolationDialog()));
            // Update blockStatus to 'yes' if ratingsToUser is below 1
            secondsvio.update({"blockStatus": "yes"}).then((_) {
              setState(() {
                userName = (snap.snapshot.value as Map)["name"];
                userPhone = (snap.snapshot.value as Map)["phone"];
              });
            });
          }
        }
        else
        {

        }
      }
      else
      {
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    });
  }





  readCurrentDriverInformation() async {
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance.ref()
      .child("drivers")
      .child(currentUser!.uid)
      .once()
      .then((snap)
    {
      if(snap.snapshot.value != null){
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.address = (snap.snapshot.value as Map)["address"];
        onlineDriverData.ratings = (snap.snapshot.value as Map)["ratings"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_type = (snap.snapshot.value as Map)["car_details"]["type"];

        driverVehicleType = (snap.snapshot.value as Map)["car_details"]["type"];
      }
    });

    AssistantMethods.readDriverEarnings(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserInfoAndCheckBlockStatus1();
    cancel();
    //block2ndViolation();
    getUserInfoAndCheckBlockStatus();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();

    statusText = userModelCurrentInfo?.status;

    if(statusText == "online") {
      buttonColor = Colors.transparent;
      isDriverActive = true;
    }
    else {
      buttonColor = Colors.grey;
      isDriverActive = false;
    }

    print("Status Text: ${userModelCurrentInfo?.status}");

    AssistantMethods.readOnTripInformation();
    Timer(Duration(seconds: 5), () async {
      print("Driver: ${userModelCurrentInfo}");
      print("RID: ${userModelCurrentInfo!.rid}");
      if(userModelCurrentInfo!.rid != "free"){

        Timer(Duration(seconds: 5), () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(
            userRideRequestDetails: userRideRequestInformation,
          )));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 40),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);

            newGoogleMapController = controller;

            if(darkTheme == true){
              setState(() {
                blackThemeGoogleMap(newGoogleMapController);
              });
            }

            locateDriverPosition();
          },
        ),

        //ui for online/offline driver
        statusText != "online"
            ? Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black87,
        ) : Container(),

        //button for online/offine driver
        Positioned(
          top: statusText != "online" ? MediaQuery.of(context).size.height * 0.45 : 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(isDriverActive != true) {
                        driverIsOnlineNow();
                        updateDriversLocationAtRealTime();

                        setState(() {
                          statusText = "online";
                          isDriverActive = true;
                          buttonColor = Colors.transparent;
                        });
                      }
                      else{
                        driverIsOfflineNow();
                        setState(() {
                          statusText = "offline";
                          isDriverActive = false;
                          buttonColor = Colors.grey;
                        });
                        Fluttertoast.showToast(msg: "You are offline now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      )
                    ),
                    child: statusText != "online" ?
                      Text(statusText ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ) : const Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),

                  // SizedBox(width: 10,),
                  //
                  // ElevatedButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       primary: buttonColor,
                  //       padding: EdgeInsets.symmetric(horizontal: 18),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(26),
                  //       )
                  //   ),
                  //   child: Text(
                  //     "\$ ${userModelCurrentInfo?.balance}",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   )
                  // ),
                ],
              )
            ],
          ),
        )

      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude).then((_) {
      print("Driver location saved successfully.");
    }).catchError((error) {
      print("Error saving driver location: $error");
    });

    // //CarType
    // DatabaseReference carTypeRef = FirebaseDatabase.instance.ref().child("activeDrivers").child(currentUser!.uid).child("type");
    // carTypeRef.set(carModelCurrentInfo!.type).then((_) {
    //   print("Car type data saved successfully.");
    // }).catchError((error) {
    //   print("Error saving car type data: $error");
    // });

    //NewRideStatus
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) { });

    //Status
    FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("status").set("online");
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
      if(isDriverActive == true){
        Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

    FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("status").set("offline");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    // });
  }

}


















