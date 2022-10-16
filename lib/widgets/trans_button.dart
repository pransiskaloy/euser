import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String? text;
  final Function? press;
  const TransparentButton({
    this.text,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.transparent)))),
        onPressed: () {},
        child: Text(
          text!,
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
