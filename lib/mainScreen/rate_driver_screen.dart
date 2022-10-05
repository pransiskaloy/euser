import 'package:euser/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;

  RateDriverScreen({this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 20),
            Text(
              "Rate Trip Experience",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F6CAD),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 22),
            SmoothStarRating(
              rating: countRatingStar,
              allowHalfRating: false,
              starCount: 5,
              size: 46,
              onRatingChanged: (valueOfStarsChose) {
                countRatingStar = valueOfStarsChose;
                if (countRatingStar == 1) {
                  setState(() {
                    titleStarRating = "Very Bad";
                  });
                }
                if (countRatingStar == 2) {
                  setState(() {
                    titleStarRating = "Bad";
                  });
                }
                if (countRatingStar == 3) {
                  setState(() {
                    titleStarRating = "Good";
                  });
                }
                if (countRatingStar == 4) {
                  setState(() {
                    titleStarRating = "Very Good";
                  });
                }
                if (countRatingStar == 5) {
                  setState(() {
                    titleStarRating = "Excellent";
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              titleStarRating,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 30, color: Color(0xFF4F6CAD)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref().child("drivers").child(widget.assignedDriverId!).child("ratings");
                rateDriverRef.once().then((snap) {
                  if (snap.snapshot.value == null) {
                    rateDriverRef.set(countRatingStar.toString());

                    SystemNavigator.pop();
                  } else {
                    double pastRating = double.parse(snap.snapshot.value.toString());
                    double totalRating = (pastRating + countRatingStar) / 2;

                    SystemNavigator.pop();
                  }

                  Fluttertoast.showToast(msg: "Please restart the app");
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // <-- Radius
                ),
              ),
              child: Text(
                "SUBMIT",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ]),
        ),
      ),
    );
  }
}
