import 'package:euser/models/direction_details_info.dart';
import 'package:euser/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;

User? currentFirebaseUser;

UserModel? userModelCurrentInfo;

List dList = []; //driverKeys Info List for ride request

DirectionDetailsInfo? tripDirectionDetailsInfo; //for fare calculation
String? geoStatus;
