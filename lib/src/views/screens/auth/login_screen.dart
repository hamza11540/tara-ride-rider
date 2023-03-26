import 'package:driver_app/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../controllers/user_controller.dart';
import '../../../helper/dimensions.dart';
import '../../../helper/images.dart';
import '../../../helper/styles.dart';
import '../../../models/custom_exception.dart';
import '../../../models/exceptions_enum.dart';
import '../../../models/screen_argument.dart';
import '../../../repositories/user_repository.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends StateMVC<LoginScreen> {
  late UserController _userCon;
  late FToast fToast;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool loading = false;
  bool rememberMe = false;
  String email = "";
  String password = "";

  LoginScreenState() : super(UserController()) {
    _userCon = controller as UserController;
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _userCon.scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/img/undraw_Mobile_login_re_9ntv.png"),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                        fontSize: 12, color: const Color(0xff6E7B88)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Login to get through the app...",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    hintText: AppLocalizations.of(context)!.email,
                    labelText: AppLocalizations.of(context)!.email,
                    focusNode: _emailFocus,
                    nextFocus: _passwordFocus,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    onSave: (String value) {
                      email = value;
                    },
                    isRequired: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "\u26A0 ${AppLocalizations.of(context)!.enterEmail}";
                      } else if (!isEmail(value)) {
                        return "\u26A0 ${AppLocalizations.of(context)!.enterValidEmail}";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      nextFocus: FocusNode(),
                      hintText:
                      AppLocalizations.of(context)!.password,
                      labelText:
                      AppLocalizations.of(context)!.password,
                      isPassword: true,
                      focusNode: _passwordFocus,
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                      onSave: (String value) {
                        password = value;
                      },
                      isRequired: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "\u26A0 ${AppLocalizations.of(context)!.enterPassword}";
                        }
                        return null;
                      }),
                  const SizedBox(height: 15),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color:
                              Colors.blueAccent.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 1)),
                        ],
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      onPressed: loading
                          ? () {}
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => loading = true);
                          await _userCon
                              .doLogin(
                              email, password, rememberMe)
                              .then((value) {
                            Navigator.pushReplacementNamed(
                                context, "/Home");
                          }).catchError((error) {
                            if (error.runtimeType ==
                                CustomException &&
                                error.exception ==
                                    ExceptionsEnum.userStatus) {
                              Navigator.of(context)
                                  .pushReplacementNamed(
                                '/DriverStatus',
                                arguments: ScreenArgument({
                                  'status': currentUser
                                      .value.driver!.status!,
                                  'observacao': currentUser
                                      .value
                                      .driver!
                                      .statusObservation
                                }),
                              );
                            } else {
                              fToast.showToast(
                                  child: CustomToast(
                                    backgroundColor: Colors.red,
                                    icon: Icon(Icons.close,
                                        color: Colors.white),
                                    text: error.toString(),
                                    textColor: Colors.white,
                                  ),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(
                                      seconds: 3));
                            }
                          });
                          setState(() => loading = false);
                          return;
                        }
                      },
                      child: loading
                          ? CircularProgressIndicator(
                          color: Theme.of(context).highlightColor)
                          : Text(
                        AppLocalizations.of(context)!.login,
                        style: poppinsSemiBold.copyWith(
                            color: Theme.of(context)
                                .highlightColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: loading
                            ? () {}
                            : () {
                          Navigator.of(context)
                              .pushNamed('/ForgotPassword');
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .forgetPassword,
                          textAlign: TextAlign.end,
                          style: poppinsRegular.copyWith(
                            color: Colors.black,
                              fontSize: 12

                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  InkWell(
                    onTap: loading
                        ? () {}
                        : () {
                      Navigator.of(context)
                          .pushNamed('/Signup');
                    },
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account? ",
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 12
                            ),
                          ),
                          Text(
                            "SignUp",
                            style: poppinsRegular.copyWith(
                              color: AppColors.mainBlue,
                                fontSize: 12,
                              fontWeight: FontWeight.bold

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
