import 'package:euser/assistants/request_assistant.dart';
import 'package:euser/global/maps_key.dart';
import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/mainScreen/Search_folder/_normal_search/user_tile.dart';
import 'package:euser/models/predicted_places.dart';
import 'package:euser/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  var focusDestination = FocusNode();
  List<PredictedPlaces> placePredictedList = [];
  bool focus = false;
  @override
  Widget build(BuildContext context) {
    setFocus();
    String address = (Provider.of<AppInfo>(context).userPickUpLocation != null)
        ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
        : 'Getting Current Location....';
    pickupController.text = address;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 270,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Center(
                        child: Text(
                          'Set Trip',
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'images/rec.png',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                enabled: false,
                                hintText: 'Pick up',
                                fillColor: Colors.grey[50],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Muli',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        'images/pin.png',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value) {
                                searchPlace(value);
                              },
                              controller: destinationController,
                              focusNode: focusDestination,
                              decoration: InputDecoration(
                                hintText: 'Destination',
                                fillColor: Colors.grey[50],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  bottom: 15,
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Muli',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (placePredictedList.isNotEmpty)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemCount: placePredictedList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        CustomDivider(),
                    itemBuilder: (context, index) {
                      return UserTile(
                          predictedPlaces: placePredictedList[index]);
                    },
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void setFocus() {
    if (!focus) {
      FocusScope.of(context).requestFocus(focusDestination);
      focus = true;
    }
  }

  void searchPlace(String placeName) async {
    var uuid = const Uuid();

    if (placeName.length > 1) {
      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&location=7.1907,125.4553&radius=49436.8284&key=$mapKey&sessiontoken=${uuid.v4()}&components=country:ph&regions=postal_code:8000';
      var response = await RequestAssistant.receiveRequest(url);
      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var jsonpredictions = response['predictions'];
        var thisList = (jsonpredictions as List)
            .map((e) => PredictedPlaces.fromJson(e))
            .toList();

        setState(() {
          placePredictedList = thisList;
        });
      }
    }
  }
}
