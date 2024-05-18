import 'dart:async';

import 'dart:ui';

import 'package:drivers/Assistants/assistant_methods.dart';
import 'package:drivers/Assistants/black_theme_google_map.dart';
import 'package:drivers/global/global.dart';
import 'package:drivers/models/user_ride_request_information.dart';
import 'package:drivers/screens/cancel_rate_driver_screen.dart';
import 'package:drivers/screens/comments%20of%20user.dart';
import 'package:drivers/screens/rate_driver_screen.dart';
import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:drivers/widgets/cancelfare_amount_collection_dialog.dart';
import 'package:drivers/widgets/commetdesing.dart';
import 'package:drivers/widgets/fare_amount_collection_dialog.dart';
import 'package:drivers/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/trip_details.dart';
import 'login_screen.dart';

class NewTripScreen extends StatefulWidget {

  UserRideRequestInformation? userRideRequestDetails;



  NewTripScreen({
    this.userRideRequestDetails,
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  _launchMaps(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.green;

  StreamSubscription<DatabaseEvent>? tripRidesRequestInfoStreamSubscription;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String userRideRequestStatus = "";

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = userModelCurrentInfo!.rid == "free" ? "accepted" : userRideRequestInformation!.status!;

  String durationFromOriginToDestination = "";

  bool isRequestDirectionDetails = false;



  //Step 1: When driver accepts the user ride request
  // originLatLng = driverCurrent location
  // destinationLatLng = user Pickup location

  //step 2: When driver picks up the user in his car
  // originLatLng = user current location which will be also the current location of the driver at that time
  // destinationLatLng = user's drop-off location


  Future<void> drawPolyLineFromOriginToDestination(LatLng originLatLng, LatLng destinationLatLng, bool darkTheme) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Dismiss the dialog
        });
        return ProgressDialog(message: "Please wait....");
      },
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.of(context).pop();
    // });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.e_points!);

    polyLinePositionCoordinates.clear();

    if(decodedPolyLinePointsResultList.isNotEmpty){
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude){
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude){
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude){
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    saveAssignedDriverDetailsToUserRideRequest();
  }

  getDriverLocationUpdatesAtRealTime() {

    LatLng oldLatLng = LatLng(0, 0);

    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: InfoWindow(title: "This is your position"),
      );

      setState(() {
        CameraPosition cameraPosition = CameraPosition(target: latLngLiveDriverPosition, zoom: 18);
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere((element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      //updating driver location at real time in database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("driverLocation").set(driverLatLngDataMap);

    });

  }

  updateDurationTimeAtRealTime() async {
    if(isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;

      if(onlineDriverCurrentPosition == null){
        return;
      }

      var originLatLng = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);

      var destinationLatLng;

      if(rideRequestStatus == "accepted"){
        destinationLatLng = widget.userRideRequestDetails!.originLatLng; //user pickUp Location
      }
      else {
        destinationLatLng = widget.userRideRequestDetails!.destinationLatLng;
      }

      var directionInformation = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

      if(directionInformation != null){
        setState(() {
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;
    }
  }

  createDriverIconMarker() {
    if(iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/Car2.png").then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  saveAssignedDriverDetailsToUserRideRequest() {

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!);

    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };

    if(databaseReference.child("driverId") != "waiting"){
      databaseReference.child("driverLocation").set(driverLocationDataMap);

      databaseReference.child("status").set("accepted");
      databaseReference.child("driverId").set(onlineDriverData.id);
      databaseReference.child("driverName").set(onlineDriverData.name);
      databaseReference.child("driverPhone").set(onlineDriverData.phone);
      databaseReference.child("ratings").set(onlineDriverData.ratings);
      databaseReference.child("car_details").set(onlineDriverData.car_color.toString());

      saveRideRequestIdToDriverHistory();
    }
    else{
      Fluttertoast.showToast(msg: "This ride is already accepted by another driver. \n Reloading the App");
      Navigator.pop(context);
      //Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
    }


  }

  saveRideRequestIdToDriverHistory(){
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("tripsHistory");

    tripsHistoryRef.child(widget.userRideRequestDetails!.rideRequestId!).set(true);
  }


  cancelTripNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(message:  "Please wait....",)
    );


    var tripDirectionDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(widget.userRideRequestDetails!.originLatLng!, widget.userRideRequestDetails!.destinationLatLng!);

    Navigator.pop(context);

    //fare amount
    double totalFareAmount = AssistantMethods.cancelcalculateFareAmountFromOriginToDestination(tripDirectionDetails);

    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("fareAmount").set(totalFareAmount.toString());

    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("status").set("cancelled");



    //display fare amount in dialog box
    var response = await showDialog(
        context: context,
        builder: (BuildContext context) => CancelFareAmountCollectionDialog(
          totalFareAmount: totalFareAmount,
        )
    );
    if(response == "CancelRide"){
      String assignedDriverId = widget.userRideRequestDetails!.rideRequestId!;
      String assignedDriverId1 = widget.userRideRequestDetails!.userId!;
      Navigator.push(context, MaterialPageRoute(builder: (c) => RateDriverScreenCancel(
        assignedDriverId: assignedDriverId,assignedUserId: assignedDriverId1,
      )));
    }

    //save fare amount to driver total earnings
    saveFareAmountToDriverEarnings(totalFareAmount);
  }

  endTripNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(message:  "Please wait....",)
    );

    var tripDirectionDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(widget.userRideRequestDetails!.originLatLng!, widget.userRideRequestDetails!.destinationLatLng!);

    Navigator.pop(context);

    double totalFareAmount;
    double security = 0.0;

    // Check the value of 'selected' in the database
    if (widget.userRideRequestDetails!.selected! == '1'|| widget.userRideRequestDetails!.selected! == '2' ||widget.userRideRequestDetails!.selected! == '3') {
      totalFareAmount = AssistantMethods.calculate3FareAmountFromOriginToDestination(tripDirectionDetails);
      security = totalFareAmount * 0.07;
    } else if (widget.userRideRequestDetails!.selected! == '4') {
      totalFareAmount = AssistantMethods.calculate4FareAmountFromOriginToDestination(tripDirectionDetails);
      security = totalFareAmount * 0.07;
    }
    else {
      totalFareAmount = 0.0; // Default value if 'selected' is not '1', '2', or '3'
    }


    // Save the total fare amount to the database
    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("fareAmount").set(totalFareAmount.toString());

    // Set the status to "ended"
    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("status").set("ended");

    // Display fare amount in dialog box
    var response = await showDialog(
        context: context,
        builder: (BuildContext context) => FareAmountCollectionDialog(
          totalFareAmount: totalFareAmount,
        )
    );

    if(response == "Collect Cash"){
      String assignedDriverId = widget.userRideRequestDetails!.rideRequestId!;
      String assignedDriverId1 = widget.userRideRequestDetails!.userId!;
      Navigator.push(context, MaterialPageRoute(builder: (c) => RateDriverScreen(
        assignedDriverId: assignedDriverId,assignedUserId: assignedDriverId1,
      )));
    }
    // Save fare amount to driver total earnings
    saveFareAmountToDriverEarnings(totalFareAmount);
    securityDepositofDriver(security);
  }

  saveFareAmountToDriverEarnings(double totalFareAmount){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
      if(snap.snapshot.value != null){
        double oldEarnings = double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings = totalFareAmount + oldEarnings;

        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").set(driverTotalEarnings.toString());
      }
      else{
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").set(totalFareAmount.toString());
      }
    });
  }
  securityDepositofDriver(double security){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("deposit").once().then((snap){
      if(snap.snapshot.value != null){
        double oldEarnings = double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings = security - oldEarnings;

        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("deposit").set(driverTotalEarnings.toString());
      }
      else{
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("deposit").set(security.toString());
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    createDriverIconMarker();

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;


    return Scaffold(
      body: Stack(
        children: [

          //google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller) {

              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              if(darkTheme == true){
                setState(() {
                  blackThemeGoogleMap(newTripGoogleMapController);
                });
              }

              setState(() {
                mapPadding = 350;
              });

              var driverCurrentLatLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

              var userPickUpLatLng = widget.userRideRequestDetails!.originLatLng;

              drawPolyLineFromOriginToDestination(driverCurrentLatLng, userPickUpLatLng!, darkTheme);

              getDriverLocationUpdatesAtRealTime();

            },
          ),

          //UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: darkTheme ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 18,
                        spreadRadius: 0.5,
                        offset: Offset(0.6, 0.6),
                      )
                    ]
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      //duration
                      Text(durationFromOriginToDestination,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkTheme ? Colors.amber.shade400 : Colors.black,
                        ),
                      ),

                      SizedBox(height: 10,),

                      Divider(thickness: 1,color: darkTheme ? Colors.amber.shade400 : Colors.grey,),

                      SizedBox(height: 10,),


                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child:
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c) => Comments()));

                                // Ilagay dito ang mga actions na nais mong gawin kapag na-tap ang `Row`
                                print("Row tapped!");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 40,
                                    color: darkTheme ? Colors.amber.shade400 : Colors.black,
                                  ),
                                  SizedBox(width: 8), // Magdagdag ng puwang sa pagitan ng icon at text
                                  Text(
                                    "Passenger Name :  " + widget.userRideRequestDetails!.userName!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("tel://${widget.userRideRequestDetails!.userPhone.toString()}"),
                                  );
                                },
                                icon: Icon(Icons.call),
                                label: Text("Call User"),
                                style: ElevatedButton.styleFrom(
                                  primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse("sms://${widget.userRideRequestDetails!.userPhone.toString()}"),
                                  );
                                },
                                icon: Icon(Icons.message),
                                label: Text("Message User"),
                                style: ElevatedButton.styleFrom(
                                  primary: darkTheme ? Colors.amber.shade400 : Colors.green,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),





                      SizedBox(height: 10,),


                      Row(
                        children: [
                          Image.asset("images/origin.png",
                            width: 30,
                            height: 30,
                          ),

                          SizedBox(width: 10,),

                          Expanded(child:
                          Container(
                            child: Text(
                              widget.userRideRequestDetails!.originAddress!,
                              style: TextStyle(
                                fontSize: 16,
                                color: darkTheme ? Colors.amberAccent : Colors.black,
                              ),
                            ),
                          )
                          )

                        ],
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Icon(Icons.ads_click_outlined,),

                          SizedBox(width: 10,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _launchMaps(widget.userRideRequestDetails!.destinationAddress!);
                              },
                              child: Container(
                                child: Text(
                                  widget.userRideRequestDetails!.destinationAddress!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: darkTheme ? Colors.amberAccent : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),

                      SizedBox(height: 10,),


                      Row(
                        children: [
                          Image.asset("images/destination.png",
                            width: 30,
                            height: 30,
                          ),

                          SizedBox(width: 10,),

                          Expanded(child:
                          Container(
                            child: Text("Pamasahe: "+
                              widget.userRideRequestDetails!.fareAmount!,
                              style: TextStyle(
                                fontSize: 16,
                                color: darkTheme ? Colors.amberAccent : Colors.black,
                              ),
                            ),
                          ),

                          ),
                          // Container(
                          //   child: Text("Need ID: "+
                          //       widget.userRideRequestDetails!.discount!,
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: darkTheme ? Colors.amberAccent : Colors.black,
                          //     ),
                          //   ),
                          // )




                        ],
                      ),

                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Image.asset("images/destination.png",
                            width: 30,
                            height: 30,
                          ),

                          SizedBox(width: 10,),

                          Expanded(child:
                          Container(
                            child: Text("Number of Passengers: "+
                                widget.userRideRequestDetails!.selected!,
                              style: TextStyle(
                                fontSize: 16,
                                color: darkTheme ? Colors.amberAccent : Colors.black,
                              ),
                            ),
                          ),

                          ),
                          // Container(
                          //   child: Text("Need ID: "+
                          //       widget.userRideRequestDetails!.discount!,
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: darkTheme ? Colors.amberAccent : Colors.black,
                          //     ),
                          //   ),
                          // )




                        ],
                      ),

                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Image.asset("images/origin.png",
                            width: 30,
                            height: 30,
                          ),

                          SizedBox(width: 10,),

                          Expanded(child:
                          Container(
                            child:
                            Text(
                              "Notes: " +
                                  (widget.userRideRequestDetails!.notes != null && widget.userRideRequestDetails!.notes!.isNotEmpty
                                      ? widget.userRideRequestDetails!.notes!
                                      : "None"),
                              style: TextStyle(
                                fontSize: 16,
                                color: darkTheme ? Colors.amberAccent : Colors.black,
                              ),
                            ),


                          ),



                          ),


                        ],
                      ),

                      SizedBox(height: 10,),
                      Text(
                        "Ratings: " +

                            (widget.userRideRequestDetails!.ratingsOfUser != null && widget.userRideRequestDetails!.ratingsOfUser!.isNotEmpty
                                ? widget.userRideRequestDetails!.ratingsOfUser!
                                : "No Ratings Yet"),
                        style: TextStyle(
                          fontSize: 16,
                          color: darkTheme ? Colors.amberAccent : Colors.black,
                        ),
                      ),


                      Divider(
                        thickness: 1,
                        color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                      ),

                      SizedBox(height: 10,),

                      ElevatedButton.icon(
                          onPressed: () async {


                            if(rideRequestStatus == "accepted"){
                              rideRequestStatus = "arrived";



                              FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("status").set(rideRequestStatus);

                              setState(() {
                                buttonTitle = "Let's Go";
                                buttonColor = Colors.lightGreen;
                              });

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => ProgressDialog(message: "Loading...",)
                              );

                              await drawPolyLineFromOriginToDestination(
                                  widget.userRideRequestDetails!.originLatLng!,
                                  widget.userRideRequestDetails!.destinationLatLng!,
                                  darkTheme
                              );

                              Navigator.pop(context);
                            }
                            //[user has been picked from the user's current location] - Let's Go Button
                            else if(rideRequestStatus == "arrived"){
                              rideRequestStatus = "ontrip";

                              FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("status").set(rideRequestStatus);

                              setState(() {
                                buttonTitle = "End Trip";
                                buttonColor = Colors.red;
                              });
                            }
                            //[user/driver has reached the drop-off location] - End Trip Button
                            else if(rideRequestStatus == "ontrip"){
                              endTripNow();
                            }



                          },
                          icon: Icon(Icons.directions_car,color: darkTheme ? Colors.black : Colors.white, size: 25,),
                          label: Text(
                            buttonTitle!,
                            style: TextStyle(
                              color: darkTheme ? Colors.black : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Cancel Ride"),
                                content: Text("Are you sure you want to cancel the ride?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      cancelTripNow();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "Cancel Ride",
                          style: TextStyle(
                            color: darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: darkTheme ? Colors.amber.shade400 : Colors.red,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}













