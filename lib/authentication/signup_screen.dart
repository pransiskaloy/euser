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
              height: 20,
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
