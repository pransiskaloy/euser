import 'package:euser/assistants/assistant_methods.dart';
import 'package:euser/global/global.dart';
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
        height: MediaQuery.of(context).size.height * .8,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Total Payment",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text('Base Fare: Php${double.parse(base.toStringAsFixed(2))}'),
              const SizedBox(height: 5),
              Text(
                  'Booking Fee: Php${double.parse(bookingFee.toStringAsFixed(2))}'),
              const SizedBox(height: 5),
              Text(
                  'Distance Fee: Php${double.parse(distanceTraveledFarePerKilometer.toStringAsFixed(2))}'),
              const SizedBox(height: 5),
              Text(
                  'Duration Fee: Php${double.parse(timeTraveledFarePerMinute.toStringAsFixed(2))}'),
              const SizedBox(height: 5),
              Text(
                (tripDirectionDetailsInfo != null)
                    ? 'Php${AssistantMethods.estimatedFare(tripDirectionDetailsInfo!)}'
                    : 'Php2',
              ),
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.green)))),
                    onPressed: () {
                      Navigator.of(context).pop('okay');
                    },
                    child: Text(
                      "Proceed",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                    ),
                  )),
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
