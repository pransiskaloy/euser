import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Color color;
  final String title;
  final onpress;

  const MainButton(
      {required this.color, required this.title, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpress,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          primary: color,
          textStyle: const TextStyle(color: Colors.white)),
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontFamily: 'Muli', fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
