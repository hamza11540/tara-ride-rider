// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:convert';
import 'package:driver_app/src/helper/custom_trace.dart';
import 'package:driver_app/src/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helper/location.dart';
import '../models/custom_exception.dart';
import '../models/exceptions_enum.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../services/user_service.dart';

class UserController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  UserRepository userRepository = UserRepository();
  late User user;
  bool loading = false;
  double? valueToday;
  double? valueYesterday;
  double? valueWeek;
  double? valuePending;

  UserController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<void> doLoadUser() async {
    await userRepository.getCurrentUser();
  }

  Future<void> doLogin(String email, String password, bool rememberMe) async {
    await login(email, password, rememberMe).then((User user) async {
      await userRepository.setUser(user);
      try {
        await NotificationRepository().updateFcmToken(user);
      } catch (error) {
        print(CustomTrace(StackTrace.current, message: error.toString()));
      }
    }).catchError((error) async {
      if (error.runtimeType == CustomException &&
          error.exception == ExceptionsEnum.userStatus) {
        await userRepository.setUser(error.data['user']);
        try {
          await NotificationRepository().updateFcmToken(error.data['user']);
        } catch (error) {
          print(CustomTrace(StackTrace.current, message: error.toString()));
        }
        throw error;
      } else {
        if (error.message == HttpStatus.unauthorized) {
          throw AppLocalizations.of(scaffoldKey.currentContext!)!
              .incorrectEmailPassword;
        }
        throw AppLocalizations.of(scaffoldKey.currentContext!)!.errorLogin;
      }
    });
  }

  Future<void> doUpdateRegister(
    User user,
    File? driverLicense,
  ) async {
    await updateRegister(
      user,
      driverLicense,
    ).then((User user) async {
      await userRepository.setUser(user);
      try {
        await NotificationRepository().updateFcmToken(user);
      } catch (error) {
        print(CustomTrace(StackTrace.current, message: error.toString()));
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> doRegister(
    User user,
    File? driverLicense,
  ) async {
    await register(
      user,
      driverLicense,
    ).then((User user) async {
      await userRepository.setUser(user);
      try {
        await NotificationRepository().updateFcmToken(user);
      } catch (error) {
        print(CustomTrace(StackTrace.current, message: error.toString()));
      }
      ;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> doProfileUpdate(String name, String email, String phone,
      {String? password}) async {
    await profileUpdate(name, email, phone, password: password)
        .then((User user) async {
      await userRepository.setUser(user);
      try {
        await NotificationRepository().updateFcmToken(user);
      } catch (error) {
        print(CustomTrace(StackTrace.current, message: error.toString()));
      }
      ;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> doProfilePictureUpload(File file) async {
    await profilePictureUpload(file).then((User user) async {
      await userRepository.setUser(user);
      setState(() {
        currentUser;
      });
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> doLogout() async {
    user = await userRepository.getCurrentUser();
    if (user.auth) {
      user.firebaseToken = '';
      try {
        await NotificationRepository().updateFcmToken(user);
      } catch (error) {
        print(CustomTrace(StackTrace.current, message: error.toString()));
      }
    }
    await userRepository.logout();
  }

  Future<void> doForgotPassword(String email) async {
    await forgotPassword(email).then((data) async {
      return true;
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> doVerifyLogin() async {
    await doLoadUser().catchError((error) async {
      await doLogout();
    });
    if (currentUser.value.id.isEmpty) {
      return;
    }
    await verifyLogin(currentUser.value.token).then((User user) async {
      await userRepository.setUser(user);
    }).catchError((error) async {
      if (error.runtimeType == CustomException &&
          error.exception == ExceptionsEnum.userStatus) {
        await userRepository.setUser(error.data['user']);
        throw error;
      } else {
        if (error.message == HttpStatus.unauthorized) {
          await doLogout();
        } else {
          throw AppLocalizations.of(scaffoldKey.currentContext!)!
              .verifyConnection;
        }
      }
    });
  }

  Future<void> doLoadValues() async {
    await loadValues().then((Map<String, double> values) async {
      setState(() {
        valuePending = values['pending'];
        valueWeek = values['week'];
        valueToday = values['today'];
        valueYesterday = values['yesterday'];
      });
    }).catchError((error) {
      throw AppLocalizations.of(scaffoldKey.currentContext!)!.errorUpdateStatus;
    });
  }

  Future<void> doGetRideActive() async {
    await getRideActive().then((bool active) async {
      await userRepository
          .setActiveStatus(active)
          .then((value) => setState(() => currentUser.value.driver?.active));
    }).catchError((error) {
      throw AppLocalizations.of(scaffoldKey.currentContext!)!.errorUpdateStatus;
    });
  }

  Future<void> doUpdateRideActive(bool active) async {
    userRepository.setActiveStatus(active).then(
          (value) => setState(() => currentUser.value.driver?.active),
        );
    await updateRideActive(active).then((bool isActive) async {
      currentUser.notifyListeners();
    }).catchError((error) async {
      await userRepository.setActiveStatus(!active).then(
            (value) => setState(() => currentUser.value.driver?.active),
          );

      throw jsonDecode(error.message)['message'] ??
          AppLocalizations.of(scaffoldKey.currentContext!)!.errorChangeStatus;
    });
  }

  Future<void> doUpdateLocation(
      {LocationData? location,
      bool withDialogs = true,
      bool dialogsRequired = false}) async {
    if (location == null) {
      location = await LocationHelper.getLocation(state?.context,
              withDialogs: withDialogs, dialogsRequired: dialogsRequired)
          .catchError((error) {
        print(CustomTrace(StackTrace.current, message: error.toString()));
        throw AppLocalizations.of(state!.context)?.noLocationPermission ?? '';
      });
    }
    await updateLocation(location).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
    });
  }

  Future<void> doDeleteAccount() async {
    await deleteAccount().catchError((error) {
      throw error;
    });
  }
}
