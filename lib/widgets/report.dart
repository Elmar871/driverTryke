import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';


class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();

  _submit() {
    Map reportMap = {
      "FullName": fullNameController.text.trim(),
      "Complaint": complaintController.text.trim(),
    };

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("complain").push();
    userRef.child("Report").set(reportMap);

    Fluttertoast.showToast(msg: "Successfully Saved, Wait for the admin to Approve you again");

    setState(() {
      // Update the UI to reflect changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
      Text('Reports and Suggestions'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Full Name (Optional):'),
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('Reports/Suggestions:'),
            TextFormField(
              controller: complaintController,
              decoration: InputDecoration(
                hintText: 'Enter your complaint here',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Reports can\'t be null';
                }
                return null;
              },
            ),

          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _submit();
            Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
          },
          child: Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
