import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/data/home_page_data.dart';

class CountModel extends ChangeNotifier {
  CountModel() {
    getSharedPrefs();
  }

  /// Internal, private state of the cart.
  int newOrderCount;
  int pickUpOrderCount;
  int orderHistoryCount;

  void getCountData(token) async {
    HomePageDataSource _dataSource = new HomePageDataSource();
    var data = await _dataSource.getTabCountsData(token);
    if (data['status']) {
      print(data);
      newOrderCount = data['tabview']['neworder'];
      pickUpOrderCount = data['tabview']['pickup'];
      orderHistoryCount = data['tabview']['orderhistory'];
    } else {
      newOrderCount = 0;
      pickUpOrderCount = 0;
      orderHistoryCount = 0;
    }
    print('get count data');
    notifyListeners();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String token = prefs.getString('token');
      getData(token);
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  void getData(token) async {
    Timer.periodic(Duration(seconds: 10), (Timer t) => getCountData(token));
  }

  int get getNewOrderCount => newOrderCount;

  int get getPickUpOrderCount => pickUpOrderCount;
  int get getOrderHistoryCount => orderHistoryCount;

  void updateNewOrderCount(int c) {
    newOrderCount = c;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updatePickupOrderCount(int p) {
    pickUpOrderCount = p;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updateOrderHistoryCount(int p) {
    orderHistoryCount = p;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
