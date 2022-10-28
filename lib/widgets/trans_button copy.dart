import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final press;
  const TransparentButton({required this.text, required this.press});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.transparent,
        ),
        onPressed: press,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.blue,
            fontFamily: 'Muli',
          ),
        ),
      ),
    );
  }
}
