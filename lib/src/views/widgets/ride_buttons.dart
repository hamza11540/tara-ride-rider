import 'package:auto_size_text/auto_size_text.dart';
import 'package:driver_app/src/models/status_enum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../models/ride.dart';

class RideButtonsWidget extends StatefulWidget {
  final Ride ride;
  final bool loading;
  final Function onButtonPressed;

  RideButtonsWidget({
    Key? key,
    this.loading = false,
    required this.onButtonPressed,
    required this.ride,
  }) : super(key: key);

  @override
  State<RideButtonsWidget> createState() => RideButtonsWidgetState();
}

class RideButtonsWidgetState extends State<RideButtonsWidget> {
  Widget button(
      {double? width,
      required String text,
      required StatusEnum status,
      Color? color}) {
    return SizedBox(
      width: width ?? (MediaQuery.of(context).size.width - 40) / 2,
      child: TextButton(

        onPressed: () {
          widget.onButtonPressed(status);
        },
        style: TextButton.styleFrom(
            backgroundColor: color ?? Colors.green,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: khulaBold.merge(TextStyle(
              color: Colors.white, fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.ride.rideStatus! == StatusEnum.pending ||
          widget.ride.rideStatus! == StatusEnum.accepted ||
          widget.ride.rideStatus! == StatusEnum.in_progress,
      child: BottomAppBar(
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: (Colors.grey[400])!,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: const Offset(0.0, -1.0),
              )
            ],
          ),
          child: widget.loading
              ? Center(child: CircularProgressIndicator())
              : widget.ride.rideStatus! == StatusEnum.pending
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button(
                                text: AppLocalizations.of(context)!.accept,
                                status: StatusEnum.accepted),
                            const SizedBox(width: 10),
                            button(
                                text: AppLocalizations.of(context)!.refuse,
                                status: StatusEnum.rejected,
                                color: Colors.red),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : widget.ride.rideStatus! == StatusEnum.accepted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                button(
                                    text: AppLocalizations.of(context)!
                                        .passengerBoarded,
                                    status: StatusEnum.in_progress),
                                const SizedBox(width: 10),
                                button(
                                    text: AppLocalizations.of(context)!
                                        .cancelRide,
                                    status: StatusEnum.cancelled,
                                    color: Colors.red),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                      : widget.ride.rideStatus! == StatusEnum.in_progress
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    button(
                                        text: AppLocalizations.of(context)!
                                            .finalizeRide,
                                        status: StatusEnum.completed),
                                    const SizedBox(width: 10),
                                    button(
                                        text: AppLocalizations.of(context)!
                                            .cancelRide,
                                        status: StatusEnum.cancelled,
                                        color: Colors.red),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                          : SizedBox(),
        ),
      ),
    );
  }
}
