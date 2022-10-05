import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDesign extends StatefulWidget {
  String? textInfo;
  IconData? iconData;

  InfoDesign({this.textInfo, this.iconData});

  @override
  State<InfoDesign> createState() => _InfoDesignState();
}

class _InfoDesignState extends State<InfoDesign> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.blue,
        ),
        title: Text(
          widget.textInfo!,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(55, 55, 61, 100),
            ),
          ),
        ),
      ),
    );
  }
}
