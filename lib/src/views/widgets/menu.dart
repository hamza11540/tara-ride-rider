import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_app/src/models/ride.dart';
import 'package:driver_app/src/views/widgets/link_share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_colors.dart';
import '../../controllers/ride_controller.dart';
import '../../controllers/user_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/images.dart';
import '../../helper/styles.dart';
import '../../models/screen_argument.dart';
import '../../repositories/user_repository.dart';
import 'sign_out_confirmation_dialog.dart';

// ignore: must_be_immutable
class MenuWidget extends StatefulWidget {
  Function? onSwitchTab;
  MenuWidget({Key? key, this.onSwitchTab}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MenuWidgetState();
  }
}

class MenuWidgetState extends StateMVC<MenuWidget> {
  late UserController _userCon;

  MenuWidgetState() : super(UserController()) {
    _userCon = controller as UserController;
  }

  @override
  void initState() {
    super.initState();
    _userCon.doGetRating();
  }

  @override
  Widget build(BuildContext context) {
    return !currentUser.value.auth
        ? SizedBox()
        : Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      '/Settings',
                      arguments: ScreenArgument({'index': 2}),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(top: 20, bottom: 15, left: 20),
                    decoration: BoxDecoration(color: AppColors.white),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                    color: AppColors.mainBlue,
                                  ))
                            ],
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.mainBlue, width: 3)),
                            child: ClipOval(
                                child: currentUser.value.picture != null &&
                                        currentUser.value.picture!.id != ''
                                    ? CachedNetworkImage(
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                            value: progress.progress,
                                          ),
                                        ),
                                        imageUrl:
                                            currentUser.value.picture!.url,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(Images.placeholderUser,
                                        color: Theme.of(context).primaryColor,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.scaleDown)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_SMALL),
                            child: Text(
                              currentUser.value.name,
                              style: TextStyle(
                                  fontFamily: 'Uber',
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_SMALL),
                            child: Text(
                              currentUser.value.email,
                              style: TextStyle(
                                  fontFamily: 'Uber',
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.black,
                                ),
                                Text(
                                  _userCon.ratings.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Uber',
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(

                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5,),

                                Text(
                                  "${currentUser.value.wallet}.0 \$",
                                  style: TextStyle(
                                      fontFamily: 'Uber',
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_SMALL),
                            child: Text(
                              currentUser.value.phone,
                              style: TextStyle(
                                  fontFamily: 'Uber',
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          /*Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: LinkShare(),
                          ),*/
                        ]),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Divider(
                          color: Theme.of(context).colorScheme.secondary,
                          height: 0),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {
                          if (widget.onSwitchTab != null) {
                            widget.onSwitchTab!('Home');
                          } else {
                            Navigator.of(context).pushReplacementNamed('/Home');
                          }
                        },
                        leading: Icon(
                          FontAwesomeIcons.house,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.home,
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {
                          if (widget.onSwitchTab != null) {
                            widget.onSwitchTab!('Earnings');
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed('/Earnings');
                          }
                        },
                        leading: Icon(
                          FontAwesomeIcons.moneyCheckDollar,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.earnings,
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {
                          if (widget.onSwitchTab != null) {
                            widget.onSwitchTab!('Profile');
                          } else {
                            Navigator.of(context).pushReplacementNamed(
                              '/Profile',
                            );
                          }
                        },
                        leading: Icon(
                          FontAwesomeIcons.userLarge,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.profile,
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {
                          if (widget.onSwitchTab != null) {
                            widget.onSwitchTab!('Settings');
                          } else {
                            Navigator.of(context).pushReplacementNamed(
                              '/Settings',
                            );
                          }
                        },
                        leading: Icon(
                          FontAwesomeIcons.gear,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.settings,
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {
                          Navigator.of(context).pushNamed('/ratingScreen');
                        },
                        leading: Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          "Rate Us",
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {},
                        leading: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          "Share with Friends",
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        horizontalTitleGap: 0,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => SignOutConfirmationDialog(
                                      onConfirmed: () async {
                                    await _userCon.doLogout();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/Login', (route) => false);
                                    setState(() {});
                                  }));
                        },
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 18,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.logout,
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
