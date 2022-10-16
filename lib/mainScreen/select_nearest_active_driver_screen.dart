import 'package:euser/assistants/assistant_methods.dart';
import 'package:euser/global/global.dart';
import 'package:euser/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  //Initialize referenceRideRequest that is passed to searchNearestOnlineDrivers method then pass to selectActiveDriverScreen
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriversScreen> createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = "";
  getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectionDetailsInfo != null) {
      if (dList[index]["car_details"]["car_type"].toString() == "Motorcycle") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) /
                    2)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["car_type"].toString() == "Furfetch-x") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) *
                    2)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["car_type"].toString() == "Furfetch-go") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                    tripDirectionDetailsInfo!))
                .toString();
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Nearest Online Active Drivers",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              dList.clear();
            });
            //Delete-remove the ride request from database
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg: "You have canceled the ride request!");
            // SystemNavigator.pop();
            MyApp.restartApp(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                chosenDriverId = dList[index]["id"].toString();
              });
              Navigator.pop(context, "driverChoose");
            },
            child: Card(
              color: Colors.blue,
              elevation: 3,
              shadowColor: Colors.grey,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Image.asset(
                      "images/" +
                          dList[index]["car_details"]["car_type"].toString() +
                          ".png",
                      width: 70,
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dList[index]["name"].toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        dList[index]["car_details"]["car_model"].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                        ),
                      ),
                      SmoothStarRating(
                        rating: 3.5,
                        color: Colors.yellow,
                        borderColor: Colors.yellow,
                        allowHalfRating: true,
                        starCount: 5,
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getFareAmountAccordingToVehicleType(index),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        tripDirectionDetailsInfo?.duration_text ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        tripDirectionDetailsInfo?.distance_text ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
