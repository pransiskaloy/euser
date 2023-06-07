import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowBottomModal {
  void bottomModal(BuildContext context, str) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20),
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                Lottie.asset(str, height: 220, width: 220),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Lost Connection",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )
                // ListTile(
                //   leading: Icon(Icons.share),
                //   title: Text(str),
                //   onTap: () {
                //     // Handle the share action
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.delete),
                //   title: Text(str),
                //   onTap: () {
                //     // Handle the delete action
                //     Navigator.pop(context);
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
