import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:euser/assistants/assistant_methods.dart';
import 'package:euser/assistants/geofire_assistant.dart';
import 'package:euser/global/global.dart';
import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/main.dart';
import 'package:euser/mainScreen/Search_folder/_normal_search/search_places_screen.dart';
import 'package:euser/mainScreen/Search_folder/_normal_search/user_search.dart';
import 'package:euser/mainScreen/car_type.dart';
import 'package:euser/mainScreen/chat_screen.dart';
import 'package:euser/mainScreen/rate_driver_screen.dart';
import 'package:euser/models/active_nearby_available_drivers.dart';
import 'package:euser/splashScreen/splash_screen.dart';
import 'package:euser/widgets/divider.dart';
import 'package:euser/widgets/main_button.dart';
import 'package:euser/widgets/no_driver.dart';
import 'package:euser/widgets/pay_fare_amount_dialog.dart';
import 'package:euser/widgets/progress_dialog.dart';
import 'package:euser/widgets/trip_cancelation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.1907, 125.4553),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey =
      GlobalKey<ScaffoldState>(); //this is for button drawer
  double searchLocationContainerHeight = 0;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  bool getLocation = true;
  bool showTopnavi = true;
  bool showCancel = true;
  bool isRequest = true;

  Position? userCurrentPosition;
  var geolocator = Geolocator();
  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;
  int counter = 0;
  List<LatLng> polyLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  Key? key;
  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon; // for changing icon that appears on map
  List<ActiveNearbyAvailableDrivers> onlineNearbyAvailableDriversList = [];
  DatabaseReference? referenceRideRequest;
  String appState = 'Normal';
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoSubscription;
  String userRideRequestStatus = "";
  bool requestPositionInfo = true;
  //----------------->>>>>
  double searchSheet = 340;
  double tripDetailSheet = 0;
  double loadingTrip = 0;
  double tripSheet = 0;
  double mapPadding = 0;

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    Geofire.initialize("activeDrivers");
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearbyDriverIconMarker(); //method for changing driver's marker to a car icon.

    return Scaffold(
      key: sKey,
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: onMapCreated,
          ),

          //Top NAvigation --------------------------------------->
          (showTopnavi)
              ? Positioned(
                  top: 44,
                  left: 18,
                  child: GestureDetector(
                    onTap: () {
                      if (isRequest) {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => MySplashScreen()));
                      } else {
                        //Second Argument RESET APP
                        resetapp();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7))
                          ]),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(
                          (isRequest) ? Icons.arrow_back : Icons.arrow_back_ios,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  child: Container(
                    height: 0,
                  ),
                ),
//==================SearchSHeet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: searchSheet,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            const Text(
                              'Hey There!',
                              style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Where are we heading?',
                              style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                var response = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UserSearch()));
                                if (response == 'getDirections') {
                                  showtripDetailsheet();
                                  if (geostatus == false) {
                                    initializeGeoFireListener();
                                    setState(() {
                                      geostatus = true;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5.0,
                                          spreadRadius: 0.5,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.search,
                                        color: Colors.blueAccent,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Input Destination',
                                        style: TextStyle(fontFamily: 'Muli'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(
                                  Icons.pets,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () async {
                                    // var response = await Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             Searchvet()));
                                    // if (response == 'NearestVet') {
                                    //   showtripDetailsheet();
                                    //   if (geoStatus == null) {
                                    //     startGeofireListener();
                                    //     setState(() {
                                    //       geoStatus = true;
                                    //     });
                                    //   }
                                    // }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Veterinary',
                                        style: TextStyle(
                                            fontFamily: 'Muli', fontSize: 16),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Pick veterinary near you',
                                        style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontSize: 12,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomDivider(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.shop,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () async {
                                    // var response = await Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             PetSearch()));
                                    // if (response == 'PetStore') {
                                    //   showtripDetailsheet();
                                    //   if (geoStatus == null) {
                                    //     startGeofireListener();
                                    //     setState(() {
                                    //       geoStatus = true;
                                    //     });
                                    //   }
                                    // }
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Pet Shop',
                                          style: TextStyle(
                                              fontFamily: 'Muli', fontSize: 16),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'Pick pet shop near you',
                                          style: TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize: 12,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomDivider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
//=================Trip DetailSHeet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: tripDetailSheet,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.green[100],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/man-carrying-a-dog-with-a-belt-to-walk.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (tripDirectionDetailsInfo != null)
                                              ? tripDirectionDetailsInfo!
                                                  .duration_text!
                                              : 'Duration Text',
                                          style: const TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          (tripDirectionDetailsInfo != null)
                                              ? tripDirectionDetailsInfo!
                                                  .distance_text!
                                              : 'Distance Text',
                                          style: const TextStyle(
                                            fontFamily: 'Muli',
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      (tripDirectionDetailsInfo != null)
                                          ? 'Php${AssistantMethods.estimatedFare(tripDirectionDetailsInfo!)}'
                                          : 'Php2',
                                      style: const TextStyle(
                                        fontFamily: 'Muli',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.money,
                                    size: 18,
                                    color: Colors.green[400],
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'Cash',
                                    style: TextStyle(fontFamily: 'Muli'),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.grey, size: 16),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            //------>//Button for Driver Request
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: MainButton(
                                title: 'Proceed',
                                color: Colors.blue.shade400,
                                onpress: () async {
                                  var response = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          CarType());
                                  if (response == 'Start') {
                                    setState(() {
                                      appState = 'Requesting';
                                    });
                                    showLoadingTrip();
                                    onlineNearbyAvailableDriversList =
                                        GeoFireAssistant
                                            .activeNearbyAvailableDriversList;
                                    findDriver();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
// ===============Finding Driver Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: loadingTrip,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: TextLiquidFill(
                                text: 'Finding Your Driver.....',
                                waveColor: Colors.greenAccent.shade400,
                                boxBackgroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Muli',
                                  fontWeight: FontWeight.bold,
                                ),
                                boxHeight: 40,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                //Cancel Request
                                cancelRequest();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Icon(Icons.close, size: 25),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
// =============== Trip Detail SHeeet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: tripSheet,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  driverRideStatus,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Muli',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomDivider(),
                            const SizedBox(height: 10),
                            Text(
                              driverCarDetail,
                              style: TextStyle(
                                fontFamily: 'Muli',
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              driverName,
                              style: const TextStyle(
                                fontFamily: 'Muli',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomDivider(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //Messege Driver
                                (showCancel == true)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // showDialog(
                                              //     context: context,
                                              //     barrierDismissible: false,
                                              //     builder:
                                              //         (BuildContext context) =>
                                              //             ChatRoomList(
                                              //                 tripID:
                                              //                     tripRef.key));
                                              // print("TRIP ID: " + tripRef.key);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25)),
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              child: const Icon(Icons.call),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Messege',
                                            style: TextStyle(
                                                fontFamily: 'Muli',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                      ),
                                //Driver Info
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25)),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: const Icon(Icons.list),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Driver Info',
                                      style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                //Cancel
                                (showCancel == true)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              var result = await showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext
                                                          context) =>
                                                      TripCancelationDialog());
                                              if (result == 'proceed') {
                                                referenceRideRequest!
                                                    .onDisconnect();
                                                tripRideRequestInfoSubscription!
                                                    .cancel();
                                                driverlocation = null;
                                                getLocation = true;
                                                referenceRideRequest!
                                                    .child('status')
                                                    .set('Canceled');
                                                MyApp.restartApp(context);
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25)),
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              child: const Icon(Icons.clear),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontFamily: 'Muli',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
//==============BAgas Design
          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(
                milliseconds: 120,
              ),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0, left: 10),
                        child: Text(
                          "From",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 9.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Provider.of<AppInfo>(context)
                                              .userPickUpLocation !=
                                          null
                                      ? (Provider.of<AppInfo>(context)
                                                  .userPickUpLocation!
                                                  .locationName!
                                                  .length >
                                              25
                                          ? (Provider.of<AppInfo>(context)
                                                      .userPickUpLocation!
                                                      .locationName!)
                                                  .substring(0, 26) +
                                              "..."
                                          : Provider.of<AppInfo>(context)
                                              .userPickUpLocation!
                                              .locationName!)
                                      : "Fetching Current Address",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0, left: 10),
                        child: Text(
                          "To",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print(
                              'FIREHLEPR Entered LENGHT: ${GeoFireAssistant.activeNearbyAvailableDriversList.length}');
                          //search places screen
                          var responseFromSearchScreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropOff") {
                            await drawPolyLineFromOriginToDestination();
                            if (geostatus == false) {
                              initializeGeoFireListener();
                              setState(() {
                                geostatus = true;
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 9.0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_location_rounded,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Provider.of<AppInfo>(context)
                                                .userDropOffLocation
                                                ?.locationName !=
                                            null
                                        ? (Provider.of<AppInfo>(context)
                                                    .userDropOffLocation!
                                                    .locationName!
                                                    .length >
                                                25
                                            ? (Provider.of<AppInfo>(context)
                                                        .userDropOffLocation!
                                                        .locationName!)
                                                    .substring(0, 26) +
                                                "..."
                                            : Provider.of<AppInfo>(context)
                                                .userDropOffLocation!
                                                .locationName!)
                                        : "Choose drop-off location",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (Provider.of<AppInfo>(context, listen: false)
                                    .userDropOffLocation
                                    ?.locationName !=
                                null) {
                              var response = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => CarType());
                              if (response == 'Start') {
                                setState(() {
                                  appState = 'Requesting';
                                });
                                showWaitingResponseFromDriverUi();
                                onlineNearbyAvailableDriversList =
                                    GeoFireAssistant
                                        .activeNearbyAvailableDriversList;
                                findDriver();
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please select drop-off location!",
                                textColor: Colors.red,
                                backgroundColor: Colors.black87,
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Request a Ride",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          //ui for waiting response from driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(5),
                  //   child: const CircularProgressIndicator(
                  //     valueColor: AlwaysStoppedAnimation(Colors.blue),
                  //   ),
                  // ),
                  Image.asset(
                    "images/loading.gif",
                    width: 200,
                    height: 200,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Waiting for driver's response.",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 22,
                                color: Color(0xFF4F6CAD),
                                fontWeight: FontWeight.w300)),
                      ),
                      Text(
                        "Please wait....",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 22,
                                color: Color(0xFF4F6CAD),
                                fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //ui for assigned driver information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF4F6CAD)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    Text(
                      "Driver's Name",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF4F6CAD),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      driverName,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF4F6CAD),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Vehicle Model",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF4F6CAD),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      driverCarDetail,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF4F6CAD),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (b) => ChatScreen(
                                        userRideRequestDetails:
                                            referenceRideRequest!.key)));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(50), // <-- Radius
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_rounded,
                              color: Colors.white, size: 22),
                          label: Text(
                            "Chat",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // ElevatedButton.icon(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     primary: Colors.blue,
                        //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(50), // <-- Radius
                        //     ),
                        //   ),
                        //   icon: const Icon(Icons.phone_android_rounded, color: Colors.white, size: 22),
                        //   label: Text(
                        //     "Call",
                        //     style: GoogleFonts.poppins(
                        //       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Trip sheet UI
  void showTripsheet() {
    setState(() {
      loadingTrip = 0;
      tripSheet = 340;
      mapPadding = 340;
    });
  }

  //Loading Trip UI'
  void showLoadingTrip() {
    setState(() {
      tripDetailSheet = 0;
      loadingTrip = 250;
      mapPadding = 250;
      showTopnavi = false;
    });
    createTripRequest();
  }

  //Show Trip Detail SHeet
  void showtripDetailsheet() async {
    await drawPolyLineFromOriginToDestination();
    setState(() {
      searchSheet = 0;
      tripDetailSheet = 280;
      mapPadding = 280;
      isRequest = false;
    });
  }

  void resetapp() {
    setState(() {
      polyLineCoOrdinatesList.clear();
      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      tripDetailSheet = 0;
      loadingTrip = 0;
      searchSheet = 340;
      mapPadding = 340;
      isRequest = true;
      showTopnavi = true;
      tripSheet = 0;
      counter = 0;
      driverRideStatus = "Driver is Coming";
      driverCarDetail = "";
      driverName = "";
      driverPhone = "";
    });
    locateUserPosition();
  }

  showUiForAssignedDriver() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 0;
      assignedDriverInfoContainerHeight = 330;
    });
  }

  showWaitingResponseFromDriverUi() {
    setState(() {
      assignedDriverInfoContainerHeight = 0;
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 330;
    });
    createTripRequest();
  }

  // onMapCreated
  void onMapCreated(GoogleMapController controller) {
    _controllerGoogleMap.complete(controller);
    newGoogleMapController = controller;
    setState(() {
      mapPadding = 340;
    });
    locateUserPosition();
  }

  //Getting Direction Drawing Polylines
  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(double.parse(originPosition!.locationLatitude!),
        double.parse(originPosition.locationLongitude!));
    var destinationLatLng = LatLng(
        double.parse(destinationPosition!.locationLatitude!),
        double.parse(destinationPosition.locationLongitude!));
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });
    Navigator.pop(context);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList =
        polylinePoints.decodePolyline(directionDetailsInfo!.e_points!);
    polyLineCoOrdinatesList.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        width: 5,
        color: const Color.fromARGB(255, 219, 63, 52),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyLineSet.add(polyline);
    });
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 90));
    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow: InfoWindow(
          title: originPosition.locationName, snippet: "Destination"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
    Circle originCircle = Circle(
        circleId: const CircleId("originID"),
        fillColor: Colors.blue,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: originLatLng);
    Circle destinationCircle = Circle(
        circleId: const CircleId("destinationID"),
        fillColor: Colors.green,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: destinationLatLng);
    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

//Setting up current Location
  void locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoordinates(
            userCurrentPosition!, context);
    AssistantMethods.readTripKeysForOnlineUser(context);
  }

  //Display all nearby active-online drivers
  void initializeGeoFireListener() {
    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 3)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any driver turn online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
              print(
                  'FIREHLEPR Entered LENGHT: ${GeoFireAssistant.activeNearbyAvailableDriversList.length}');
            }
            break;

          //whenever any driver turn offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            if (counter > 0) {
              counter--;
            }
            displayActiveDriversOnUsersMap();
            print(
                'FIREHLEPR Entered LENGHT: ${GeoFireAssistant.activeNearbyAvailableDriversList.length}');
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            print(
                'FIREHLEPR Entered LENGHT: ${GeoFireAssistant.activeNearbyAvailableDriversList.length}');
            break;

          //display all nearby active-online drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            print(
                'FIREHLEPR Entered LENGHT: ${GeoFireAssistant.activeNearbyAvailableDriversList.length}');
            break;
        }
      }

      setState(() {});
    });
  }

//Create Trip Request in database
  createTripRequest() {
    referenceRideRequest = FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .push(); //create a new personal ride request

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userId": currentFirebaseUser!.uid,
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
      "status": "pending",
      "uid": referenceRideRequest!.key
    };

    referenceRideRequest!.set(userInformationMap);
    tripRideRequestInfoSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          driverCarDetail =
              (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);
        driverlocation =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);
        if (getLocation == true) {
          getLocationUpdate();
          getLocation = false;
        }

        //if status in ride request is accepted
        if (userRideRequestStatus == "accepted") {
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }
        //if status in ride request is arrived
        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "Driver has arrived";
          });
        }
        //if status in ride request is ontrip
        if (userRideRequestStatus == "ontrip") {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
          showCancel = false;
        }

        if (userRideRequestStatus == "accepted") {
          showTripsheet();
          removeGeofireMarkers();
        }
        //if status in ride request is ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["end_trip"]["fare_amount"] !=
              null) {
            double fareAmount = double.parse(
                (eventSnap.snapshot.value as Map)["end_trip"]["fare_amount"]
                    .toString());

            var response = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext c) => PayFareAmountDialog(
                fareAmount: fareAmount,
              ),
            );

            if (response == "cashPayed") {
              //user can rate the driver
              if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                String assignedDriverId =
                    (eventSnap.snapshot.value as Map)["driverId"].toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => RateDriverScreen(
                      assignedDriverId: assignedDriverId,
                      referenceRideRequest: referenceRideRequest!.key,
                    ),
                  ),
                );

                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoSubscription!.cancel();
                driverlocation = null;
                getLocation = true;
                resetapp();
                setState(() {
                  showCancel = true;
                });
              }
            }
          }
        }
      }
    });
  }

  //Removing Markers on the map
  void removeGeofireMarkers() {
    setState(() {
      markersSet.removeWhere((m) => m.markerId.value.contains('driver'));
    });
  }

  //Create Moving Markers
  void createActiveNearbyDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  //Getting Driver Location realtime
  void getLocationUpdate() {
    streamSubscriptionDriverLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      LatLng latLngDriverPosition = LatLng(
        driverlocation!.latitude,
        driverlocation!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngDriverPosition,
        icon: activeNearbyIcon!,
        infoWindow: const InfoWindow(title: "This is your position."),
      );

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngDriverPosition, zoom: 19);
        newGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markersSet
            .remove((element) => element.markerId.value == "AnimatedMarker");
        markersSet.add(animatingMarker);
      });
    });
  }

  void updateReachingTimeToUserDropOffLocation(
      driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
      LatLng userDestinationPosition = LatLng(
          double.parse(dropOffLocation!.locationLatitude!),
          double.parse(dropOffLocation.locationLongitude!));

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
              driverCurrentPositionLatLng, userDestinationPosition);

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Reach destination in " +
            directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  void updateArrivalTimeToUserPickupLocation(
      driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      LatLng userPickupPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
              driverCurrentPositionLatLng, userPickupPosition);

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Driver will arrive in " +
            directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  //Cancel Trip Request
  void cancelRequest() {
    referenceRideRequest!.remove();
    resetapp();
    setState(() {
      appState = 'Normal';
    });
  }

  void displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();
      Set<Marker> driversMarkerSet = Set<Marker>();
      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }
      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  void findDriver() {
    if (onlineNearbyAvailableDriversList.isEmpty) {
      cancelRequest();
      noDriversFound();
    } else if (onlineNearbyAvailableDriversList.length < counter + 1) {
      cancelRequest();
      noDriversFound();
    }
    var driver = onlineNearbyAvailableDriversList[counter];
    notifyDriver(driver);
  }

  void noDriversFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriver());
  }

  void notifyDriver(ActiveNearbyAvailableDrivers nearbyDriver) {
    print(' ------------------------------------------------->INSIDE');
    DatabaseReference driverType = FirebaseDatabase.instance
        .ref()
        .child('drivers/${nearbyDriver.driverId}/car_details/car_type');
    driverType.once().then((snap) {
      if (snap.snapshot.value != null) {
        String type = snap.snapshot.value.toString();
        //Check for car Type
        if (geoin == type) {
          print('COunter status ----- $counter');
          print('Current Drive ID ----- ${nearbyDriver.driverId}');
          counter++;
          DatabaseReference driverTripRef = FirebaseDatabase.instance
              .ref()
              .child('drivers/${nearbyDriver.driverId}/newRideRequest');
          driverTripRef.set(referenceRideRequest!.key);
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(nearbyDriver.driverId.toString())
              .child("newRideStatus")
              .set(referenceRideRequest!.key);
          //Getting Driver Token
          DatabaseReference driverTokenRef = FirebaseDatabase.instance
              .ref()
              .child('drivers/${nearbyDriver.driverId}/token');
          driverTokenRef.once().then((snap) {
            if (snap.snapshot.value != null) {
              String driverToken = snap.snapshot.value.toString();
              AssistantMethods.sendNotificationToDriverNow(
                  driverToken, referenceRideRequest!.key.toString(), context);
              print(
                  '---------------------------------->Token sa driber $driverToken');
            } else {
              return;
            }
            const oneSeckTick = Duration(seconds: 1);
            Timer.periodic(oneSeckTick, (timer) async {
              //Stopping the timer when the Passenger cancelled the trip request
              if (appState != 'Requesting') {
                driverTripRef.set('Canceled');
                driverTripRef.onDisconnect();
                timer.cancel();
                driverRequestTimedOut = 10;
              }
              driverRequestTimedOut--;

              //If the Driver Accepts the Request
              driverTripRef.onValue.listen((event) {
                if (event.snapshot.value.toString() == 'accepted') {
                  driverTripRef.onDisconnect();
                  timer.cancel();
                  counter = 0;
                  driverID = nearbyDriver.driverId.toString();
                  print('Current Driver ID >>> $driverID');
                  print(
                      'Current Counter .... $counter and available drivers ${onlineNearbyAvailableDriversList.length}');
                  driverRequestTimedOut = 10;
                }
              });
              if (driverRequestTimedOut == 0) {
                driverTripRef.set('timeout');
                driverTripRef.onDisconnect();
                driverRequestTimedOut = 10;
                timer.cancel();
                print('Current Counter timed out.... $counter');
                findDriver();
              }
            });
          });
        } else {
          print('COunter status ----- $counter');
          counter++;
          findDriver();
        }
      }
    });
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }
}
