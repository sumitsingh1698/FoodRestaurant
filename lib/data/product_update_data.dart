import 'dart:developer';

import 'package:BellyRestaurant/models/edit_item_response_model.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/utils/base_url.dart';
import 'dart:convert';

class ProductDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final deleteItemUrl = baseUrl + "deleteitems/";
  static final listAllItemsUrl = baseUrl + "namelist/";

  static final deletePricingUrl = baseUrl + "deletepricing/";

  Future<EditItemResponseModel> getAllItemsData(token) {
    return _netUtil.getData(listAllItemsUrl, token).then((dynamic res) async {
      print('response of initial menu $res');
      log(res.toString());
      EditItemResponseModel response = EditItemResponseModel.fromJson(res);
      return response;
    });
  }

  Future<bool> deleteItem(token, itemId) {
    String url = deleteItemUrl + "?id=$itemId";
    return _netUtil.getData(url, token).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> deletePricing(token, pricingId) {
    print("in delete Pricing");

    print("here");
    String url = deletePricingUrl + '$pricingId/';
    return _netUtil
        .deleteData(
      url,
      token,
    )
        .then((dynamic res) async {
      print("resposne of delete pricing $res");
      return res['status'];
    });
  }
}
