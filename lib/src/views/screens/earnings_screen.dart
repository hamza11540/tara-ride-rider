import 'package:driver_app/src/models/status_enum.dart';
import 'package:driver_app/src/views/screens/rides.dart';
import 'package:driver_app/src/views/widgets/earnings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../app_colors.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../widgets/menu.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EarningsScreenState();
  }
}

class EarningsScreenState extends StateMVC<RidesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainBlue,
          title: Text(
            AppLocalizations.of(context)!.earnings,
            style: khulaSemiBold.copyWith(
                color: Colors.white,
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 1,
          shadowColor: Theme.of(context).primaryColor,
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Drawer(
            child: MenuWidget(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              EarningsWidget(),
              Expanded(
                child: RidesScreen(
                  status: [StatusEnum.completed],
                  checkRides: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
