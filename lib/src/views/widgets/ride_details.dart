import 'package:auto_size_text/auto_size_text.dart';
import 'package:driver_app/app_colors.dart';
import 'package:driver_app/src/repositories/setting_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:driver_app/src/helper/dimensions.dart';
import 'package:driver_app/src/helper/helper.dart';
import 'package:driver_app/src/helper/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/distance_unit_enum.dart';
import '../../models/ride.dart';
import '../../models/screen_argument.dart';
import '../../models/status_enum.dart';

class RideDetailsWidget extends StatefulWidget {
  final Ride ride;

  RideDetailsWidget({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  State<RideDetailsWidget> createState() => _RideDetailsWidgetState();
}

class _RideDetailsWidgetState extends State<RideDetailsWidget> {
  bool transferindoLoading = false;

  Widget generateDecoration(Widget conteudo) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffE6F2FE).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: conteudo,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        if (widget.ride.rideStatus == StatusEnum.accepted ||
            widget.ride.rideStatus == StatusEnum.in_progress)
          Padding(
            padding: EdgeInsets.only(
                top: 15,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/Chat',
                  arguments: ScreenArgument({'rideId': widget.ride.id}),
                );
              },
              style: TextButton.styleFrom(
                  backgroundColor: AppColors.mainBlue,
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.solidMessage,
                    size: 30,
                    color: Theme.of(context).highlightColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  AutoSizeText(
                    AppLocalizations.of(context)!.chatWithCustomer,
                    textAlign: TextAlign.center,
                    style: khulaBold.merge(
                      TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 10),
        generateDecoration(
          ListTile(

            title: Text(
              '${AppLocalizations.of(context)!.rideStatus}:',
              style: khulaBold.copyWith(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            ),
            trailing: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: AutoSizeText(
                StatusEnumHelper.description(widget.ride.rideStatus, context),
                minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                style: khulaRegular.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        generateDecoration(
          Column(
            children: [
              ListTile(
                title: Text(
                  'Cost of Ride:',
                  style: khulaBold.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor),
                ),
                trailing: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: AutoSizeText(
                    Helper.doubleToString(widget.ride.driverValue,
                        currency: true),
                    minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    style: khulaRegular.copyWith(
                      fontSize:12,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Commission:',
                  style: khulaBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: Theme.of(context).primaryColor),
                ),
                trailing: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: AutoSizeText(
                    Helper.doubleToString(widget.ride.appValue, currency: true),
                    minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    style: khulaRegular.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '${AppLocalizations.of(context)!.totalAmount}:',
                  style: khulaBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: Color.fromARGB(255, 246, 61, 61)),
                ),
                trailing: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: AutoSizeText(
                    Helper.doubleToString(widget.ride.amount, currency: true),
                    minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    style: khulaRegular.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Color.fromARGB(255, 246, 61, 61)),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.ride.paymentStatus != null ||
            widget.ride.paymentGateway != null ||
            widget.ride.offlinePaymentMethod != null)
          generateDecoration(
            Column(
              children: [
                if (widget.ride.paymentGateway != null ||
                    widget.ride.offlinePaymentMethod != null)
                  ListTile(
                    title: Text(
                      '${AppLocalizations.of(context)!.paymentMethod}:',
                      style: khulaBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Theme.of(context).primaryColor),
                    ),
                    trailing: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: AutoSizeText(
                        widget.ride.paymentGateway != null
                            ? widget.ride.paymentGateway!
                            : widget.ride.offlinePaymentMethod!.name,
                        minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        style: khulaRegular.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                if (widget.ride.paymentStatus != null)
                  ListTile(
                    title: Text(
                      '${AppLocalizations.of(context)!.paymentStatus}:',
                      style: khulaBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Theme.of(context).primaryColor),
                    ),
                    trailing: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: AutoSizeText(
                        StatusEnumHelper.description(
                            widget.ride.paymentStatus!, context),
                        minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        style: khulaRegular.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        generateDecoration(
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.estimatedDistance}:',
              style: khulaBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  color: Theme.of(context).primaryColor),
            ),
            trailing: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: AutoSizeText(
                '${widget.ride.distance.toStringAsFixed(1)} ${DistanceUnitEnumHelper.abbreviation(setting.value.distanceUnit, context)}',
                minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                style: khulaRegular.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        generateDecoration(
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
              vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
            ),
            title: Text(
              '${AppLocalizations.of(context)!.requestedBy}:',
              style: khulaBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  color: Theme.of(context).primaryColor),
            ),
            trailing: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '${widget.ride.user!.name}',
                    minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: khulaRegular.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  AutoSizeText(
                    widget.ride.user!.phone,
                    minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: khulaRegular.copyWith(
                      fontSize:12,
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.ride.observation != null)
          generateDecoration(
            ListTile(
              title: Text(
                '${AppLocalizations.of(context)!.note}:',
                style: khulaBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: Theme.of(context).primaryColor),
              ),
              trailing: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: AutoSizeText(
                  widget.ride.observation!,
                  minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  style: khulaRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
