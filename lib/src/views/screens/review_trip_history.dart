import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../../../app_colors.dart';
import '../../controllers/ride_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../models/previous_ride_model.dart';
import '../../models/status_enum.dart';
import '../../repositories/setting_repository.dart';

class ReviewTripHistory extends StatefulWidget {
  final PreviousRideModel previousRideModel;
  const ReviewTripHistory({Key? key, required this.previousRideModel})
      : super(key: key);

  @override
  _ReviewTripHistoryState createState() => _ReviewTripHistoryState();
}

class _ReviewTripHistoryState extends StateMVC<ReviewTripHistory> {
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

  late RideController _con;
  bool loading = false;
  _ReviewTripHistoryState() : super(RideController()) {
    _con = controller as RideController;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '${'Ride'} #${widget.previousRideModel.id} - ',
              style: khulaSemiBold.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: widget.previousRideModel.rideStatus,
              style: khulaBold.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Colors.white,
              ),
            )
          ],
        )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/tripHistory');
          },
        ),
        backgroundColor: AppColors.mainBlue,
        elevation: 0,
      ),
      body: Column(
        children: [
          generateDecoration(
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
              ),
              title: Text(
                'Boarding Place:',
                style: khulaBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
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
                  widget.previousRideModel.boardingLocationData
                          ?.formattedAddress ??
                      "",
                  minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  style: khulaRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: Theme.of(context).primaryColor,
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
                'Destination Place:',
                style: khulaBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                    color: Theme.of(context).primaryColor),
              ),
              subtitle: Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_SMALL,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainBlue,
                  border: Border.all(width: 1, color: AppColors.mainBlue),
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
                      Icon(
                        FontAwesomeIcons.locationArrow,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  iconColor: Theme.of(context).primaryColor,
                  minLeadingWidth: 0,
                  title: AutoSizeText(
                    widget.previousRideModel.destinationLocationData
                            ?.formattedAddress ??
                        "",
                    minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    style: khulaRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: Colors.white,
                    ),
                    maxLines: 2,
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
                    'Total Amount:',
                    style: khulaBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: Color.fromARGB(255, 246, 61, 61)),
                  ),
                  trailing: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    child: AutoSizeText(
                      '${NumberFormat.simpleCurrency(name: setting.value.currency).currencySymbol} ${widget.previousRideModel.totalValue}',
                      minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                      style: khulaRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 246, 61, 61)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          generateDecoration(
            Column(
              children: [

                  ListTile(
                    title: Text(
                      'Payment Method:',
                      style: khulaBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: Theme.of(context).primaryColor),
                    ),
                    trailing: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: AutoSizeText(
                       "Cash",
                        minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        style: khulaRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),

                  ListTile(
                    title: Text(
                      'Payment Status:',
                      style: khulaBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: Theme.of(context).primaryColor),
                    ),
                    trailing: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: AutoSizeText(
                        widget.previousRideModel.paymentStatus??"",
                        minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        style: khulaRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          fontWeight: FontWeight.w600,
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
                'Estimate Distance:',
                style: khulaBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: Theme.of(context).primaryColor),
              ),
              trailing: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: AutoSizeText(
                  '${widget.previousRideModel.distance}',
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
          generateDecoration(
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                    vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
                  ),
                  title: Text(
                    'Rating:',
                    style: khulaBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
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
                            widget.previousRideModel.rating == null?"Not Rated" :"${widget.previousRideModel.rating.toString()}.0",
                            minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: khulaRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),

                      ],
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                    vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
                  ),
                  title: Text(
                    'Feedback:',
                    style: khulaBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
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
                          widget.previousRideModel.comment == null?"Not Feedback Added" :widget.previousRideModel.comment.toString(),
                          minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: khulaRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
