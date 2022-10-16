import 'dart:async';
import 'package:euser/models/direction_details_info.dart';
import 'package:euser/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;

User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
LatLng? driverlocation;
List dList = []; //driverKeys Info List for ride request
DirectionDetailsInfo? tripDirectionDetailsInfo; //for fare calculation
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
String? chosenDriverId;
String cloudMessagingServerToken =
    "key=AAAA0sQEtTs:APA91bG5R0q84dBjUxKP2B8kFgW-yc2ymvI7-_1sVC8VQPO0zQ-4CRdBjqjRpMRhNmc3zuvzkoCPsTk0ubVHAhgWtZQl5Id0UbVQVQqWuzVkX-rA4ziTjgqR2HfrTJ89tP_oUYXwx-Yq";
String userDropOffAddress = "";
String driverCarDetail = "";
String driverName = "";
String driverPhone = "";
double countRatingStar = 0.0;
String titleStarRating = "";
String? geoin;
int driverRequestTimedOut = 10;
String driverID = "";
bool geostatus = false;
