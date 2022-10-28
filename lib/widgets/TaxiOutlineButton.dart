import 'package:flutter/material.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final onPressed;
  final Color color;

  TaxiOutlineButton(
      {required this.title, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            primary: color,
            onSurface: color),
        onPressed: onPressed,
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 15, fontFamily: 'Muli', color: Colors.black87)),
          ),
        ));
  }
}
