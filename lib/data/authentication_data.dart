import 'dart:async';
import 'package:BellyRestaurant/constants/constants.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/utils/base_url.dart';

class AuthDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final sendOtp = baseUrl + "sendotp/";
  static final verifyOtp = baseUrl + "verifyotp/";
  static final signUpAuthUrl = baseUrl + "signup_verifyotp/";
  static final loginAuthUrl = baseUrl + "restlogin/";
  static final resetPassUrl = baseUrl + "resetpassword/";
  static final sendFcmTokenUrl = baseUrl + "fcmrestuser/";
  static final sendSignUpOtpUrl = baseUrl + "generateotp/";

  Future<List> signUpFormAuthentication(data) {
    return _netUtil
        .signUpOtpAuthentication(signUpAuthUrl, data)
        .then((dynamic res) async {
      if (res['status']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setString('user_name', res['name']);
        prefs.setString('user_phone', res['phonenumber']);
        prefs.setBool('loggedIn', true);
        return [true];
      } else {
        return [false, res['message']];
      }
    });
  }

  Future<bool> loginPasswordAuthentication(email, password) {
    Map<String, String> body = {
      'email_address': email,
      'password': password,
    };
    return _netUtil
        .loginPasswordAuthentication(loginAuthUrl, body)
        .then((dynamic res) async {
      if (res['status']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setString('user_name', res['name']);
        prefs.setString('user_phone', res['phonenumber']);
        prefs.setBool('loggedIn', true);
        return true;
      } else {
        return false;
      }
    });
  }

  Future<List> sendSignUpOtpCode(phone, email) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
      'email_address': email,
    };

    return _netUtil.sendOtp(sendSignUpOtpUrl, body).then((dynamic res) async {
      if (res['status']) {
        print(res);
        return [true];
      } else {
        return [false, res['message']];
      }
    });
  }

  Future<bool> sendOtpCode(phone) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
    };

    return _netUtil.sendOtp(sendOtp, body).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> resetPassword(phone, password) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
      'password': password,
    };
    return _netUtil
        .loginPasswordAuthentication(resetPassUrl, body) //not changed
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> verifyOtpCode(phone, otp) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
      'otp': otp
    };

    return _netUtil.sendOtp(verifyOtp, body).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> sendFCMToken(token, fcmToken) {
    Map<String, String> body = {'fcm_token': fcmToken};
    return _netUtil
        .postFCMToken(sendFcmTokenUrl, token, body)
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }
}
