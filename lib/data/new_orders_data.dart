import 'dart:async';
import 'package:BellyRestaurant/models/new_order_model.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:BellyRestaurant/utils/base_url.dart';

class NewOrdersDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final newOrdersUrl = baseUrl + "neworders/";
  static final acceptOrderUrl = baseUrl + "acceptrejectorder/";
  List<NewOrderModel> newOrders = [];

  Future<List<NewOrderModel>> getNewOrdersData(token) {
    return _netUtil
        .getNewOrdersData(newOrdersUrl, token)
        .then((dynamic res) async {
      print("respose of Restaurant is $res");
      List<dynamic> temp = res['results'];
      newOrders = (temp).map((i) => NewOrderModel.fromJson(i)).toList();
      return newOrders;
    });
  }

  Future<List> acceptRejectOrder(token, id, action) async {
    String url = acceptOrderUrl;
    // + "?is_restaurant_accepted=$action&id=$id";
    Map body = {"is_restaurant_accepted": action, "id": id};
    var res = await _netUtil.acceptorreject(url, token, body);
    if (res['status']) {
      return [true];
    } else {
      return [false, res['message']];
    }
  }
}
