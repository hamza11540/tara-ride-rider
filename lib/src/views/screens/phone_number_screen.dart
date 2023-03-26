import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../app_colors.dart';
import '../widgets/textfield_decoration.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  TextEditingController phoneNumber = TextEditingController();
  String? fullNumber;
  final _formKey = GlobalKey<FormState>();
  bool keyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/img/undraw_Contact_us_re_4qqt.png'),
              SizedBox(
                height: 30,
              ),
              const Text(
                "Let's begin",
                style: TextStyle(fontSize: 12, color: Color(0xff6E7B88)),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 250,
                child: const Text(
                  "Create your account using\nyour phone number.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              IntlPhoneField(
                flagsButtonMargin: const EdgeInsets.only(left: 20),
                dropdownIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 20,
                  color: Colors.black12,
                ),

                disableLengthCheck: false,
                dropdownIconPosition: IconPosition.trailing,
                dropdownTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff6E7B88),
                ),
                showCountryFlag: true,
                keyboardType: Platform.isIOS
                    ? const TextInputType.numberWithOptions(
                        signed: true, decimal: true)
                    : TextInputType.number,
                style: const TextStyle(color: Color(0xff6E7B88), fontSize: 12),
                controller: phoneNumber,
                decoration: customInputDecoration(
                    hintText: "Phone Number",
                    hintTextStyle:
                        const TextStyle(color: Color(0xff6E7B88), fontSize: 12)),
                initialCountryCode: 'PK',
                validator: (text) {
                  if (text == null) {
                    return 'please enter phone Number';
                  }
                  return null;
                },
                onChanged: (phone) {
                  fullNumber = '${phone.countryCode}${phone.number}';
                },
              ),
            ],
          ),
        ),
        floatingActionButton:   keyboardVisible?Container():Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("-or-",style: TextStyle(fontSize: 18),),
            ),
            SizedBox(height: 30,),

            InkWell(
              onTap: (){
                Navigator.of(context)
                    .pushNamed("/Login");
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign in with ",style: TextStyle(fontSize: 12),),
                    Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainBlue, fontSize: 12),),

                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.of(context)
                    .pushNamed("/otpScreen");
              },
              child: Container(
                margin: EdgeInsets.only(left: 30),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mainBlue),
                child: Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
