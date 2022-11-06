import 'package:euser/global/global.dart';
import 'package:euser/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetInformation extends StatefulWidget {
  const PetInformation({Key? key}) : super(key: key);

  @override
  State<PetInformation> createState() => _PetInformationState();
}

class _PetInformationState extends State<PetInformation> {
  TextEditingController petQuantity = TextEditingController();
  TextEditingController petDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Pet Information',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Muli', fontSize: 25),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: petQuantity,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.queue_play_next_outlined,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    filled: true,
                    hintText: "ex. 2",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Pet Quantity",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                maxLines: 10,
                controller: petDescription,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.description,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    filled: true,
                    hintText: "ex. 1 Dog 1 Cat",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Desrciption",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                var value = petQuantity.text.trim();
                var value2 = petDescription.text.trim();
                print(value);
                print(value2);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => MainScreen(
                            petQuantity: value, petDescription: value2)));
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF4F6CAD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // <-- Radius
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .4,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Proceed",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      letterSpacing: 1,
                      fontSize: 20,
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
