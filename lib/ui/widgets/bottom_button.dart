import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  const BottomButton({Key key, this.text, this.color, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig _screenConfig = AppConfig(context);
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        height: _screenConfig.isLargeScreen
            ? _screenConfig.rH(8)
            : _screenConfig.rH(12),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Text(
              text,
              style: CustomFontStyle.bottomButtonTextStyle(textColor),
            ),
          ),
        ),
      ),
    );
  }
}
