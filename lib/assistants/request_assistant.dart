import 'dart:convert';

import 'package:euser/global/maps_key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) {
        //successful
        String responseData = httpResponse.body; // json

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      } else {
        return "Error Occurred: No Response!";
      }
    } catch (exp) {
      return "Error Occurred: No Response!";
    }
  }
}
