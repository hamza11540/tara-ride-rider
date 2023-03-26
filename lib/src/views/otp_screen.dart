import 'dart:io';

import 'package:driver_app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController controller = TextEditingController();
  String onDone = '';
  bool keyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.mainBlue,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            const Text(
              "Verify your OTP",
              style: TextStyle(fontSize: 12, color: const Color(0xff6E7B88)),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "We've sent you 6-digit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "code on: ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "+92123456789",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: PinCodeTextField(
                    autofocus: true,
                    controller: controller,
                    highlight: true,
                    highlightColor: AppColors.lightBlue2,
                    defaultBorderColor: AppColors.lightBlue3,
                    hasTextBorderColor: AppColors.lightBlue2,
                    highlightPinBoxColor: AppColors.lightBlue2,
                    pinBoxColor: AppColors.lightBlue3,
                    maxLength: 6,
                    onTextChanged: (text) {
                      onDone = text;
                      setState(() {});
                      print("DONE $text");
                      print("DONE CONTROLLER ${onDone}");
                    },
                    pinBoxWidth: 46,
                    pinBoxHeight: 65,
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinBoxDecoration:
                        ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinTextStyle: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                    pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration:
                        const Duration(milliseconds: 300),
                    highlightAnimationBeginColor: AppColors.darkBlue,
                    pinBoxRadius: 12,
                    highlightAnimationEndColor: Colors.white12,
                    keyboardType: Platform.isIOS
                        ? const TextInputType.numberWithOptions(
                            signed: true, decimal: true)
                        : TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Didn't received the code? ",
                  style: TextStyle(fontSize: 12, color: const Color(0xff6E7B88)),
                ),
                Text(
                  "Send Again",
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mainBlue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: keyboardVisible
          ? Container()
          : onDone.length == 6
              ? Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.mainBlue),
                    child: const Center(
                        child: Text(
                      "Verify Code",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white),
                    )),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xffB4BBC1)),
                    child: const Center(
                        child: Text(
                      "Verify Code",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white),
                    )),
                  ),
                ),
    );
  }
}

