import 'package:euser/global/global.dart';
import 'package:euser/widgets/info_display.dart';
import 'package:euser/widgets/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text(
          "Back",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(55, 55, 61, 100)),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //name
          Text(
            userModelCurrentInfo!.name!,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(55, 55, 61, 100)),
            ),
          ),
          SizedBox(
            height: 10,
            width: MediaQuery.of(context).size.width * .5,
            child: const Divider(thickness: 2, color: Colors.white, height: 2),
          ),

          const SizedBox(height: 10),
          //phone
          GestureDetector(
              child: InfoDesign(
                textInfo: userModelCurrentInfo!.phone,
                iconData: Icons.phone_android_rounded,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ProfileEdit(
                            title: 'Edit Phone Number', edits: 'phone')));
              }),
          const SizedBox(height: 10),

          //email
          GestureDetector(
            child: InfoDesign(
              textInfo: userModelCurrentInfo!.email,
              iconData: Icons.mail_outline_rounded,
            ),
            onTap: () {
              Fluttertoast.showToast(
                  msg: "Cannot Edit Email",
                  backgroundColor: Colors.white,
                  textColor: Colors.green,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.TOP);
            },
          ),
        ],
      )),
    );
  }
}
