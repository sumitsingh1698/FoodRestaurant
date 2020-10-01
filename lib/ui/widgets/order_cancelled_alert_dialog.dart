import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

Future<dynamic> showOrderCancelledDialog(
    BuildContext context, Map<String, dynamic> message) {
  AppConfig _screenConfig = AppConfig(context);
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_screenConfig.rH(1))),
            //this right here
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Container(
                color: whiteColor,
                height: _screenConfig.rH(50),
                width: _screenConfig.rW(60),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(4)),
                      child: Icon(
                        Icons.notification_important,
                        color: blackColor,
                        size: 70,
                      ),
                    ),
                    SizedBox(height: _screenConfig.rH(4)),
                    Center(
                      child: new Text(
                          message['aps']['alert'] != null
                              ? message['aps']['alert']['title']
                              : "",
                          style: CustomFontStyle.buttonTextStyle(blackColor)),
                    ),
                    SizedBox(
                      height: _screenConfig.rH(1),
                    ),
                    Expanded(
                      child: Text(
                        message['aps']['alert'] != null
                            ? message['aps']['alert']['body']
                            : "",
                        textAlign: TextAlign.center,
                        style:
                            CustomFontStyle.bottomButtonTextStyle(blackColor),
                      ),
                    ),
                    Container(
                      height: _screenConfig.rH(9),
                      width: _screenConfig.rW(60),
                      color: blackColor,
                      child: Center(
                        child: Text(
                          close,
                          style: CustomFontStyle.subHeadingStyle(whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
}
