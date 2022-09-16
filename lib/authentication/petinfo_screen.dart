import 'package:euser/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  TextEditingController petRemarksTextEditingController = TextEditingController();

  List<String> petTypesList = ["Cat", "Dog", "Others"];
  String? selectedPetType;

  savePetInfo() {
    referencePet = FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid).child("Pet").push(); //create a new pet

    Map petInformationMap = {
      "pet_type": selectedPetType,
      "pet_name": petNameTextEditingController.text.trim(),
      "pet_color": petColorTextEditingController.text.trim(),
      "pet_breed": petBreedTextEditingController.text.trim(),
      "pet_remarks": petRemarksTextEditingController.text.trim(),
      "date_added": DateTime.now().toString(),
    };
    try {
      referencePet!.set(petInformationMap);

      Fluttertoast.showToast(
        msg: "Pet information has been saved!",
        backgroundColor: Colors.white,
        textColor: Colors.green,
      );
      Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset("images/logo.png"),
              ),
              const Text(
                "Pet Information",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFF4F6CAD),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: TextField(
                  controller: petNameTextEditingController,
                  style: const TextStyle(
                    color: Color(0xFF4F6CAD),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Pet's Name",
                    hintText: "Moley",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontSize: 15,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: TextField(
                  controller: petColorTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF4F6CAD),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Color",
                    hintText: "White",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontSize: 15,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: TextField(
                  controller: petBreedTextEditingController,
                  style: const TextStyle(
                    color: Color(0xFF4F6CAD),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Breed",
                    hintText: "Shitzu",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontSize: 15,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField(
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Color(0xFF4F6CAD),
                    size: 30,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Color(0xFF4F6CAD)),
                    ),
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade200,
                  hint: const Text(
                    "Pet Type",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: TextField(
                  controller: petRemarksTextEditingController,
                  style: const TextStyle(
                    color: Color(0xFF4F6CAD),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Remarks",
                    hintText: "Cute, like snowball..",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontSize: 15,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
                  if (petBreedTextEditingController.text.isNotEmpty && petColorTextEditingController.text.isNotEmpty && petNameTextEditingController.text.isNotEmpty && petRemarksTextEditingController.text.isNotEmpty) {
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
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
