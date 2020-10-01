import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class CloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CloseAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig screenConfig = AppConfig(context);
    return _customAppBar(context, screenConfig);
  }

  Widget _customAppBar(BuildContext context, AppConfig _screenConfig) {
    return Container(
      color: blackColor,
      child: Container(
        margin: EdgeInsets.only(top: _screenConfig.rH(3)),
        color: whiteColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: _screenConfig.rH(1), horizontal: _screenConfig.rW(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Padding(
                  padding: EdgeInsets.only(top: _screenConfig.rH(3)),
                  child: Icon(
                    Icons.close,
                    color: blackColor,
                    size: _screenConfig.rW(_screenConfig.isLargeScreen ? 4 : 8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(90);
}
