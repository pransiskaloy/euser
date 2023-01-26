import 'package:euser/assistants/request_assistant.dart';
import 'package:euser/global/maps_key.dart';
import 'package:euser/models/predicted_places.dart';
import 'package:euser/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placePredictedList = [];
  bool focus = false;
  var focusDestination = FocusNode();
  var destinationController = TextEditingController();

  void findPlaceAutoCompleteSearch(String inputText) async {
    var uuid = const Uuid();
    if (inputText.length > 3) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&location=7.1907,125.4553&radius=2444&key=$mapKey&sessiontoken=${uuid.v4()}&components=country:ph&regions=postal_code:8000";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch == "Error Occurred: No Response!") {
        return;
      }
      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placePredictedList = placePredictionList;
        });
      }
    }
  }

  void setFocus() {
    if (!focus) {
      FocusScope.of(context).requestFocus(focusDestination);
      focus = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //search place ui
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 9.0,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search & Set Drop-off Location",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (valueTyped) {
                            findPlaceAutoCompleteSearch(valueTyped);
                          },
                          focusNode: focusDestination,
                          controller: destinationController,
                          decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  Icons.add_location_rounded,
                                  color: Colors.red,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                borderSide:
                                    BorderSide(color: Color(0xFF4F6CAD)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                borderSide:
                                    BorderSide(color: Color(0xFF4F6CAD)),
                              ),
                              filled: true,
                              hintText: "Search Drop-off Destination",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 172, 170, 170),
                                letterSpacing: 1.5,
                              ),
                              fillColor: Colors.white70),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          //display place predictions result
          (placePredictedList.isNotEmpty)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: placePredictedList.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTile(
                        predictedPlaces: placePredictedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
