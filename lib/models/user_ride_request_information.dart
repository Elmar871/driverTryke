

import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation{
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;
  String? status;
  String? notes;
  String? fareAmount;
  String? userId;
  String? selected;
  String? discount;
  String? fareAmount1;
  String? ratingsOfUser;

  UserRideRequestInformation({
    this.originLatLng,
    this.destinationLatLng,
    this.originAddress,
    this.destinationAddress,
    this.rideRequestId,
    this.userName,
    this.userPhone,
    this.status,
    this.notes,
    this.fareAmount,
    this.userId,
    this.selected,
    this.discount,
    this.fareAmount1,
    this.ratingsOfUser
  });

  UserRideRequestInformation.fromSnapshot(DataSnapshot snap){
    originLatLng = LatLng(double.parse((snap.value as dynamic)["origin"]["latitude"]), double.parse((snap.value as dynamic)["origin"]["longitude"]));
    destinationLatLng = LatLng(double.parse((snap.value as dynamic)["destination"]["latitude"]), double.parse((snap.value as dynamic)["destination"]["longitude"]));
    originAddress = (snap.value as dynamic)["originAddress"];
    destinationAddress = (snap.value as dynamic)["destinationAddress"];
    rideRequestId = (snap.value as dynamic)["rid"];
    userName = (snap.value as dynamic)["userName"];
    userPhone = (snap.value as dynamic)["userPhone"];
    status = (snap.value as dynamic)["status"];
    notes = (snap.value as dynamic)["notes"];
    fareAmount = (snap.value as dynamic)["fareAmount"];
    userId = (snap.value as dynamic)["userId"];
    selected = (snap.value as dynamic)["selected"];
    discount = (snap.value as dynamic)["discount"];
    fareAmount1 = (snap.value as dynamic)["fareAmount1"];
    ratingsOfUser = (snap.value as dynamic)["ratingstoUser"];
  }
}