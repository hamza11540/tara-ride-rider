import 'package:driver_app/src/helper/location.dart';
import 'package:driver_app/src/models/screen_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_colors.dart';
import '../../controllers/user_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../repositories/user_repository.dart';
import 'custom_toast.dart';

class RideAvailable extends StatefulWidget {
  final bool refreshOnStart;
  final Color? titleColor;
  const RideAvailable({Key? key, this.titleColor, this.refreshOnStart = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RideAvailableState();
  }
}

class RideAvailableState extends StateMVC<RideAvailable> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late UserController _userCon;
  bool gettingPermisison = false;
  late FToast fToast;

  RideAvailableState() : super(UserController()) {
    _userCon = controller as UserController;
    _userCon.scaffoldKey = _key;
  }

  @override
  void initState() {
    super.initState();
    if (widget.refreshOnStart) {
      refreshStatus();
    }
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> refreshStatus() async {
    await _userCon.doGetRideActive().catchError((error) {
      fToast.showToast(
          child: CustomToast(
            icon: const Icon(Icons.close, color: Colors.red),
            text: error.toString(),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3));
    });
  }

  Future<void> updateStatus(bool active) async {
    if (!gettingPermisison) {
      gettingPermisison = true;
      if (active) {
        bool locationEnabled = await LocationHelper.hasLocationPermission(
                context,
                dialogsRequired: true)
            .catchError((error) {
          return false;
        });
        if (!locationEnabled) {
          gettingPermisison = false;
          return;
        }
      }
      await _userCon.doUpdateRideActive(active).catchError((error) {
        fToast.showToast(
            child: CustomToast(
              icon: const Icon(Icons.close, color: Colors.red),
              text: error.toString(),
              actionText: AppLocalizations.of(context)!.connect,
              actionColor: Colors.green,
              action: () {
                Navigator.of(context).pushReplacementNamed(
                  '/Settings',
                  arguments: ScreenArgument({'index': 2}),
                );
              },
            ),
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 5));
      });
      gettingPermisison = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _key,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Turn On the button to receive Rides.",
              style: khulaBold.copyWith(
                  fontSize: 12, color: widget.titleColor ?? Colors.white),
            ),
            SizedBox(width: 10),
            FlutterSwitch(
              activeColor: AppColors.mainBlue,
              activeText: AppLocalizations.of(context)!.yes,
              inactiveText: AppLocalizations.of(context)!.no,
              valueFontSize: 18,
              value: currentUser.value.driver?.active ?? false,
              width: 55,
              height: 25,
              borderRadius: 30.0,
              switchBorder: Border.all(
                color: Colors.white,
                width: 1,
              ),
              toggleBorder: Border.all(
                color: Colors.white,
                width: 1,
              ),
              onToggle: (isActive) async {
                await updateStatus(isActive);
              },
            ),
          ],
        )
      ],
    );
  }
}
