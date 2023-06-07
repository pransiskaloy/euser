import 'package:euser/assistants/assistant_methods.dart';
import 'package:euser/mainScreen/main_screen.dart';
import 'package:euser/mainScreen/pet_information.dart';
import 'package:euser/mainScreen/profile_screen.dart';
import 'package:euser/mainScreen/trip_history_screen.dart';
import 'package:euser/splashScreen/splash_screen.dart';
import 'package:euser/widgets/manual_tab.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/bottomModal.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    AssistantMethods.readCurrentOnlineUserInfo();
    AssistantMethods.readTripKeysForOnlineUser(context);

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  ShowBottomModal showModal = ShowBottomModal();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      print(_connectionStatus.toString());
      if (_connectionStatus.toString() == "ConnectivityResult.none") {
        showModal.bottomModal(context, 'images/network.json');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "ehatid",
                      style: GoogleFonts.baloo2(
                        letterSpacing: -1,
                        textStyle: const TextStyle(
                          color: Color(0xFF4F6CAD),
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildPetCategory(
                            category: 'Book a Ride',
                            color: Colors.white,
                            image: 'images/new_trip.png',
                            onTap: () {
                              if (_connectionStatus.toString() !=
                                  "ConnectivityResult.none") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => PetInformation()));
                              } else {
                                showModal.bottomModal(
                                    context, 'images/network.json');
                              }
                            },
                          ),
                          buildPetCategory(
                            category: 'History',
                            color: Colors.white,
                            image: 'images/history.png',
                            onTap: () {
                              if (_connectionStatus.toString() !=
                                  "ConnectivityResult.none") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const TripHistoryScreen()));
                              } else {
                                showModal.bottomModal(
                                    context, 'images/network.json');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Options",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildPetCategory(
                            category: 'Profile',
                            color: Colors.white,
                            image: 'images/user.png',
                            onTap: () {
                              if (_connectionStatus.toString() !=
                                  "ConnectivityResult.none") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ProfileScreen()));
                              } else {
                                showModal.bottomModal(
                                    context, 'images/network.json');
                              }
                            },
                          ),
                          buildPetCategory(
                            category: 'Help',
                            color: Colors.white,
                            image: 'images/customer-service.png',
                            onTap: () {
                              if (_connectionStatus.toString() !=
                                  "ConnectivityResult.none") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            PassengerManual()));
                              } else {
                                showModal.bottomModal(
                                    context, 'images/network.json');
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildPetCategory(
                            category: 'Log out',
                            color: Colors.white,
                            image: 'images/exit.png',
                            onTap: () async {
                              if (_connectionStatus.toString() !=
                                  "ConnectivityResult.none") {
                                await fAuth.signOut();
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const MySplashScreen()));
                              } else {
                                showModal.bottomModal(
                                    context, 'images/network.json');
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPetCategory(
      {String? category, String? image, Color? color, onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color!.withOpacity(0.5),
                ),
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      image!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
