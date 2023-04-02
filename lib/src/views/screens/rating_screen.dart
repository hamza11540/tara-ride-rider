import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_app/src/models/ride.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../app_colors.dart';

import '../../controllers/ride_controller.dart';
import '../../helper/assets.dart';
import '../widgets/textfield_decoration.dart';

class RatingScreen extends StatefulWidget {
  final Ride ride;
  const RatingScreen({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends StateMVC<RatingScreen> {
  TextEditingController feedBack = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double? ratings;
  bool loading = false;
  late RideController _con;
  _RatingScreenState() : super(RideController()) {
    _con = controller as RideController;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.32,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(80)),
                    color: AppColors.mainBlue),
              ),
            ),
            Positioned(
                top: 70,
                left: 19,
                right: 19,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Bill",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                )),
            Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$ ${widget.ride.amount}",
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                )),
            Positioned(
                top: 190,
                left: 22,
                right: 22,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.mainBlue, width: 3)),
                          child: ClipOval(
                              child: widget.ride.user!.picture != null &&
                                      widget.ride.user!.picture!.id != ''
                                  ? CachedNetworkImage(
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      ),
                                      imageUrl:
                                          widget.ride.user?.picture!.url ?? "",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(Assets.placeholderUser,
                                      color: Theme.of(context).primaryColor,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.scaleDown)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.ride.user?.name ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.ride.user?.email ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: AppColors.mainBlue,
                          ),
                          onRatingUpdate: (rating) {
                            ratings = rating;
                            setState(() {});
                            print(rating);
                          },
                        )
                      ],
                    ),
                  ),
                )),
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Feedback is valuable for us.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: feedBack,
                    maxLines: 5,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    decoration: customInputDecoration(
                        hintText: "Feedback",
                        hintTextStyle:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 50,
              right: 50,
              child: InkWell(
                onTap: loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate() &&
                            ratings != null) {
                          _formKey.currentState!.save();
                          setState(() => loading = true);
                          _con
                              .doRating(widget.ride.user!.id, widget.ride.id,
                                  widget.ride.user!.driver!.id??"1", ratings.toString(), feedBack.text)
                              .then((value) {
                            Navigator.pushNamedAndRemoveUntil(context, "/Home",
                                    (Route<dynamic> route) => false)
                                .then((value) => {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Rating added successfully"),
                                        backgroundColor:
                                            Theme.of(context).errorColor,
                                      ))
                                    })
                                .catchError((onError) {
                              setState(() => loading = false);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Sorry rating not added"),
                                backgroundColor: Theme.of(context).errorColor,
                              ));
                            });
                            setState(() => loading = false);
                            return;
                          });
                        }
                      },
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: AppColors.mainBlue),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 30),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.mainBlue),
                        child: Center(
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
