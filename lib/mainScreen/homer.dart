import 'package:euser/assistants/assistant_methods.dart';
import 'package:euser/mainScreen/main_screen.dart';
import 'package:euser/mainScreen/profile_screen.dart';
import 'package:euser/mainScreen/trip_history_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.readCurrentOnlineUserInfo();
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
                          color: Colors.black,
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
                      // Icon(
                      //   Icons.more_horiz,
                      //   color: Colors.grey[800],
                      // ),
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
                            category: 'Set Trip',
                            color: Colors.white,
                            image: 'images/new_trip.png',
                            onTap: () {
                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     builder: (BuildContext context) =>
                              //         ChooseRideType());
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
                            },
                          ),
                          buildPetCategory(
                            category: 'Profile',
                            color: Colors.white,
                            image: 'images/user.png',
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => ProfileScreen()));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildPetCategory(category: 'Wallet', color: Colors.white, image: 'images/wallet.png', onTap: () {}),
                          buildPetCategory(
                            category: 'History',
                            color: Colors.white,
                            image: 'images/history.png',
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (c) => const TripHistoryScreen()));
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
                      // Icon(
                      //   Icons.more_horiz,
                      //   color: Colors.grey[800],
                      // ),
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
                          buildPetCategory(category: 'Support', color: Colors.white, image: 'images/wallet.png', onTap: () {}),
                          buildPetCategory(
                            category: 'Log out',
                            color: Colors.white,
                            image: 'images/history.png',
                            onTap: () {
                              fAuth.signOut();
                            },
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
    );
  }

  Widget buildPetCategory({String? category, String? image, Color? color, onTap}) {
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
