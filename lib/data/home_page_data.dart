import 'dart:async';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:BellyRestaurant/utils/base_url.dart';

class HomePageDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final newOrdersUrl = baseUrl + "tabview/";

  Future<Map> getTabCountsData(token) {
    return _netUtil.getData(newOrdersUrl, token).then((dynamic res) async {
      
      return res;
    });
  }
}
