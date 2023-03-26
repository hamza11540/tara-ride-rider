import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_colors.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../repositories/setting_repository.dart';
import '../widgets/menu.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late FToast fToast;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    AdaptiveTheme.getThemeMode().then((theme) =>
        setState(() => setting.value.theme = theme ?? AdaptiveThemeMode.light));
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: AppColors.mainBlue,
          title: Text(
            'Settings',
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 3, top: 3),
              child: RawScrollbar(
                thumbColor: Theme.of(context).hintColor,
                radius: Radius.circular(20),
                thickness: 4,
                thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    left: Dimensions.PADDING_SIZE_DEFAULT,
                    right: Dimensions.PADDING_SIZE_DEFAULT,
                    bottom: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        horizontalTitleGap: 0,
                        title: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.theme,
                                style: rubikBold.copyWith(
                                    fontSize:
                                        Dimensions.FONT_SIZE_EXTRA_LARGE_2)),
                            const Spacer(),
                            FlutterSwitch(
                              width: 90,
                              height: 45,
                              toggleSize: 45.0,
                              value:
                                  setting.value.theme == AdaptiveThemeMode.dark,
                              borderRadius: 30.0,
                              padding: 2.0,
                              activeToggleColor: Color(0xFF6E40C9),
                              inactiveToggleColor: Color(0xFF2F363D),
                              activeSwitchBorder: Border.all(
                                color: Color(0xFF3C1E70),
                                width: 5,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: Color(0xFFD1D5DA),
                                width: 5,
                              ),
                              activeColor: Color(0xFF271052),
                              inactiveColor: Colors.white,
                              activeIcon: Icon(
                                Icons.nightlight_round,
                                color: Color(0xFFF8E3A1),
                              ),
                              inactiveIcon: Icon(
                                Icons.wb_sunny,
                                color: Color(0xFFFFDF5D),
                              ),
                              onToggle: (isActive) {
                                if (isActive) {
                                  AdaptiveTheme.of(context).setDark();
                                  setState(() => setting.value.theme =
                                      AdaptiveThemeMode.dark);
                                } else {
                                  AdaptiveTheme.of(context).setLight();
                                  setState(() => setting.value.theme =
                                      AdaptiveThemeMode.light);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        height: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
