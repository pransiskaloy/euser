import 'package:euser/infoHandler/app_info.dart';
import 'package:euser/widgets/history_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF4F6CAD)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Trip History",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF4F6CAD)))),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .90,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFF3F4F6),
                    Color(0xFFF3F4F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0,
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "TRIPS COMPLETED",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 25, color: Color(0xFF969B9F))),
                  ),
                  Text(
                    Provider.of<AppInfo>(context, listen: false)
                        .allTripsHistoryInformationList
                        .length
                        .toString(),
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF354859))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Transaction history",
                style: GoogleFonts.poppins(
                    letterSpacing: 2,
                    textStyle: const TextStyle(
                        fontSize: 20, color: Color(0xFF969B9F))),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return HistoryDisplay(
                  tripHistoryModel: Provider.of<AppInfo>(context, listen: false)
                      .allTripsHistoryInformationList[i],
                );
              },
              itemCount: Provider.of<AppInfo>(context, listen: false)
                  .allTripsHistoryInformationList
                  .length,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
