import 'dart:async';
import 'package:BellyRestaurant/models/pickup_order_model.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:BellyRestaurant/utils/base_url.dart';

class PickupOrdersDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final pickupOrdersDataUrl = baseUrl + "pickuporders/";
  static final startPickUpDataUrl = baseUrl + "startpickup/";
  List<PickupOrdersResponseModel> newOrders = [];

  Future<List<PickupOrdersResponseModel>> getPickupOrdersData(token) {
    return _netUtil
        .getData(pickupOrdersDataUrl, token)
        .then((dynamic res) async {
      List<dynamic> temp = res['results'];
      newOrders =
          (temp).map((i) => PickupOrdersResponseModel.fromJson(i)).toList();

      return newOrders;
    });
  }

  Future<List> startPickupOrder(token, id, action) async {
    String url = startPickUpDataUrl + "?is_pickup_started=$action&id=$id";
    var res = await _netUtil.changeStatus(url, token);
    if (res['status'] == "True") {
      return [true];
    } else {
      return [false, res['message']];
    }
  }
}
