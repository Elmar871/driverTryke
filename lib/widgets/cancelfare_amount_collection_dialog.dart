import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

class CancelFareAmountCollectionDialog extends StatefulWidget {
  double? totalFareAmount;

  CancelFareAmountCollectionDialog({this.totalFareAmount});

  @override
  State<CancelFareAmountCollectionDialog> createState() => _CancelFareAmountCollectionDialogState();
}

class _CancelFareAmountCollectionDialogState extends State<CancelFareAmountCollectionDialog> {
  final TextEditingController cancelController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkTheme ? Colors.black : Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),


            Text(
              //"Trip Fare Amount
              "Trip Fare Amount",
              style: TextStyle(fontWeight: FontWeight.bold,
                color: darkTheme ? Colors.amber.shade400 : Colors.white,
                fontSize: 20,
              ),
            ),

            Text(
              "P " + widget.totalFareAmount.toString(),
              style: TextStyle(fontWeight: FontWeight.bold,
                color: darkTheme ? Colors.amber.shade400 : Colors.white,
                fontSize: 50,
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "THE RIDE HAS BEEN CANCELLED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkTheme ? Colors.amber.shade400 : Colors.white,
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: darkTheme ? Colors.amber.shade400 : Colors.white,
                ),
                onPressed: () async {
                  DatabaseReference? ref = await FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

                  ref.set("idle");

                  FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("rid").set("free");

                  Fluttertoast.showToast(msg: "RESTARTING THE APPS");

                  Future.delayed(Duration(milliseconds: 1000), () {
                    //SystemNavigator.pop();
                    //Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                    Navigator.pop(context, "CancelRide");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("    BACK TO HOMEPAGE",
                      style: TextStyle(
                        fontSize: 20,
                        color: darkTheme ? Colors.black : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
