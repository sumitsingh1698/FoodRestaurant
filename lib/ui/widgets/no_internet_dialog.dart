import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

Future<dynamic> showDialogNotInternet(BuildContext context) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _buildLogoutConfirmDialog(context));
}

Widget _buildLogoutConfirmDialog(context) {
  AppConfig _screenConfig = AppConfig(context);
  return Center(
    child: Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: offWhite),
      child: AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              left: _screenConfig.rW(2), right: _screenConfig.rW(2)),
          child: Column(
            children: <Widget>[
              Text(
                networkError,
                style: CustomFontStyle.mediumBoldTextStyle(blackColor),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: _screenConfig.rW(2), bottom: _screenConfig.rW(2)),
                child: Text(
                  networkError2,
                  textAlign: TextAlign.left,
                  style: CustomFontStyle.mediumTextStyle(blackColor),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
