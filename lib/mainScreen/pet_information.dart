import 'package:euser/global/global.dart';
import 'package:euser/mainScreen/main_screen.dart';
import 'package:euser/widgets/keyboard.dart';
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

  validateForm(BuildContext context) {
    if (petQuantity.text.isEmpty) {
      showToaster(context, "Please enter a valid Quantity", 'Error');
    } else if (petDescription.text.isEmpty) {
      showToaster(context, "Please say anything", 'Error');
    } else {
      var value = petQuantity.text.trim();
      var value2 = petDescription.text.trim();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) =>
                  MainScreen(petQuantity: value, petDescription: value2)));
    }
  }

  void showToaster(BuildContext context, String str, String status) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          str,
          style: status == "success"
              ? const TextStyle(color: Colors.green, fontSize: 15)
              : const TextStyle(color: Colors.red, fontSize: 15),
        ),
        action: SnackBarAction(
            label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    petQuantity.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pet Information',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Muli', fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 9.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          "images/quantity.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "No. of Pet",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    // padding: const EdgeInsets.all(15),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: petQuantity,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 30),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                          ),
                          filled: true,
                          hintText: "0",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 172, 170, 170),
                            letterSpacing: 1.5,
                          ),
                          fillColor: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 9.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: Image.asset(
                          "images/notes.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .89,
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      maxLines: 9,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 18)),
                      controller: petDescription,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 20, top: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Color(0xFF4F6CAD)),
                          ),
                          filled: true,
                          hintText: "Desrciption",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 172, 170, 170),
                            letterSpacing: 1.5,
                          ),
                          fillColor: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                KeyboardUtil.hideKeyboard(context);
                validateForm(context);
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
