import 'package:euser/global/global.dart';
import 'package:euser/main.dart';
import 'package:euser/widgets/keyboard.dart';
import 'package:euser/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileEdit extends StatefulWidget {
  final String title;
  final String edits;
  const ProfileEdit({
    required this.title,
    required this.edits,
  });
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool focus = false;
  var editable = FocusNode();
  @override
  void initState() {
    super.initState();
    print(widget.edits);
    currentFirebaseUser = fAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontFamily: 'Muli'),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              focusNode: editable,
              controller: _textController,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Muli'),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String value = _textController.text.toString();
                  if (value.isEmpty || value.length < 6) {
                    Fluttertoast.showToast(
                        msg: "Iput Not valid Try Again",
                        backgroundColor: Colors.white,
                        textColor: Colors.green,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP);
                  } else {
                    KeyboardUtil.hideKeyboard(context);
                    if (widget.edits == 'phone') {
                      editProfile(widget.edits, value);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Cannot Edit Profile",
                          backgroundColor: Colors.white,
                          textColor: Colors.green,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP);
                    }
                  }
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontFamily: 'Muli'),
              ),
            )
          ],
        )
      ],
    );
  }

  void setFocus() {
    if (!focus) {
      FocusScope.of(context).requestFocus(editable);
      focus = true;
    }
  }

  void editProfile(String path, String value) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              message: 'Loading.....',
            ));
    DatabaseReference editref = FirebaseDatabase.instance
        .ref()
        .child('users/${currentFirebaseUser!.uid}/$path');
    editref.once().then((snap) {
      if (snap.snapshot.value != null) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        MyApp.restartApp(context);
        editref.set(value);
        Fluttertoast.showToast(
            msg: "Profile Updated",
            backgroundColor: Colors.white,
            textColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        MyApp.restartApp(context);
        Fluttertoast.showToast(
            msg: "Error Cannot Update",
            backgroundColor: Colors.white,
            textColor: Colors.green,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }
}
