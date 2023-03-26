import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:driver_app/src/helper/dimensions.dart';
import 'package:driver_app/src/helper/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class EmptyRidesWidget extends StatelessWidget {
  final double? height;
  EmptyRidesWidget({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Lottie.asset('assets/img/man 2.json', height: 100, width: 400),
              Positioned(
                right: -30,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Opacity(
            opacity: 0.75,
            child: InkWell(
              onTap: () async {
                String? token = await FirebaseMessaging.instance.getToken();
                print("this is the fcm token:${token} ");
              },
              child: Text(
               AppLocalizations.of(context)!.youDontHaveAnyRides,
                textAlign: TextAlign.center,
                style: khulaBold.merge(TextStyle(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
