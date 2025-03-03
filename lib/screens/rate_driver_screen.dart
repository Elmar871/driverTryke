import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../global/global.dart';
import '../models/user_ride_request_information.dart';
import '../splashScreen/splash_screen.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;
  String? assignedUserId;
  UserRideRequestInformation? userRideRequestDetails;

  RateDriverScreen({this.assignedDriverId, this.userRideRequestDetails, this.assignedUserId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  double countRatingStars = 0.0;
  String titleStarsRating = "";

  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkTheme ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22,),
            Text("Rate Trip Experience",
              style: TextStyle(
                fontSize: 22,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            Divider(thickness: 2,color: darkTheme ? Colors.amber.shade400 : Colors.blue,),
            SizedBox(height: 20,),
            SmoothStarRating(
              rating: countRatingStars,
              allowHalfRating: false,
              starCount: 5,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              borderColor: darkTheme ? Colors.amber.shade400 : Colors.grey,
              size: 46,
              onRatingChanged: (valueOfStarsChoosed){
                setState(() {
                  countRatingStars = valueOfStarsChoosed;

                  if(countRatingStars == 1){
                    titleStarsRating = "Very Bad";
                  } else if(countRatingStars == 2){
                    titleStarsRating = "Bad";
                  } else if(countRatingStars == 3){
                    titleStarsRating = "Good";
                  } else if(countRatingStars == 4){
                    titleStarsRating = "Very Good";
                  } else if(countRatingStars == 5){
                    titleStarsRating = "Excellent";
                  }
                });
              },
            ),
            SizedBox(height: 10,),
            Text(
              titleStarsRating,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              controller: controller,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                hintText: "Comment/Feedback",
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (countRatingStars == 0) ? null : () {
                DatabaseReference rateu = FirebaseDatabase.instance.ref().child("All Ride Requests")
                    .child(widget.assignedDriverId!)
                    .child("ratingstoUser");

                rateu.once().then((snap){
                  rateu.set(countRatingStars.toString());
                });
                DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref()
                    .child("users")
                    .child(widget.assignedUserId!)
                    .child("ratingstoUser");

                rateDriverRef.once().then((snap){
                  if(snap.snapshot.value == null){
                    rateDriverRef.set(countRatingStars.toString());

                    DatabaseReference comment = FirebaseDatabase.instance.ref().child("All Ride Requests")
                        .child(widget.assignedDriverId!)
                        .child("commentsofdriver");

                    comment.once().then((snap){
                      comment.set(controller.text);
                    });
                    DatabaseReference commentus = FirebaseDatabase.instance.ref().child("users")
                        .child(widget.assignedUserId!)
                        .child("commetsofdriver");


                    commentus.push().set(controller.text);
                    Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                  }
                  else {
                    double pastRatings = double.parse(snap.snapshot.value.toString());
                    double newAverageRatings = (pastRatings + countRatingStars)/ 2;
                    rateDriverRef.set(newAverageRatings.toString());

                    DatabaseReference comment = FirebaseDatabase.instance.ref().child("All Ride Requests")
                        .child(widget.assignedDriverId!)
                        .child("commentsofdriver");

                    comment.once().then((snap){
                      comment.set(controller.text);
                    });
                    DatabaseReference commentus = FirebaseDatabase.instance.ref().child("users")
                        .child(widget.assignedUserId!)
                        .child("commetsofdriver");


                    commentus.push().set(controller.text);
                    Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                  }
                  Fluttertoast.showToast(msg: "Restarting the app now");
                });
              },
              style: ElevatedButton.styleFrom(
                primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 70),
              ),
              child: Text("Submit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkTheme ? Colors.black : Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
