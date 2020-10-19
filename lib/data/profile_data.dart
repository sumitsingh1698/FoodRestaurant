import 'dart:developer';

import 'package:BellyRestaurant/models/user_model.dart';
import 'package:BellyRestaurant/utils/base_url.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';

class ProfileDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final myProfileDataUrl = baseUrl + "myprofile/";
  static final changePasswordUrl = baseUrl + "changepassword/";

  Future<List> getMyProfileData(token) {
    return _netUtil
        .getCartDetails(myProfileDataUrl, token)
        .then((dynamic res) async {
      UserModel response;
      if (res['results'].isNotEmpty) {
        log(res.toString());
        response = UserModel.fromJson(res['results'][0]);
      }

      if (response != null) {
        return [true, response];
      } else {
        return [false, "No data"];
      }
    });
  }

  Future<bool> changePassword(token, password, newPassword) {
    Map<String, String> body = {
      'old_password': password,
      'new_password': newPassword
    };
    return _netUtil
        .putData(
      changePasswordUrl,
      body,
      token,
    )
        .then((dynamic res) async {
      return res['status'];
    });
  }
}
