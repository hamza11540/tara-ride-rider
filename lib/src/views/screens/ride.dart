import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../models/ride.dart';
import '../../views/widgets/ride_address.dart';
import '../../views/widgets/ride_buttons.dart';
import '../../views/widgets/ride_details.dart';
import '../../models/status_enum.dart';
import '../../controllers/ride_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../widgets/custom_toast.dart';

class RideScreen extends StatefulWidget {
  final String rideId;
  final bool showButtons;
  const RideScreen({Key? key, required this.rideId, this.showButtons = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RideScreenState();
  }
}

class RideScreenState extends StateMVC<RideScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RideController _con;
  int currentTab = 0;
  late FToast fToast;

  RideScreenState() : super(RideController()) {
    _con = controller as RideController;
  }

  @override
  void initState() {
    getRide();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> getRide() async {
    await _con.doGetRide(widget.rideId).catchError((_error) {
      fToast.removeCustomToast();
      fToast.showToast(
        child: CustomToast(
          backgroundColor: Colors.red,
          icon: Icon(Icons.close, color: Colors.white),
          text: _error.toString(),
          textColor: Colors.white,
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    });
  }

  Future<void> onButtonPressed(StatusEnum status, {String? addressId}) async {
    if (status == StatusEnum.rejected) {
      await _updateStatus(status).then((value) {
        Navigator.of(context).pop();
      });
    } else if (status == StatusEnum.cancelled) {
      Alert(
        context: context,
        type: AlertType.warning,
        style: AlertStyle(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleStyle: khulaBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_2),
          descStyle: khulaSemiBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 12),
        ),
        title: AppLocalizations.of(context)!.attention.toUpperCase(),
        desc:
            AppLocalizations.of(context)!.rideWillBeCanceledAmountRefundedSure,
        buttons: [
          DialogButton(
            radius: BorderRadius.circular(20),
            highlightColor: Theme.of(context).primaryColor.withOpacity(.2),

            child: Text(
              AppLocalizations.of(context)!.no,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).colorScheme.primary,
          ),
          DialogButton(
            radius: BorderRadius.circular(20),
            highlightColor: Theme.of(context).primaryColor.withOpacity(.2),
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _updateStatus(status);
            },
            color: Colors.red,
          )
        ],
      ).show();
    } else {
      await _updateStatus(status);
    }
  }

  Future<void> _updateStatus(StatusEnum status, {String? addressId}) async {
    setState(() => _con.updatingStatus = true);
    await _con
        .doUpdateRideStatus(_con.ride!.id, status, addressId)
        .catchError((_error) {
      fToast.removeCustomToast();
      fToast.showToast(
        child: CustomToast(
          backgroundColor: Colors.red,
          icon: Icon(Icons.close, color: Colors.white),
          text: _error.toString(),
          textColor: Colors.white,
        ),
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 3),
      );
    }).then((Ride ride) {
      if (status != StatusEnum.rejected) {
        fToast.removeCustomToast();
        fToast.showToast(
          child: CustomToast(
            icon: Icon(Icons.check_circle_outline, color: Colors.green),
            text:
                '${AppLocalizations.of(context)!.rideMarkedAs} ${StatusEnumHelper.description(ride.rideStatus, context)}!',
          ),
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 7),
        );
      }
    });
    setState(() => _con.updatingStatus = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _con.updatingStatus ? false : true,
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: _con.ride == null || !widget.showButtons
            ? SizedBox()
            : RideButtonsWidget(
                ride: _con.ride!,
                loading: _con.updatingStatus,
                onButtonPressed: (StatusEnum status, {String? addressId}) =>
                    onButtonPressed(status, addressId: addressId),
              ),
        appBar: AppBar(
          title: RichText(
            text: _con.ride != null
                ? TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${AppLocalizations.of(context)!.ride} #${_con.ride!.id} - ',
                        style: khulaSemiBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                        text: StatusEnumHelper.description(
                            _con.ride!.rideStatus, context),
                        style: khulaBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  )
                : const TextSpan(),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              if (!_con.updatingStatus) {
                Navigator.of(context).pop();
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _con.loading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ))
            : _con.ride == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.rideNotFound,
                        style: khulaBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: Dimensions.PADDING_SIZE_LARGE,
                          left: Dimensions.PADDING_SIZE_LARGE,
                          right: Dimensions.PADDING_SIZE_LARGE,
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
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton.icon(
                          onPressed: () async {
                            getRide();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context).highlightColor,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.tryAgain,
                            style: poppinsSemiBold.copyWith(
                                color: Theme.of(context).highlightColor,
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      DefaultTabController(
                        initialIndex: currentTab,
                        length: 2,
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 16, right: 16),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.4),
                                        blurRadius: 5,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: TabBar(
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle: TextStyle(),
                                  onTap: (int tabIndex) {
                                    currentTab = tabIndex;
                                  },
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                    color: Color(0xff00380FF),
                                  ),
                                  labelColor: Colors.white,
                                  tabs: <Widget>[
                                    SizedBox(
                                      height: 45,
                                      child: Tab(
                                        text: AppLocalizations.of(context)!
                                            .details,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 45,
                                      child: Tab(
                                        text: AppLocalizations.of(context)!
                                            .addresses,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    RideDetailsWidget(ride: _con.ride!),
                                    RideAddressWidget(ride: _con.ride!)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
