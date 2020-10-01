import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart' as prefix0;
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/ui/screens/login_page.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/ui/screens/signup_page.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  bool _loader = false;
  bool otpSentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  AppConfig screenConfig;

  @override
  Widget build(BuildContext context) {
    screenConfig = AppConfig(context);
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : Padding(
              padding:
                  // EdgeInsets.only(top: 20),
                  EdgeInsets.only(
                      left: screenConfig.rHP(30), right: screenConfig.rHP(30)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(titleWelcomeText,
                      style: CustomFontStyle.mainHeadingStyle(blackColor)),
                  SizedBox(
                    height: screenConfig.rH(10),
                  ),
                  _buildLoginButton(
                      context,
                      screenConfig.isLargeScreen
                          ? screenConfig.rH(8)
                          : screenConfig.rH(12)),
                  SizedBox(
                    height: screenConfig.rH(8),
                  ),
                  _buildSignUpButton(
                      context,
                      screenConfig.isLargeScreen
                          ? screenConfig.rH(8)
                          : screenConfig.rH(12)),
                ],
              ),
            ),
    );
  }
}

Widget _buildLoginButton(context, _height) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: greenBellyColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Container(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Text(login,
                  style: CustomFontStyle.buttonTextStyle(whiteBellyColor)),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildSignUpButton(context, _height) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: blackColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Container(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Text(signup,
                  style: CustomFontStyle.buttonTextStyle(whiteColor)),
            ),
          ),
        ),
      ),
    ),
  );
}
