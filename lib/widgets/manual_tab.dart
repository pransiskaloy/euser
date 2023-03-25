import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse(
    'https://drive.google.com/file/d/1d3Xn2U1g-BFuIP1EJ7inP047owOSsV-Z/view');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

class PassengerManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("images/intro.png"),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  "Need Help?",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    textStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Press Continue to open User Manual.",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _launchUrl();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF4F6CAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // <-- Radius
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width * .4,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
