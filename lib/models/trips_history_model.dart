

import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;
  String? comments;
  String? userId;
  String? ratingstoDriver;
  String? ratingstoUser;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.fareAmount,
    this.userName,
    this.userPhone,
    this.comments,
    this.userId,
    this.ratingstoUser,
    this.ratingstoDriver
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot){
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
    comments = (dataSnapshot.value as Map)["comments"];
    userId = (dataSnapshot.value as Map)["userId"];
    ratingstoUser = (dataSnapshot.value as Map)["ratingstoUser"];
    ratingstoDriver = (dataSnapshot.value as Map)["ratingstoDriver"];
  }
}