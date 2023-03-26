import 'dart:async';

import 'package:driver_app/src/models/status_enum.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/src/helper/dimensions.dart';
import 'package:driver_app/src/helper/styles.dart';
import 'package:driver_app/src/views/widgets/empty_rides.dart';
import 'package:driver_app/src/views/widgets/ride_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../controllers/ride_controller.dart';
import '../../models/ride.dart';
import '../widgets/custom_toast.dart';

class RidesScreen extends StatefulWidget {
  final int? pageSize;
  final bool checkRides;
  final List<StatusEnum>? status;
  const RidesScreen(
      {this.pageSize = 25, this.checkRides = true, this.status, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RidesScreenState();
  }
}

class _RidesScreenState extends StateMVC<RidesScreen> {
  bool loading = false;
  late RideController _con;
  final ScrollController _controller = ScrollController();
  late FToast fToast;
  Timer? _timer;

  _RidesScreenState() : super(RideController()) {
    _con = controller as RideController;
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    refresh();
    if (widget.checkRides) {
      checkNewRides();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void checkNewRides() {
    _timer = new Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      await _con.doCheckNewRide().then((List<Ride> rides) {
        if (rides.isNotEmpty) {
          fToast.removeCustomToast();
          fToast.showToast(
            child: CustomToast(
              icon: Icon(Icons.check_circle_outline, color: Colors.green),
              text: AppLocalizations.of(context)!.newRideReceived,
            ),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 7),
          );
        }
      }).catchError((error) {});
    });
  }

  Future<void> refresh() async {
    setState(() {
      _con.rides.clear();
      loading = true;
    });
    await _con.doGetRides(pageSize: widget.pageSize, status: widget.status);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
          physics: !loading && _con.rides.isEmpty
              ? ClampingScrollPhysics()
              : BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
          controller: _controller,
          children: [
            if (!loading && _con.rides.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: EmptyRidesWidget(),
              )
            else
              ListView.builder(
                  padding: EdgeInsets.only(top: 20),
                  itemCount: _con.rides.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: RideItemWidget(
                          ride: _con.rides.elementAt(index),
                          loadPedidos: () {
                            refresh();
                          }),
                    );
                  }),
            if (loading)
              Container(
                padding: EdgeInsets.only(bottom: 10),
                height: _con.rides.isNotEmpty ? 50 : 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _con.rides.isNotEmpty ? 40 : 50,
                      height: _con.rides.isNotEmpty ? 40 : 50,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (_con.rides.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          AppLocalizations.of(context)!.searchingRides,
                          style: khulaBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            if (!loading && _con.hasMoreRides)
              Container(
                margin: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: Dimensions.PADDING_SIZE_LARGE,
                  top: Dimensions.PADDING_SIZE_LARGE,
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
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_controller.hasClients) {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                        );
                      }
                    });
                    await _con.doGetRides(
                        pageSize: widget.pageSize, status: widget.status);
                    setState(() {
                      loading = false;
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.loadMore,
                    style: poppinsSemiBold.copyWith(
                        color: Theme.of(context).highlightColor,
                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                  ),
                ),
              ),
          ]),
    );
  }
}
