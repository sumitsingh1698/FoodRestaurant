import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/Style.dart';

class Utils {
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: primaryBlack,
      content: new Text(message ?? 'You are offline',
          style: CustomFontStyle.regularFormTextStyle(whiteColor)),
    ));
  }
}
