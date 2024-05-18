
import 'dart:async';

import 'package:drivers/Assistants/request_assistant.dart';
import 'package:drivers/models/car_model.dart';
import 'package:drivers/models/trips_history_model.dart';
import 'package:drivers/models/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/direction_details_info.dart';
import '../models/directions.dart';
import '../models/user_model.dart';

class AssistantMethods {

  static readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("drivers")
      .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }


  static readCurrentOnlineUserCarInfo() async {
    DatabaseReference carRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid);

    carRef.once().then((snap){
      if(snap.snapshot.value != null){
        carModelCurrentInfo = CarModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static readOnTripInformation() async {
    if(userModelCurrentInfo!.rid != "free") {
      DatabaseReference tripRef = FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(userModelCurrentInfo!.rid!);

      tripRef.once().then((snap){
        if(snap.snapshot.value != null){
          userRideRequestInformation = UserRideRequestInformation.fromSnapshot(snap.snapshot);
        }
      });
    }

    // print("RID: ${userModelCurrentInfo!.rid}");
  }

  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No Response."){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {

    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";
    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    // if(responseDirectionApi == "Error Occured. Failed. No Response."){
    //   return "";
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }

  static double cancelcalculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {

    double distancePerKmAmount = 0;
    double baseFareAmount = 0;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double overAllTotalFareAmount = baseFareAmount + totalDistanceTravelFareAmount;

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));

  }

  static double calculate1FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 5;
    double baseFareAmount = 20;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double overAllTotalFareAmount = baseFareAmount + totalDistanceTravelFareAmount;

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }

  static double yescalculate1FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 5;
    double baseFareAmount = 20;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double percent = (baseFareAmount + totalDistanceTravelFareAmount) * 0.20;
    double overAllTotalFareAmount = (baseFareAmount + totalDistanceTravelFareAmount) - percent ;

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }


  static double calculate2FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 10;
    double baseFareAmount = 40;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double overAllTotalFareAmount = baseFareAmount + totalDistanceTravelFareAmount;

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }

  static double yescalculate2FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 10;
    double baseFareAmount = 40;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double percent = (baseFareAmount + totalDistanceTravelFareAmount) * 0.20;
    double overAllTotalFareAmount = (baseFareAmount + totalDistanceTravelFareAmount) - percent;

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }


  static double calculate3FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 15;
    double baseFareAmount = 60;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double overAllTotalFareAmount = baseFareAmount;

    if (directionDetailsInfo.distance_value! > 1000) {
      overAllTotalFareAmount += totalDistanceTravelFareAmount;
    }

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }

  static double calculate3FareAmountFromOriginToDestinationSecurity(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 15;
    double baseFareAmount = 60;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double overAllTotalFareAmount = baseFareAmount;

    if (directionDetailsInfo.distance_value! > 1000) {
      overAllTotalFareAmount += totalDistanceTravelFareAmount;
    }

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }


  static double calculate4FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 20;
    double baseFareAmount = 80;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;

    double overAllTotalFareAmount = baseFareAmount;

    if (directionDetailsInfo.distance_value! > 1000) {
      overAllTotalFareAmount += totalDistanceTravelFareAmount;
    }

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }



  static double yescalculate3FareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){

    double distancePerKmAmount = 15;
    double baseFareAmount = 60;

    double totalDistanceTravelFareAmount = (directionDetailsInfo.distance_value! / 1000) * distancePerKmAmount;
    double percent = (baseFareAmount + totalDistanceTravelFareAmount) * 0.20;
    double overAllTotalFareAmount = (baseFareAmount + totalDistanceTravelFareAmount) - percent;

    return double.parse(overAllTotalFareAmount.toStringAsFixed(0));
  }



  //retrieve the trips keys for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineDriver(context){
    FirebaseDatabase.instance.ref().child("All Ride Requests").orderByChild("driverId").equalTo(firebaseAuth.currentUser!.uid).once().then((snap){
      if(snap.snapshot.value != null){
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context){
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for(String eachKey in tripsAllKeys){
      FirebaseDatabase.instance.ref().child("All Ride Requests").child(eachKey).once().then((snap){
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended"){
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverEarnings(context){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
      if(snap.snapshot.value != null){
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
      }
    });

    readTripsKeysForOnlineDriver(context);
  }

  static void readDriverRatings(context){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("ratings").once().then((snap){
      if(snap.snapshot.value != null){
        String driverRatings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverAverageRatings(driverRatings);
      }
    });
  }



}













