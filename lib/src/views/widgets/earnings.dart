import 'package:driver_app/app_colors.dart';
import 'package:driver_app/src/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/user_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';

class EarningsWidget extends StatefulWidget {
  const EarningsWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return EarningsWidgetState();
  }
}

class EarningsWidgetState extends StateMVC<EarningsWidget> {
  late UserController _con;

  EarningsWidgetState() : super(UserController()) {
    _con = controller as UserController;
    _con.doLoadValues();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: AppColors.mainBlue,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    _con.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.today,
                                    style: kTitleStyle.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Helper.doubleToString(_con.valueToday ?? 0,
                                        currency: true),
                                    style: kSubtitleStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    VerticalDivider(
                      color: Theme.of(context).highlightColor,
                      thickness: 3,
                    ),
                    _con.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.yesterday,
                                    style: kTitleStyle.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Helper.doubleToString(
                                        _con.valueYesterday ?? 0,
                                        currency: true),
                                    style: kSubtitleStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    VerticalDivider(
                      color: Theme.of(context).highlightColor,
                      thickness: 3,
                    ),
                    _con.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).hintColor,
                            ),
                          )
                        : Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.sevenDays,
                                    style: kTitleStyle.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Helper.doubleToString(_con.valueWeek ?? 0,
                                        currency: true),
                                    style: kSubtitleStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,

          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: AppColors.mainBlue,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _con.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).hintColor,
                      ),
                    )
                  : IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.pending,
                                style: kTitleStyle.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                Helper.doubleToString(_con.valuePending ?? 0,
                                    currency: true),
                                style: kSubtitleStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
