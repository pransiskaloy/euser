import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailTextEditingController = TextEditingController();

  validateForm(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailTextEditingController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content:
                  Text('Reset Password link sent. Kindly check your email'),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Enter Email',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Muli', fontSize: 24),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                validateForm(context);
              },
              color: Colors.blue,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
