import 'package:drivers/widgets/report.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

  Future<void> showUserNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Succesfully. \n Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error Occurred. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  Future<void> showUserPhoneDialogAlert(BuildContext context, String phone) {
    phoneTextEditingController.text = phone;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone": phoneTextEditingController.text.trim(),
                  }).then((value) {
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Succesfully. \n Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error Occurred. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  Future<void> showUserAddressDialogAlert(BuildContext context,
      String address) {
    addressTextEditingController.text = address;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),

              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "address": addressTextEditingController.text.trim(),
                  }).then((value) {
                    addressTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Succesfully. \n Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error Occurred. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.black,
          //   ),
          // ),
          title: Text(
            "Profile Screen",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child:
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 30, // Updated radius size
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.lightBlue,
                      size: 30, // Updated icon size
                    ),
                  ),
                ),

                SizedBox(height: 30),

                ListTile(
                  title: Text(
                    "Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userModelCurrentInfo!.name!),
                ),
                ListTile(
                  title: Text(
                    "Security Deposit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userModelCurrentInfo!.deposit!),
                ),
                Divider(
                  thickness: 1,
                ),

                ListTile(
                  title: Text(
                    "Phone",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userModelCurrentInfo!.phone!),
                ),
                Divider(
                  thickness: 1,
                ),

                ListTile(
                  title: Text(
                    "Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userModelCurrentInfo!.address!),
                ),
                Divider(
                  thickness: 1,
                ),

                ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userModelCurrentInfo!.email!),
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            c) => Report()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                      ),
                      child: Text("Report"),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        firebaseAuth.signOut();
                        firebaseAuth.signOut();
                        firebaseAuth.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (
                            c) => SplashScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                      ),
                      child: Text("Log Out"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
