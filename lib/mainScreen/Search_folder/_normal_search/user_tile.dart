import 'package:euser/assistants/request_assistant.dart';
import 'package:euser/global/global.dart';
import 'package:euser/global/maps_key.dart';
import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/models/directions.dart';
import 'package:euser/models/predicted_places.dart';
import 'package:euser/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  final PredictedPlaces? predictedPlaces;

  UserTile({this.predictedPlaces});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0), primary: Colors.white),
      onPressed: () {
        getPlaceDetails(widget.predictedPlaces!.place_id!, context);
      },
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.grey[350],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.predictedPlaces!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'Muli',
                            color: Colors.grey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(widget.predictedPlaces!.secondary_text!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'Muli',
                            color: Colors.grey[850],
                            fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void getPlaceDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting Destination...",
      ),
    );
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';
    var responseApi = await RequestAssistant.receiveRequest(url);

    Navigator.of(context).pop();

    if (responseApi == 'failed') {
      return;
    }
    if (responseApi['status'] == 'OK') {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"].toString();
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"].toString();

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocation(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });
      Navigator.of(context).pop('getDirections');
    }
  }
}
