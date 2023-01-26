import 'package:euser/authentication/login_screen.dart';
import 'package:euser/authentication/petinfo_screen.dart';
import 'package:euser/splashScreen/splash_screen.dart';
import 'package:euser/widgets/keyboard.dart';
import 'package:euser/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmpasswordTextEditingController =
      TextEditingController();
  bool _passwordVisible = false;

  validateForm(BuildContext context) {
    if (nameTextEditingController.text.length < 5) {
      showToaster(context, "Full Name must be at least 5 characters", 'fail');
    } else if (!emailTextEditingController.text.contains("@") ||
        !emailTextEditingController.text.contains(".")) {
      showToaster(context, "Please enter a valid email", 'fail');
    } else if (phoneTextEditingController.text.length < 11 ||
        phoneTextEditingController.text.length > 11) {
      showToaster(context, "Phone must have 11 digit number", 'fail');
    } else if (passwordTextEditingController.text.length < 6) {
      showToaster(context, "Password must be at least 6 characters", 'fail');
    } else if (passwordTextEditingController.text !=
        confirmpasswordTextEditingController.text) {
      showToaster(context, "Password do not match please try again", 'fail');
    } else {
      saveUserInfo();
    }
  }

  saveUserInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Processing . . .",
        );
      },
    );
    try {
      final User? firebaseUser = (await fAuth
              .createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      )
              .catchError((msg) {
        Navigator.pop(context);
        showToaster(context, "Error: " + msg.toString(), 'fail');
      }))
          .user;
      if (firebaseUser != null) {
        Map userMap = {
          "uid": firebaseUser.uid,
          "name": nameTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "password": passwordTextEditingController.text.trim(),
          "date_created": DateTime.now().toString(),
          "status": "active",
        };
        DatabaseReference driversRef =
            FirebaseDatabase.instance.ref().child("users");
        driversRef.child(firebaseUser.uid).set(userMap);

        currentFirebaseUser = firebaseUser;
        Fluttertoast.showToast(
          msg: "Account information has been saved!",
          backgroundColor: Colors.white,
          textColor: Colors.green,
        );
        // Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const PetInfoScreen()));
      } else {
        Navigator.pop(context);
        showToaster(context, "Account has not been Created.", "fail");
      }
    } on Exception catch (exe) {
      Fluttertoast.showToast(
        msg: "Email is existing. Please use different email.",
        backgroundColor: Colors.black87,
        textColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "E-hatid is not available for a moment.",
        backgroundColor: Colors.black87,
        textColor: Colors.red,
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("images/register.png"),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: nameTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.person_rounded,
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
                    hintText: "Full Name...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Full Name",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.mail_rounded,
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
                    hintText: "Email...",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Email",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: phoneTextEditingController,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.phone_rounded,
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
                    hintText: "09x-xxxx-xxx",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Phone",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF4F6CAD),
                          size: 20,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
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
                    hintText: "*******",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .93,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: confirmpasswordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF4F6CAD),
                        size: 20,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF4F6CAD),
                          size: 20,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
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
                    hintText: "*******",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 172, 170, 170),
                      letterSpacing: 1.5,
                    ),
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 18,
                    ),
                    fillColor: Colors.white70),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFF4F6CAD),
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                  child: Text("Login here",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Color(0xFF4F6CAD),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'By clicking Sign Up, you agree to our',
              style: GoogleFonts.poppins(textStyle: const TextStyle(color: Color(0xFF4F6CAD), fontSize: 15)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text(
                    ' Terms and Conditions',
                    style: GoogleFonts.poppins(textStyle: const TextStyle(color: Color(0xFF4F6CAD), fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding:const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Terms & Conditions",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "General Terms",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "By registering and using E-hatid, you confirm that you are in agreement with and bound by the terms of service contained in the Terms & Conditions outlined below. These terms apply to the entire system and any email or other type of communication between you and Ehatid.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Under no circumstances shall E-hatid team be liable for any direct, indirect, special, incidental or consequential damages, including, but not limited to, loss of data or profit, arising out of the use, or the inability to use, the materials on this app, even if E-hatid  team or an authorized representative has been advised of the possibility of such damages. If your use of materials from this app results in the need for servicing, repair or correction of equipment or data, you assume any costs thereof.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "E-hatid will not be responsible for any outcome that may occur during the course of usage of our resources. We reserve the rights to change the fare rates in accordance with government laws and revise the resources usage policy in any moment.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "License",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "E-hatid grants you a revocable, non-exlusive, non-transferrable, limited license to download, install and use the app strictly in accordance with the terms of this Agreement. These Terms & Conditions are a contract between you and E-hatid; you are granted a revocable, non-exclusive, non-transferable, limited license to download, install and use the app strictly in accordance with the terms of this Agreement.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Definitions and key terms",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "For this Terms & Conditions:",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Company: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "when this policy mentions 'Company,' 'we,' 'us,' or 'our,' it refers to Team Badula that is responsible for your information under this Privacy Policy.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Country: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "where E-hatid or the owners/founders of E-hatid are based, in this case is Philippines.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Customer: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "refers to the person that signs-up to use the E-hatid Service.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Device: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "any internet connected device such as a smartphone, tablet, computer, or any other device that can be used to use E-hatid and its services.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Administrator: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "refers to individuals who manage E-hatid or are under authority to perform a service on behalf of one of the parties.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Personal Data: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "any information that directly, indirectly, or in connection with other information - including a personal identification number - allows for the identification or identifiability of a natural person.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "refers to the service provided by E-hatid as described on this platform.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "You: ",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "a person that is registered with E-hatid to use the Services.",
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),),
                                const SizedBox(height: 10,),
                                Text(
                                  "Restrictions",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "You agree not to, and you will not permit others to:",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0),
                                  child: Text(
                                    "- License, sell, rent, leave, assign, distribute, or commercially exploit the service or make the platform available to any third party.",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0),
                                  child: Text(
                                    "- Modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of the service.",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                    )),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Your Consent",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "We have updated our Terms & Conditions to provide you with complete transparency into what is being set when you use our app. By using our service, registering an account, you hereby consent to our Terms & Conditions.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Changes To Our Terms & Conditions",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "You acknowledge and agree that we may stop (permanently or temporarily) providing the Service (or any features within the Service) to you or to users generally at our sole discretion, without prior notice to you. You may stop using the Service at any time. You do not need to specifically inform us when you stop using the Service. You acknowledge and agree that if we disable access to your account, you may be prevented from accessing the Service, your account details or any files or other materials which is contained in your account.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  "If we decide to change our Terms & Conditions, we will post those changes on this page, and/or update the Terms & Conditions modification date below.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Limitation of Liability",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "Notwithstanding any damages that you might incur, the entire liability of us and any of our drivers under any provision of this Agreement and your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by you for the service.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  "To the maximum extent permitted by applicable law, in no event shall we or our drivers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, for loss of data or other information, for business interruption, for personal injury, for loss of privacy arising out of or in any way related to the use of or inability to use the service, third-party software and/or third-party hardware used with the service, or otherwise in connection with any provision of this Agreement), even if we has been advised of the possibility of such damages and even if the remedy fails of its essential purpose.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Disclaimer",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "Our Service and its contents are provided 'as is' and 'as available' without any warranty or representations of any kind, whether express or implied. Without limiting the foregoing, We specifically disclaim all warranties and representations in any content transmitted on or in connection with our Service or on sites that may appear as links on our Service, or in the products provided as a part of, or otherwise in connection with, our Service, including without limitation any warranties of merchantability, fitness for a particular purpose or non-infringement of third party rights. No oral advice or written information given by us or any of its affiliates, employees, officers, directors, agents, or the like will create a warranty. Price and availability information is subject to change without notice. Without limiting the foregoing, we do not warrant that our Service will be uninterrupted, uncorrupted, timely, or error-free.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Contact Us",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "Don't hesitate to contact us if you have any questions.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Via cellphone number: 09813729866",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  "Via email: iitzbadula@gmail.com",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Text(
                  ', and',
                  style: GoogleFonts.poppins(textStyle: const TextStyle(color: Color(0xFF4F6CAD), fontSize: 15)),
                ),
                GestureDetector(
                  child: Text(
                    ' Privacy Policy.',
                    style: GoogleFonts.poppins(textStyle: const TextStyle(color: Color(0xFF4F6CAD), fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  onTap: (){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding:const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Ehatid Data Privacy Notice",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Personal Information",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "We collect the personal information from you when you electronically submit the following, but not limited to:",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0),
                                  child: Text(
                                    "- Full Name\n- Address\n- Contact Number\n- Email\n- Face/Photo\n- Driver's License\n- Car Information",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                    )),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Use",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "All information we collect is kept private and confidential and shall be used solely for legal purposes as mandated by the Data Privacy Act and other relevant laws. Information that are matters of public interest, however, may be disclosed to the public subject to applicable laws, rules, and regulations.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Protection Measures",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "Only E-hatid administrators has access to these personal information. Storage shall be within a period as may be authorized by law.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Contact Us",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      textStyle:const  TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    
                                  )),
                                ),
                                Text(
                                  "Don't hesitate to contact us if you have any questions.",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  "Via cellphone number: 09813729866",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                                Text(
                                  "Via email: iitzbadula@gmail.com",
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontSize: 20,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                KeyboardUtil.hideKeyboard(context);
                validateForm(context);
                // showToaster(context);
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
                  "Sign Up",
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
