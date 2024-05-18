import 'package:drivers/global/global.dart';
import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../tabPages/earning_tab.dart';
import '../tabPages/home_tab.dart';
import '../tabPages/profile_tab.dart';
import '../tabPages/ratings_tab.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    getUserInfoAndCheckBlockStatus1();
    cancelCheck();
    getUserInfoAndCheckBlockStatus();
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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

  void getUserInfoAndCheckBlockStatus1() async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentUser!.uid);


    await usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        double ratingsToUser = double.parse((snap.snapshot.value as Map)["ratings"] ?? "0");
        if (ratingsToUser <= 3) {
          // Update blockStatus to 'yes' if ratingsToUser is below 1
          usersRef.update({"blockStatus": "yes","status": "offline",}).then((_) {
            setState(() {
              userName = (snap.snapshot.value as Map)["name"];
              userPhone = (snap.snapshot.value as Map)["phone"];
            });
          });
        } else if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
          });
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => LoginScreen()));
          Fluttertoast.showToast(msg: "You are Blocked");
        }
      } else {
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });

  }

  void cancelCheck() async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentUser!.uid);


    await usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        double ratingsToUser = double.parse((snap.snapshot.value as Map)["ratingsCancel"] ?? "0");
        if (ratingsToUser <= 3) {
          // Update blockStatus to 'yes' if ratingsToUser is below 1
          usersRef.update({"blockStatus": "yes","status": "offline","cancel":"0"}).then((_) {
            setState(() {
              userName = (snap.snapshot.value as Map)["name"];
              userPhone = (snap.snapshot.value as Map)["phone"];
            });
          });
        } else if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
          });
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => LoginScreen()));
          Fluttertoast.showToast(msg: "You are Blocked");
        }
      } else {
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });

  }


  // void secondviolationBlock() async {
  //   DatabaseReference usersRef = FirebaseDatabase.instance.ref()
  //       .child("drivers")
  //       .child(FirebaseAuth.instance.currentUser!.uid);
  //
  //   await usersRef.once().then((snap) {
  //     if (snap.snapshot.value != null) {
  //       double ratingsToUser = double.parse((snap.snapshot.value as Map)["counter"] && ["blockStatus"]);
  //       if (ratingsToUser <= 3) {
  //         // Update blockStatus to 'yes' if ratingsToUser is below 1
  //         usersRef.update({"blockStatus": "yes"}).then((_) {
  //           setState(() {
  //             userName = (snap.snapshot.value as Map)["name"];
  //             userPhone = (snap.snapshot.value as Map)["phone"];
  //           });
  //         });
  //       } else if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
  //         setState(() {
  //           userName = (snap.snapshot.value as Map)["name"];
  //         });
  //       } else {
  //         FirebaseAuth.instance.signOut();
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (c) => LoginScreen()));
  //         Fluttertoast.showToast(msg: "You are Blocked");
  //       }
  //     } else {
  //       FirebaseAuth.instance.signOut();
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (c) => LoginScreen()));
  //     }
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return WillPopScope(
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTabPage(),
            EarningsTabPage(),
            RatingsTabPage(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Earnings"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Ratings"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
          unselectedItemColor: darkTheme ? Colors.black54 : Colors.white54,
          selectedItemColor: darkTheme ? Colors.black : Colors.white,
          backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 14),
          showUnselectedLabels: true,
          currentIndex: tabController.index,
          onTap: (index) {
            setState(() {
              tabController.index = index;
            });
          },
        ),
      ),
      onWillPop: () => _onBackButtonPressed(context),
    );
  }
}

Future<bool> _onBackButtonPressed(BuildContext context) async {
  bool? exitApp = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Really??"),
        content: const Text("Do you want to close the apps??"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Yes"),
          )
        ],
      );
    },
  );
  return exitApp ?? false;
}
