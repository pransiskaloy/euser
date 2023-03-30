import 'package:euser/assistants/assistant_methods.dart';
import 'package:euser/global/global.dart';
import 'package:euser/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentConfirmation extends StatefulWidget {
  const PaymentConfirmation({Key? key}) : super(key: key);

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  double distanceFare = 0;
  double timeFare = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.estimatedFare(tripDirectionDetailsInfo!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "TOTAL PAYMENT",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 9.0,
                    ),
                  ],
                ),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Base Fare:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                          Text(
                            '${double.parse(base.toStringAsFixed(2))}',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Booking:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                          Text(
                            '${double.parse(bookingFee.toStringAsFixed(2))}',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Distance:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                          Text(
                            '${double.parse(distanceTraveledFarePerKilometer.toStringAsFixed(2))}',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Duration:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                          Text(
                            '${double.parse(timeTraveledFarePerMinute.toStringAsFixed(2))}',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 20,
                            )),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TOTAL",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                          ),
                          Text(
                            (tripDirectionDetailsInfo != null)
                                ? 'Php ${AssistantMethods.estimatedFare(tripDirectionDetailsInfo!)}'
                                : 'Php',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                          ),
                        ]),
                  ),
                ]),
              ),
              const SizedBox(height: 30),
              MainButton(
                  color: Colors.blue.shade400,
                  title: 'Book Now!',
                  onpress: () {
                    Navigator.of(context).pop('okay');
                  }),
              // SizedBox(
              //     width: double.infinity,
              //     height: 56,
              //     child: TextButton(
              //       style: ButtonStyle(
              //           shape: MaterialStateProperty
              //               .all<RoundedRectangleBorder>(RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(18.0),
              //                   side: const BorderSide(color: Colors.green)))),
              //       onPressed: () {
              //         Navigator.of(context).pop('okay');
              //       },
              //       child: Text(
              //         "Continue",
              //         style: GoogleFonts.poppins(
              //             textStyle: const TextStyle(
              //           fontSize: 18,
              //           color: Colors.black,
              //         )),
              //       ),
              //     )),
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.transparent)))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      )),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
