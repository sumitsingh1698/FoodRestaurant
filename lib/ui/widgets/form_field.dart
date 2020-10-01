import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final String hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscure;
  final GlobalKey<FormFieldState> fieldKey;
  final String Function(String) fieldValidator;

  const CustomFormField(
      {Key key,
      this.title,
      this.hint,
      this.keyboardType,
      this.controller,
      this.obscure,
      this.fieldKey,
      this.fieldValidator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig _screenConfig = AppConfig(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: CustomFontStyle.subHeadingStyle(blackColor)),
        SizedBox(height: _screenConfig.rH(2)),
        Container(
          decoration: BoxDecoration(
            color: cloudsColor,
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.all(_screenConfig.rH(1)),
            child: TextFormField(
              key: fieldKey,
              decoration: new InputDecoration.collapsed(hintText: hint),
              style: CustomFontStyle.regularFormTextStyle(blackColor),
              controller: this.controller,
              keyboardType: keyboardType,
              obscureText: obscure,
              validator: fieldValidator,
              cursorColor: blackColor,
            ),
          ),
        ),
      ],
    );
  }
}
