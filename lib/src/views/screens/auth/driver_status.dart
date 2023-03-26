import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../helper/dimensions.dart';
import '../../../helper/styles.dart';
import '../../../models/driver_status_enum.dart';
import '../../../models/screen_argument.dart';

class DriverStatusScreen extends StatefulWidget {
  final DriverStatusEnum status;
  final String? observation;
  const DriverStatusScreen(this.status, {Key? key, this.observation})
      : super(key: key);

  @override
  State<DriverStatusScreen> createState() => _DriverStatusScreenState();
}

class _DriverStatusScreenState extends State<DriverStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                if (widget.status == DriverStatusEnum.pending)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Image.asset('assets/img/download (1) 1.png'),
                      SizedBox(height: 40),
                      Text(
                        AppLocalizations.of(context)!.dataUnderReview,
                        style: kTitleStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your documents is under process please wait for admin approval thank you for using TARA Ride',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                if (widget.status == DriverStatusEnum.reproved)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Icon(
                        FontAwesomeIcons.triangleExclamation,
                        size: 100,
                        color: Colors.yellow[700],
                      ),
                      SizedBox(height: 40),
                      Text(
                        AppLocalizations.of(context)!.needCheckSomeData,
                        style: kTitleStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.observation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            widget.observation!,
                            style: kSubtitleStyle.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_2,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                          bottom: Dimensions.PADDING_SIZE_LARGE * 2,
                          top: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pushNamed('/Signup',
                                arguments: ScreenArgument({'edit': true}));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.editData,
                            style: poppinsSemiBold.copyWith(
                                color: Theme.of(context).highlightColor,
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
