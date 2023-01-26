import 'package:euser/models/directions.dart';
import 'package:euser/models/trips_history_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickUpLocation(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocation(Directions userDropOffAddress) {
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter) {
    countTotalTrips = 0;
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeyList) {
    historyTripsKeysList = [];
    historyTripsKeysList = tripsKeyList;
    notifyListeners();
  }

  updateOverAllHistoryInformation(TripsHistoryModel eachHistoryTrip) {
    allTripsHistoryInformationList.clear();
    allTripsHistoryInformationList.add(eachHistoryTrip);
    notifyListeners();
  }
}
