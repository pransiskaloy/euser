import 'package:euser/global/global.dart';
import 'package:flutter/material.dart';

class CarType extends StatefulWidget {
  const CarType({Key? key}) : super(key: key);

  @override
  State<CarType> createState() => _CarTypeState();
}

class _CarTypeState extends State<CarType> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  "Choose Car Type",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              cars(() {
                setState(() {
                  geoin = 'Motorcycle';
                });
                Navigator.of(context).pop('Start');
              }, context, 'Fsmall.png'),
              const SizedBox(
                height: 5,
              ),
              cars(() {
                setState(() {
                  geoin = 'Furfetch-go';
                });
                Navigator.of(context).pop('Start');
              }, context, 'Fmedium.png'),
              const SizedBox(
                height: 5,
              ),
              cars(() {
                setState(() {
                  geoin = 'Furfetch-x';
                });
                Navigator.of(context).pop('Start');
              }, context, 'FLarge.png'),
              const SizedBox(
                height: 45,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.transparent)))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontFamily: 'Muli',
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cars(onpress, BuildContext context, String image) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 6,
      child: ElevatedButton(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: 20,
                left: 10,
              ),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset("images/$image"),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FurS",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                Text(
                  "Php 40.00",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Small Vehicle Type",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        onPressed: onpress,
      ),
    );
  }
}
