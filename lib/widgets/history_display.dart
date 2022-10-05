import 'package:euser/models/trips_history_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryDisplay extends StatefulWidget {
  TripsHistoryModel? tripHistoryModel;

  HistoryDisplay({this.tripHistoryModel});

  @override
  State<HistoryDisplay> createState() => _HistoryDisplayState();
}

class _HistoryDisplayState extends State<HistoryDisplay> {
  String formatDate(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    //Dec 10 , 2022 , 12:00 pm
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} ";

    return formattedDate;
  }

  String formatTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    //Dec 10 , 2022 , 12:00 pm
    String formattedTime = "${DateFormat.jm().format(dateTime)} ";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 9.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.tripHistoryModel!.driverName!,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 17),
                    )),
                Text(
                  "PHP " + widget.tripHistoryModel!.fareAmount!,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            // //trip date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(widget.tripHistoryModel!.endTime!) + " - " + formatTime(widget.tripHistoryModel!.endTime!),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              height: MediaQuery.of(context).size.height * .7,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 9.0,
                                  ),
                                ],
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Center(
                                  child: Text("Trip Details",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                const Divider(thickness: 1),
                                const SizedBox(height: 10),
                                //Driver detail
                                Text("Driver's Name",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )),
                                Text(widget.tripHistoryModel!.driverName!,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 19),
                                    )),
                                const SizedBox(height: 10),
                                // //car details
                                Text("Car Info",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )),
                                Text(widget.tripHistoryModel!.carDetails!,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 20),
                                    )),
                                const SizedBox(height: 10),
                                //origin detail
                                Text("From",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )),
                                Flexible(
                                  child: Text(widget.tripHistoryModel!.originAddress!,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(fontSize: 15),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                //destination detail
                                Text("To",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )),
                                Flexible(
                                  child: Text(widget.tripHistoryModel!.destinationAddress!,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(fontSize: 15),
                                      )),
                                ),
                                const SizedBox(height: 10),

                                //date
                                Text("Date",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )),
                                Text(
                                  formatDate(widget.tripHistoryModel!.endTime!) + " - " + formatTime(widget.tripHistoryModel!.endTime!),
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //fare amount
                                Text("Fare Amount",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    )),
                                Text(
                                  "PHP " + widget.tripHistoryModel!.fareAmount!,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "View Details",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),

            //driver info + fare amount
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(widget.tripHistoryModel!.driverName!,
            //         style: GoogleFonts.poppins(
            //           textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         )),
            //     Text(
            //       "PHP " + widget.tripHistoryModel!.fareAmount!,
            //       style: GoogleFonts.poppins(
            //         textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ],
            // ),

            // //car details
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(widget.tripHistoryModel!.carDetails!,
            //         style: GoogleFonts.poppins(
            //           textStyle: const TextStyle(fontSize: 20),
            //         )),
            //   ],
            // ),

            // //origin detail
            // Row(
            //   children: [
            //     Image.asset(
            //       "images/origin.png",
            //       height: 20,
            //       width: 20,
            //     ),
            //     Flexible(
            //       child: Text(widget.tripHistoryModel!.originAddress!,
            //           style: GoogleFonts.poppins(
            //             textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //           )),
            //     ),
            //   ],
            // ),

            // //destination detail
            // Row(
            //   children: [
            //     Image.asset(
            //       "images/destination.png",
            //       height: 20,
            //       width: 20,
            //     ),
            //     Flexible(
            //       child: Text(widget.tripHistoryModel!.destinationAddress!,
            //           style: GoogleFonts.poppins(
            //             textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //           )),
            //     ),
            //   ],
            // ),

            // const SizedBox(
            //   height: 10,
            // ),

            // //trip date
            // Row(
            //   children: [
            //     Text(
            //       formatDateAndTime(widget.tripHistoryModel!.endTime!),
            //       style: GoogleFonts.poppins(
            //         textStyle: const TextStyle(fontSize: 18),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
