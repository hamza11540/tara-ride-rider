import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:driver_app/src/models/status_enum.dart';
import 'package:driver_app/src/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../app_colors.dart';
import '../../controllers/user_controller.dart';
import '../widgets/menu.dart';
import '../widgets/ride_available.dart';
import 'home_map.dart';
import 'rides.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  final bool saveLocation;
  const HomeScreen({Key? key, this.index = 0, this.saveLocation = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends StateMVC<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late UserController _con;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Timer? _timer;
  final GlobalKey<RideAvailableState> _rideAvailableState =
      GlobalKey<RideAvailableState>();

  HomeScreenState() : super(UserController()) {
    _con = controller as UserController;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLocationListener();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Future<void> setLocationListener() async {
    if (widget.saveLocation) {
      await _con.doUpdateLocation().catchError((error) async {
        if (currentUser.value.driver?.active ?? false) {
          await _con.doUpdateRideActive(false);
        }
        return;
      });
    }
    if (currentUser.value.driver?.active ?? false) {
      getLocationPeriodically();
    }
    currentUser.addListener(() {
      if (currentUser.value.driver?.active ?? false) {
        getLocationPeriodically();
      } else {
        if (_timer != null) {
          _timer!.cancel();
        }
      }
    });
  }

  Future<void> getLocationPeriodically() async {
    bool timerFinished = true;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = new Timer.periodic(Duration(seconds: 30), (Timer timer) async {
      if (timerFinished) {
        timerFinished = false;
        await _con
            .doUpdateLocation(dialogsRequired: true)
            .catchError((error) async {
          if (currentUser.value.driver?.active ?? false) {
            await _con.doUpdateRideActive(false);
          }
          setState(() {
            currentUser.value.driver?.active;
          });
        }).whenComplete(() => timerFinished = true);
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          key: _scaffoldKey,
          extendBody: true,
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30), top: Radius.circular(30)),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            leading: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.mainBlue),
                child: new IconButton(
                  icon: new Icon(
                    Icons.dehaze_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  "Welcome to ",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  "TARA RIDE",
                  style: TextStyle(
                      color: AppColors.mainBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          drawer: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Drawer(
              backgroundColor: Colors.amber,
              child: MenuWidget(
                onSwitchTab: (tab) {
                  if (tab == 'Home') {
                    Navigator.pop(context);
                  } else {
                    Navigator.of(context).pushReplacementNamed(
                      '/$tab',
                    );
                  }
                },
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.mainBlue,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: RideAvailable(
                    key: _rideAvailableState,
                    refreshOnStart: false,
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(224, 224, 224, 1),
                  thickness: 2.5,
                  height: 0,
                ),
                Expanded(
                    child: RidesScreen(
                  status: [
                    StatusEnum.pending,
                    StatusEnum.accepted,
                    StatusEnum.in_progress
                  ],
                )),
              ],
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              CarouselSlider(
                options: CarouselOptions(height: 120.0, autoPlay: true),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/img/OBJECTS.png"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.mainBlue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Let's go with",
                                    style: TextStyle(
                                        fontSize: 16.0, color: AppColors.white),
                                  ),
                                  Text(
                                    " Tara Ride",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Image.asset('assets/img/Group 6006 1.png')
                            ],
                          ));
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height * 0.38,
                      width: double.infinity,
                      child: HomeMapScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
