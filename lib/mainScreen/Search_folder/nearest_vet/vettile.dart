import 'package:euser/assistants/request_assistant.dart';
import 'package:euser/global/maps_key.dart';
import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/models/directions.dart';
import 'package:euser/models/veterinary.dart';
import 'package:euser/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VetTile extends StatelessWidget {
  final Veterinaries veterinaries;

  const VetTile({required this.veterinaries});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        primary: Colors.white,
      ),
      onPressed: () {
        getPlaceDetails(veterinaries.placeID!, context);
      },
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[350],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(veterinaries.vetname!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(veterinaries.vicinity!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 12,
                            color: Colors.black54)),
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
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: 'Loading....',
            ));
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';
    var response = await RequestAssistant.receiveRequest(url);

    Navigator.of(context).pop();

    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Directions directions = Directions();
      directions.locationName = response["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          response["result"]["geometry"]["location"]["lat"].toString();
      directions.locationLongitude =
          response["result"]["geometry"]["location"]["lng"].toString();

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocation(directions);

      Navigator.of(context).pop('NearestVet');
    }
  }
}
