import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? carDetails;
  String? destinationAddress;
  String? driverName;
  String? driverPhone;
  String? originAddress;
  String? endTime;
  String? fareAmount;
  String? status;

  TripsHistoryModel({
    this.carDetails,
    this.destinationAddress,
    this.driverName,
    this.driverPhone,
    this.originAddress,
    this.endTime,
    this.fareAmount,
    this.status,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    carDetails = (dataSnapshot.value as Map)["car_details"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    driverName = (dataSnapshot.value as Map)["driverName"];
    driverPhone = (dataSnapshot.value as Map)["driverPhone"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["end_trip"]["fare_amount"].toString();
    endTime = (dataSnapshot.value as Map)["end_trip"]["end_trip_time"];
  }
}
