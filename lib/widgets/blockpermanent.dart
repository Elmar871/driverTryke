import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/global.dart';

class BlockPermanent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Violation Notice"),
      content: Text("You are permanently Banned"),
      actions: <Widget>[
        TextButton(
          child: Text("OK"),
          onPressed: () {

            firebaseAuth.signOut();

            firebaseAuth.signOut();
            Navigator.pop(context);
            //Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));

          },
        ),
        TextButton(
          child: Text("Contact Us on Gmail"),
          onPressed: () {
            launchUrl(Uri.parse("mailto:elmars972@gmail.com"));

            firebaseAuth.signOut();
            firebaseAuth.signOut();
            //Navigator.push(context, MaterialPageRoute(builder: (c)=> SplashScreen()));
          },
        ),
      ],
    );
  }
}

// Para ipakita ang dialog box:
// showDialog(context: context, builder: (context) => ViolationDialog());
