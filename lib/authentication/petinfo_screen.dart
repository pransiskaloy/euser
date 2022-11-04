import 'package:euser/global/global.dart';
import 'package:euser/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../splashScreen/splash_screen.dart';

class PetInfoScreen extends StatefulWidget {
  const PetInfoScreen({Key? key}) : super(key: key);

  @override
  State<PetInfoScreen> createState() => _PetInfoScreenState();
}

class _PetInfoScreenState extends State<PetInfoScreen> {
  DatabaseReference? referencePet;

  TextEditingController petNameTextEditingController = TextEditingController();
  TextEditingController petColorTextEditingController = TextEditingController();
  TextEditingController petBreedTextEditingController = TextEditingController();
  TextEditingController petRemarksTextEditingController =
      TextEditingController();

  List<String> petTypesList = ["Cat", "Dog", "Others"];
  String? selectedPetType;

  savePetInfo() {
    referencePet = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid)
        .child("Pet")
        .push(); //create a new pet

    Map petInformationMap = {
      "pet_type": selectedPetType,
      "pet_name": petNameTextEditingController.text.trim(),
      "pet_color": petColorTextEditingController.text.trim(),
      "pet_breed": petBreedTextEditingController.text.trim(),
      "pet_remarks": petRemarksTextEditingController.text.trim(),
      "date_added": DateTime.now().toString(),
      "status": "active",
    };
    try {
      referencePet!.set(petInformationMap);

      Fluttertoast.showToast(
        msg: "Pet information has been saved!",
        backgroundColor: Colors.white,
        textColor: Colors.green,
      );
      MyApp.restartApp(context);
    } on Exception catch (exe) {
      Fluttertoast.showToast(
        msg: exe.toString(),
        backgroundColor: Colors.black87,
        textColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.runtimeType.toString(),
        backgroundColor: Colors.black87,
        textColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("images/pet.png"),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: TextField(
                controller: petNameTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.pets_outlined,
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
                    hintText: "Moley",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Pet Name",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: TextField(
                controller: petColorTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.palette_outlined,
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
                    hintText: "White",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Color",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: TextField(
                controller: petBreedTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.category_outlined,
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
                    hintText: "Shitzu",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Breed",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: DropdownButtonFormField(
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF4F6CAD),
                  size: 30,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(
                      Icons.category_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                  ),
                ),
                isExpanded: true,
                dropdownColor: const Color.fromARGB(194, 255, 255, 255),
                hint: const Text(
                  "Pet Type",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF4F6CAD),
                  ),
                ),
                value: selectedPetType,
                onChanged: (newValue) {
                  setState(() {
                    selectedPetType = newValue.toString();
                  });
                },
                items: petTypesList.map((pet) {
                  return DropdownMenuItem(
                    child: Text(
                      pet,
                      style: const TextStyle(
                        color: Color(0xFF4F6CAD),
                      ),
                    ),
                    value: pet,
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: TextField(
                controller: petRemarksTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.notes,
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
                    hintText: "Cute, like snowball..",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Remarks",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
                if (petBreedTextEditingController.text.isNotEmpty &&
                    petColorTextEditingController.text.isNotEmpty &&
                    petNameTextEditingController.text.isNotEmpty &&
                    petRemarksTextEditingController.text.isNotEmpty) {
                  savePetInfo();
                } else {
                  Fluttertoast.showToast(
                    msg: "Please fill up all information!",
                    backgroundColor: Colors.black87,
                    textColor: Colors.red,
                  );
                }
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
                  "Save",
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
