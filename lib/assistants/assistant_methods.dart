import 'dart:convert';
import 'dart:ffi';
import 'package:euser/assistants/request_assistant.dart';
import 'package:euser/global/global.dart';
import 'package:euser/global/maps_key.dart';
import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/models/direction_details_info.dart';
import 'package:euser/models/directions.dart';
import 'package:euser/models/trips_history_model.dart';
import 'package:euser/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if (requestResponse != "Error Occurred: No Response!") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude.toString();
      userPickUpAddress.locationLongitude = position.longitude.toString();
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocation(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred: No Response!") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static double estimatedFare(DirectionDetailsInfo directionDetailsInfo) {
    //per km = in db
    //per minute = in db
    timeTraveledFarePerMinute = (directionDetailsInfo.duration_value! / 60) *
        perMin; //0.1 is dollar charge per minute

    distanceTraveledFarePerKilometer =
        (directionDetailsInfo.distance_value! / 1000) *
            perKm; //0.1 is dollar charge per minute

    double totalFare = distanceTraveledFarePerKilometer +
        timeTraveledFarePerMinute +
        base +
        bookingFee;

    return double.parse(totalFare.toStringAsFixed(2));
  }

  static void getCarType() {
    DatabaseReference furgo =
        FirebaseDatabase.instance.ref().child('BaseFare/Furfetch-go');
    DatabaseReference furx =
        FirebaseDatabase.instance.ref().child('BaseFare/Furfetch-x');
    DatabaseReference motor =
        FirebaseDatabase.instance.ref().child('BaseFare/Motorcycle');
    furgo.once().then((snap) {
      if (snap.snapshot.value != null) {
        xfurgo = double.parse(snap.snapshot.value.toString());
        print(xfurgo);
      }
    });
    furx.once().then((snap) {
      if (snap.snapshot.value != null) {
        xfurx = double.parse(snap.snapshot.value.toString());
        print(xfurx);
      }
    });
    motor.once().then((snap) {
      if (snap.snapshot.value != null) {
        xmotor = double.parse(snap.snapshot.value.toString());
        print(xmotor);
      }
    });
  }

  static void getValues() {
    DatabaseReference getKm =
        FirebaseDatabase.instance.ref().child('BaseFare/PerKm');
    DatabaseReference getMin =
        FirebaseDatabase.instance.ref().child('BaseFare/PerMin');
    DatabaseReference bookinF =
        FirebaseDatabase.instance.ref().child('BaseFare/BookingFee');
    getKm.once().then((snap) {
      if (snap.snapshot.value != null) {
        perKm = double.parse(snap.snapshot.value.toString());
        print(perKm);
      }
    });
    getMin.once().then((snap) {
      if (snap.snapshot.value != null) {
        perMin = double.parse(snap.snapshot.value.toString());
        print(perMin);
      }
    });
    bookinF.once().then((snap) {
      if (snap.snapshot.value != null) {
        bookingFee = double.parse(snap.snapshot.value.toString());
        print(bookingFee);
      }
    });
  }

  static void timeframe() {
    DatabaseReference times =
        FirebaseDatabase.instance.ref().child('BaseFare/TimeFrame');
    times.once().then((snap) {
      if (snap.snapshot.value != null) {
        timeFrame = int.parse(snap.snapshot.value.toString());
        print(timeFrame);
      }
    });
  }

  static sendNotificationToDriverNow(
      String deviceRegistrationToken, String userRideRequestId, context) async {
    String destinationAddress = userDropOffAddress;
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "body": "Destination Address, $destinationAddress",
      "title": "New Trip Request",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "priority": "high",
      "data": dataMap,
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  //retrieve the trip keys
  //trip keys - ride request uid
  static void readTripKeysForOnlineUser(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .orderByChild("userId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keyTripsId = snap.snapshot.value as Map;

        //count total number of trip and share it with Provider
        int overAllTripsCounter = keyTripsId.length;
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeyList = [];
        keyTripsId.forEach((key, value) {
          tripsKeyList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeyList);

        //get trip keys data - trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for (String eachKey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(eachKey)
          .once()
          .then((snap) {
        var eachHistoryTrip = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if ((snap.snapshot.value as Map)["status"] == "ended") {
          //update OverAllTrips History Data
          Provider.of<AppInfo>(context, listen: false)
              .updateOverAllHistoryInformation(eachHistoryTrip);
        }
      });
    }
  }
}
