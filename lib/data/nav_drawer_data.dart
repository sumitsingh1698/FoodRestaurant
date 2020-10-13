import 'dart:async';
import 'package:BellyRestaurant/models/list_menu_item_model.dart';
import 'package:BellyRestaurant/models/new_order_model.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:BellyRestaurant/utils/base_url.dart';

class NavDrawerDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final allItemsStatusUrl = baseUrl + "listitems/";
  static final changeItemStatusUrl = baseUrl + "updatefoodstatus/";
  static final changeRestaurantStatusUrl = baseUrl + "updaterestaurant/";

  Future<ListItemResponseModel> itemStatusDetail(token) {
    return _netUtil
        .getRestaurantItems(allItemsStatusUrl, token)
        .then((dynamic res) async {
      print("itemStatusDetail $res");
      ListItemResponseModel response = ListItemResponseModel.fromJson(res);
      return response;
    });
  }

  Future<bool> changeItemStatus(token, id, status) async {
    String url = changeItemStatusUrl + "?id=$id&avail_status=$status";
    var res = await _netUtil.changeStatus(url, token);
    if (res['status'] == "True") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeRestaurantStatus(token, status) async {
    String url = changeRestaurantStatusUrl + "?avail_status=$status";
    var res = await _netUtil.changeStatus(url, token);
    if (res['status'] == "True") {
      return true;
    } else {
      return false;
    }
  }
}
