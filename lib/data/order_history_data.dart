import 'dart:async';
import 'package:BellyRestaurant/models/order_history_model.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';
import 'package:BellyRestaurant/utils/base_url.dart';

class OrderHistoryDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final orderHistoryRangeDataUrl = baseUrl + "orderhistory/";
  static final orderHistoryTodayDataUrl = baseUrl + "todayorderhistory/";
  List<OrderHistoryModel> orderHistory = [];

  Future<List<OrderHistoryModel>> getOrderHistoryData(
      bool today, String date1, String date2, token, String _page) {
    String formattedDate1 = date1.substring(0, 4) +
        "-" +
        date1.substring(5, 7) +
        "-" +
        date1.substring(8, 10);
    String formattedDate2 = date2.substring(0, 4) +
        "-" +
        date2.substring(5, 7) +
        "-" +
        date2.substring(8, 10);
    String url = orderHistoryRangeDataUrl +
        "?date1=$formattedDate1&date2=$formattedDate2&page=$_page";
    if (today) {
      url = orderHistoryTodayDataUrl + "?page=$_page";
    }
    return _netUtil.getOrderHistory(url, token).then((dynamic res) async {
      List<dynamic> temp = res['results'];
      orderHistory = (temp).map((i) => OrderHistoryModel.fromJson(i)).toList();

      return orderHistory;
    });
  }
}
