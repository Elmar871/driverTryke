import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import 'Disclaimer.dart';
import 'login_screen.dart';

class FirstOffense extends StatefulWidget {
  @override
  _FirstOffenseState createState() => _FirstOffenseState();
}

class _FirstOffenseState extends State<FirstOffense> {
  final TextEditingController controller = TextEditingController();


  final _formKey = GlobalKey<FormState>();



  _submit() {

    //counter++;
    Map driverCarInfoMap = {
      "complain": controller.text.trim()
    };

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
    // userRef.child(currentUser!.uid).child("complain").set(driverCarInfoMap);
    userRef.child(firebaseAuth.currentUser!.uid).update({
      "counterLogin": "1",
      "ratings" : "3.1",
      "blockStatus" : "no",
      "status": "offline",
      "complain": controller.text.trim()
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));



    //Fluttertoast.showToast(msg: "Successfully Saved, Wait for the admin to Approve you again");
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text('Complain'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('This is your first offense. You have received low ratings from drivers. If this happens again and you receive a second offense, you will need to report to the admin to be unblocked.'),

          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {

            _submit();

          },
          child: Text('Agree'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            firebaseAuth.signOut();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
