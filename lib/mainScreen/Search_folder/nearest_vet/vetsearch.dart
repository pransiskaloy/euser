import 'package:euser/assistants/request_assistant.dart';
import 'package:euser/global/maps_key.dart';
import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/mainScreen/Search_folder/nearest_vet/vettile.dart';
import 'package:euser/models/veterinary.dart';
import 'package:euser/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class VetSearch extends StatefulWidget {
  @override
  State<VetSearch> createState() => _VetSearchState();
}

class _VetSearchState extends State<VetSearch> {
  var geolocator = Geolocator();
  List<Veterinaries> listvet = [];
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vets();
  }

  @override
  Widget build(BuildContext context) {
    String address = (Provider.of<AppInfo>(context).userPickUpLocation != null)
        ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
        : 'Getting Current Location....';
    pickupController.text = address;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Nearest Veterenaries",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [boxShadow()],
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 25),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
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
          ),
          petDisplay(context),
        ],
      ),
    );
  }

  Widget petDisplay(context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.4,
        child: Stack(
          children: <Widget>[
            (listvet.isNotEmpty)
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listvet.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          CustomDivider(),
                      itemBuilder: (context, index) {
                        return VetTile(veterinaries: listvet[index]);
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  boxShadow() {
    return const BoxShadow(
      color: Colors.black45,
      blurRadius: 3.0,
      spreadRadius: 0.5,
      offset: Offset(2.0, 2.0),
    );
  }

  void vets() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=2000&type=veterinary_care&key=$mapKey';

    var response = await RequestAssistant.receiveRequest(url);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      var jsonVetList = response['results'];
      var thisList =
          (jsonVetList as List).map((e) => Veterinaries.fromJson(e)).toList();
      print(response);
      setState(() {
        listvet = thisList;
      });
    }
  }
}
