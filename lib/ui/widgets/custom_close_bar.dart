import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class CustomCloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomCloseAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig screenConfig = AppConfig(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _customAppBar(context, screenConfig)),
      ],
    );
  }

  Widget _customAppBar(BuildContext context, AppConfig _screenConfig) {
    return Padding(
      padding:
          EdgeInsets.only(top: _screenConfig.isLargeScreen ? 62 : 30, left: 8),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(
                CupertinoIcons.back,
                color: blackColor,
                size: _screenConfig.isLargeScreen
                    ? _screenConfig.rW(4)
                    : _screenConfig.rW(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40);
}
