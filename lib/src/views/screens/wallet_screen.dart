import 'package:driver_app/app_colors.dart';
import 'package:driver_app/src/controllers/ride_controller.dart';
import 'package:driver_app/src/models/ride.dart';
import 'package:driver_app/src/repositories/user_repository.dart';
import 'package:driver_app/src/views/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../widgets/textfield_decoration.dart';

class WalletScreen extends StatefulWidget {
  final Ride ride;
  const WalletScreen({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends StateMVC<WalletScreen> {
  TextEditingController amount = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  late RideController _con;
  _WalletScreenState() : super(RideController()) {
    _con = controller as RideController;
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainBlue,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 1,
          shadowColor: Theme.of(context).primaryColor,
          title: Text("Wallet Transfer"),
          centerTitle: true,
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Drawer(
            child: MenuWidget(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/img/y2020-11-19-65_generated-removebg-preview.png'),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: AppColors.lightBlue3,
                    title: Text(
                      "Available Balance:",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text('${currentUser.value.wallet}.0 \$'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: amount,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  decoration: customInputDecoration(
                      hintText: "Amount",
                      hintTextStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() => loading = true);
                            _con
                                .doWalletTransfer(
                              currentUser.value.id,
                              widget.ride.user!.id,
                              amount.text,
                            )
                                .then((value) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                      "/Home", (Route<dynamic> route) => false)
                                  .catchError((onError) {
                                setState(() => loading = false);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text("Amount not added Successfully"),
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
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.mainBlue),
                          child: Center(
                            child: Text(
                              "Add Amount",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
