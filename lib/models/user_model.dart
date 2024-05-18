
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  String? address;
  String? status;
  String? rid;
  String? deposit;
  //String? userRate;

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.id,
    this.address,
    this.status,
    this.rid,
    this.deposit
   // this.userRate,
  });

  UserModel.fromSnapshot(DataSnapshot snap){
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    address = (snap.value as dynamic)["address"];
    status = (snap.value as dynamic)["status"] ?? "fetching";
    rid = (snap.value as dynamic)["rid"];
    deposit = (snap.value as dynamic)["deposit"];

    //userRate = (snap.value as dynamic)["ratingstoUser"];

  }
}