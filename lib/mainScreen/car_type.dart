import 'package:euser/global/global.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarType extends StatefulWidget {
  const CarType({Key? key}) : super(key: key);

  @override
  State<CarType> createState() => _CarTypeState();
}

class _CarTypeState extends State<CarType> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Choose Car Type",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
                ),
              ),
              cars(() {
                setState(() {
                  geoin = 'Motorcycle';
                });
                Navigator.of(context).pop('Start');
              }, context, 'Motorcycle.png'),
              const SizedBox(
                height: 5,
              ),
              cars(() {
                setState(() {
                  geoin = 'Furfetch-go';
                });
                Navigator.of(context).pop('Start');
              }, context, 'Furfetch-go.png'),
              const SizedBox(
                height: 5,
              ),
              cars(() {
                setState(() {
                  geoin = 'Furfetch-x';
                });
                Navigator.of(context).pop('Start');
              }, context, 'Furfetch-x.png'),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: const BorderSide(color: Colors.transparent)))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      )),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cars(onpress, BuildContext context, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            primary: const Color.fromARGB(255, 238, 240, 245),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // <-- Radius
            ),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 70,
                width: 70,
                child: Image.asset("images/$image"),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image == "Motorcycle.png" ? "Motorcycle" : (image == "Furfetch-go.png" ? "Furfetch-go" : "Furfetch-x"),
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                  ),
                  Text(
                    image == "Motorcycle.png" ? "Small Vehicle " : (image == "Furfetch-go.png" ? "Medium Vehicle " : "Large Vehicle "),
                    style: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Php 40.00",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 219, 90, 90),
                    ),
                    // style: TextStyle(
                    // ),
                  ),
                ],
              ),
            ],
          ),
          onPressed: onpress,
        ),
      ),
    );
  }
}
