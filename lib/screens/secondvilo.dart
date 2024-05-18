import 'package:drivers/global/global.dart';
import 'package:drivers/screens/login_screen.dart';
import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViolationDialog extends StatelessWidget {
  _submit() {

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
    // userRef.child(currentUser!.uid).child("complain").set(driverCarInfoMap);
    userRef.child(firebaseAuth.currentUser!.uid).update({
      "counterLogin": "2",
    });



    //Fluttertoast.showToast(msg: "Successfully Saved, Wait for the admin to Approve you again");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Violation Notice"),
      content: Text("This is your 2nd violation. Please report to your Toda President/admin for you to unblock and use the apps again."),
      actions: <Widget>[
        TextButton(
          child: Text("OK"),
          onPressed: () {
            _submit();
            firebaseAuth.signOut();
            Navigator.of(context).pop();
          },
        ),
        GestureDetector(
            onTap: () {
              _submit();
              launchUrl(Uri.parse("mailto:elmars972@gmail.com"));

            },
            child: Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
        ),
      ],
    );
  }
}

// Para ipakita ang dialog box:
// showDialog(context: context, builder: (context) => ViolationDialog());
