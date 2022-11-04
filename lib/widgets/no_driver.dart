import 'package:flutter/material.dart';

class NoDriver extends StatelessWidget {
  const NoDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'No Drivers Available',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Muli',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No available driver close by, try again shortly',
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        child: const Center(
                          child: Text('Close',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Muli',
                                  color: Colors.black87)),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
