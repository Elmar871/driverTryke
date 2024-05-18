import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers/Assistants/assistant_methods.dart';
import 'package:drivers/global/global.dart';
import 'package:drivers/models/user_ride_request_information.dart';
import 'package:drivers/screens/new_trip_screen.dart';
import 'package:drivers/tabPages/home_tab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../splashScreen/splash_screen.dart';

class NotificationDialogBox extends StatefulWidget {

  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});



  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: darkTheme ? Colors.black : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              onlineDriverData.car_type == "Tricycle"
                  ? "images/Car.png"
                  : onlineDriverData.car_type == "CNG"
                  ? "images/CNG.png"
                  : "images/Bike.png",
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
            ),


            SizedBox(height: 10,),

            //title
            Text("New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              ),
            ),

            SizedBox(height: 14,),

            Divider(
              height: 2,
              thickness: 2,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset("images/origin.png",
                        width: 30,
                        height: 30,
                      ),

                      SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.userName!,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 20,),
                  // Row(
                  //   children: [
                  //     Image.asset("images/origin.png",
                  //       width: 30,
                  //       height: 30,
                  //     ),
                  //
                  //     SizedBox(width: 10,),
                  //
                  //     // Expanded(
                  //     //   child: Container(
                  //     //     child: Text(
                  //     //       widget.userRideRequestDetails!.ratingsOfUser!,
                  //     //       style: TextStyle(
                  //     //         fontSize: 16,
                  //     //         color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                  //     //       ),
                  //     //     ),
                  //     //   ),
                  //     // )
                  //   ],
                  // ),
                  SizedBox(height: 20,),


                  Row(
                    children: [
                      Image.asset("images/origin.png",
                        width: 30,
                        height: 30,
                      ),

                      SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 20,),


                  Row(
                    children: [
                      Image.asset("images/destination.png",
                        width: 30,
                        height: 30,
                      ),

                      SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            ),
                          ),
                        ),
                      ),


                    ],
                  )


                ],
              ),
            ),

            Divider(
              height: 2,
              thickness: 2,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10,),


                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.money_outlined,
                        size: 30,
                        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      ),

                      SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                          child: Text("Pamasahe: " +
                            widget.userRideRequestDetails!.fareAmount!,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.money_outlined,
                        size: 30,
                        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      ),

                      SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                          child: Text("Number of Passengers: " +
                              widget.userRideRequestDetails!.selected! ?? '1',
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),


                  SizedBox(height: 10,),




                  Row(
                    children: [


                      SizedBox(width: 10,),

                      // Expanded(
                      //   child: Container(
                      //     child: Text(
                      //       "Kapag May Discount: " + widget.userRideRequestDetails!.fareAmount!,
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),




                  Row(
                    children: [
                      Icon(
                        Icons.speaker_notes_outlined,
                        size: 30,
                        color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      ),

                      SizedBox(width: 10,),

                      Expanded(
                        child: Container(
                          child: Text(
                            "Notes ng User: " +
                                (widget.userRideRequestDetails!.notes != null &&
                                    widget.userRideRequestDetails!.notes!.isNotEmpty
                                    ? widget.userRideRequestDetails!.notes!
                                    : "none"),
                            style: TextStyle(
                              fontSize: 16,
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                            ),
                          ),
                        ),
                      ),



                    ],
                  ),



                ],
              ),
            ),

            //buttons for cancelling and accepting the ride request
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      Navigator.pop(context);
                     //FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("status").set("offline");
                     //Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));

                      //Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ),

                  SizedBox(width: 20,),

                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      acceptRideRequest(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  // cancelNotificationDialogAfter20Sec()
  // {
  //   const oneTickPerSecond = Duration(seconds: 1);
  //
  //   var timerCountDown = Timer.periodic(oneTickPerSecond, (timer)
  //   {
  //     driverTripRequestTimeout = driverTripRequestTimeout - 1;
  //
  //     if(driverTripRequestTimeout == 0)
  //     {
  //       Navigator.pop(context);
  //       timer.cancel();
  //       driverTripRequestTimeout = 20;
  //       audioPlayer.stop();
  //     }
  //   });
  // }
  acceptRideRequest(BuildContext context){

    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) async
    {
      if(snap.snapshot.value == "idle") {
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("newRideStatus").set("accepted");

        //RideRequestID
        FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("rid").set(widget.userRideRequestDetails!.rideRequestId);

        //RideRequestStatus
        await FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!).child("status").set("status");

        //RideRequestStatus
        DatabaseReference rideRequestRef = FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!);

        //Saving ride request id to users
        rideRequestRef.once().then((snap) async {
          var userId = (snap.snapshot.value as dynamic)["userId"];
          await FirebaseDatabase.instance.ref().child("users").child(userId).child("rid").set(widget.userRideRequestDetails!.rideRequestId!);
          await FirebaseDatabase.instance.ref().child("users").child(userId).child("rVehicleType").set(carModelCurrentInfo!.type);
        });

        //await AssistantMethods.pauseLiveLocationUpdates();

        Fluttertoast.showToast(msg: "Ride accepted. Please wait");

        //trip started now - send driver to new tripScreen
        Future.delayed(Duration(milliseconds: 1000), ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (c) =>
              NewTripScreen(
                userRideRequestDetails: widget.userRideRequestDetails,
              )));
        });
      }
      else {
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");

          //Status
          //FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("status").set("offline");
          //Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
          Navigator.pop(context);

      }
    });
  }
}
















