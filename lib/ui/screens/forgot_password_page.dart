import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/ui/widgets/bottom_button.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/ui/screens/otp_password_reset_page.dart';
import 'package:BellyRestaurant/ui/widgets/form_field.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  TextEditingController _phoneController = new TextEditingController();
  bool _loader = false;
  bool validPhoneFlag = false;
  bool otpSentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  AppConfig _screenConfig;

  AuthDataSource authData = new AuthDataSource();

  _handlePhoneVerification() async {
    showLoading();
    validPhoneFlag = await authData.sendOtpCode(
        _phoneController.text.substring(_phoneController.text.length - 10));
    if (validPhoneFlag) {
      _loader = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
                  phone: _phoneController.text
                      .substring(_phoneController.text.length - 10),
                )),
      );
    } else {
      hideLoading();
      Utils.showSnackBar(_key, invalidPhoneNumber);
    }
  }

  void showLoading() {
    setState(() {
      _loader = true;
    });
  }

  void hideLoading() {
    setState(() {
      _loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(),
      body: _loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : _buildAuthenticationUi(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: _screenConfig.rW(20), right: _screenConfig.rW(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _screenConfig.rH(8)),
            Text(forgotPassword,
                style: CustomFontStyle.mainHeadingStyle(blackColor)),
            SizedBox(height: _screenConfig.rH(8)),
            CustomFormField(
              title: pleaseEnterPhoneNumber,
              hint: phoneNumber,
              keyboardType: TextInputType.phone,
              obscure: false,
              controller: _phoneController,
            ),
            SizedBox(
              height: _screenConfig.rH(16),
            ),
            _buildBottomButton(context),
            SizedBox(
              height: _screenConfig.rH(20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
            onTap: () {
              _handlePhoneVerification();
            },
            child: BottomButton(
                text: send, color: blackColor, textColor: whiteColor)));
  }
}

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return noEmptyFields;
  } else if (value.length != 11) {
    return phoneShouldbe10Digits;
  } else if (!regExp.hasMatch(value)) {
    return "Invalid phone number";
  }
  return null;
}
