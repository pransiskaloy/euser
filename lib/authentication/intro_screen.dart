import 'package:euser/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "images/intro.png",
            ),
            Image.asset(
              "images/intro2.png",
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "Your pet's furfect ride.",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFF4F6CAD),
                    fontWeight: FontWeight.w200,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const LoginScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  width: MediaQuery.of(context).size.width * .4,
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // <-- Radius
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
