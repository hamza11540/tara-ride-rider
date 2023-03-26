import 'package:auto_size_text/auto_size_text.dart';
import 'package:driver_app/app_colors.dart';
import 'package:driver_app/src/models/address.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../models/ride.dart';

class RideAddressWidget extends StatefulWidget {
  final Ride ride;

  RideAddressWidget({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  State<RideAddressWidget> createState() => _RideAddressWidgetState();
}

class _RideAddressWidgetState extends State<RideAddressWidget> {
  void openAddress(Address endereco) {
    MapsLauncher.launchCoordinates(endereco.latitude, endereco.longitude,
        endereco.name + ' - ' + (endereco.number));
  }

  Widget generateDecoration(Widget conteudo) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightBlue3,


        borderRadius: BorderRadius.circular(20),
      ),
      child: conteudo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        SizedBox(height: 30),
        Text(
          AppLocalizations.of(context)!.clickOnAdressOpenInMap,
          textAlign: TextAlign.center,
          style: khulaBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 15),
        InkWell(
          onTap: () {
            openAddress(widget.ride.boardingLocation!);
          },
          child: generateDecoration(
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
              ),
              title: Text(
                'Pick Up Location:',
                style: khulaBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: Theme.of(context).primaryColor),
              ),
              subtitle: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.FONT_SIZE_EXTRA_SMALL,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                ),
                child: AutoSizeText(
                  ((widget.ride.boardingLocation?.formattedAddress) ??
                          AppLocalizations.of(context)!
                              .boardingAddressNotProvidedContactCustomer) +
                      ' - ' +
                      (widget.ride.boardingLocation?.number ?? ''),
                  minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  style: khulaRegular.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    height: 1.35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        generateDecoration(
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.FONT_SIZE_EXTRA_SMALL,
              vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
            ),
            title: Text(
              '${AppLocalizations.of(context)!.rideAddresses}:',
              style: khulaBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                  color: Theme.of(context).primaryColor),
            ),
            subtitle: InkWell(
              onTap: () {
                openAddress(widget.ride.destinationLocation!);
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_SMALL,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                    vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.ride.destinationLocation!.delivered
                          ? Icon(FontAwesomeIcons.check, color: Colors.green)
                          : Icon(FontAwesomeIcons.locationArrow),
                    ],
                  ),
                  iconColor: Theme.of(context).primaryColor,
                  minLeadingWidth: 0,
                  title: AutoSizeText(
                    '${widget.ride.destinationLocation!.formattedAddress + ' - ' + (widget.ride.destinationLocation!.number)}',
                    style: khulaRegular.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      height: 1.35,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
