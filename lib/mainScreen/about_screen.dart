import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  //image or company logo
                  Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Image.asset("images/company.png"),
                    ),
                  ),
                  Text(
                    "ehatid",
                    style: GoogleFonts.balooBhai2(
                      letterSpacing: -7,
                      textStyle: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 3.0,
                            color: Color.fromARGB(123, 84, 84, 84),
                          ),
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 8.0,
                            color: Color.fromARGB(123, 84, 84, 84),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "In need of a convenient and hassle-free pet taxi service? ehatid is here to serve you! We have our professional pet-friendly drivers to accompany you and your pets wherever you go. May it be emergency vet visits, or just a stroll to the park, we got you! ehatid will help you get to where your pet needs to be with just a few taps.",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
