import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers/pushNotification/notification_dialog_box.dart';
import 'package:drivers/pushNotification/push_notification_system.dart';
import 'package:drivers/screens/car_info_screen.dart';
import 'package:drivers/screens/login_screen.dart';
import 'package:drivers/splashScreen/splash_screen.dart';
import 'package:drivers/themeProvider/theme_provider.dart';
import 'package:drivers/widgets/fare_amount_collection_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'global/global.dart';
import 'infoHandler/app_info.dart';
import 'models/user_ride_request_information.dart';

// This will be triggered when the app receives a notification in the background.
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  //Fluttertoast.showToast(msg: 'A background message arrived: ${message.toString()}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "driver13",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  // This function gets the notification that was tapped to open the app.
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
    if (remoteMessage != null) {
      // Instead of directly processing this notification, we stored in a global variable called savedRemoteMessage for later processing
      savedRemoteMessage = remoteMessage;
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Drivers Tryke App',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        //home: SplashScreen(),
        home: Builder(builder: (context) {
          // Process the saved remote message if it exists
          if (savedRemoteMessage != null) {
            PushNotificationSystem.readUserRideRequestInformation(savedRemoteMessage?.data["rideRequestId"], context);
            savedRemoteMessage = null; // Clear the saved message
          }
          // Your normal hbome page
          return SplashScreen();
        }),
      ),
    );
  }
}


