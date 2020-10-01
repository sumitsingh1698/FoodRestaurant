import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/models/restaurant_signup_model.dart';
import 'package:BellyRestaurant/ui/screens/home_page.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class OtpSignUpVerificationPage extends StatefulWidget {
  final RestaurantSignupModel userData;

  OtpSignUpVerificationPage(this.userData);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpSignUpVerificationPage>
    with SingleTickerProviderStateMixin {
  // Constants
  final int time = 30;
  AnimationController _controller;
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  int totalTimeInSeconds;
  bool _hideResendButton;
  bool _loader = false;
  AuthDataSource authData = new AuthDataSource();
  bool otpCorrectFlag = false;
  bool otpResentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();

  AppConfig _screenConfig;

  _handleOTPVerification(String otp) async {
    widget.userData.otp = otp;

    var _response =
        await authData.signUpFormAuthentication(widget.userData.toJson());
    if (_response[0]) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else
      Utils.showSnackBar(_key, _response[1]);
  }

  _handleResendOtp() async {
    otpResentFlag = await authData.sendOtpCode(widget.userData.phone);
    if (otpResentFlag) {
      Utils.showSnackBar(_key, otpResend);
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
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return new Scaffold(
      key: _key,
      appBar: CustomCloseAppBar(),
      backgroundColor: Colors.white,
      body: _loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : _getInputPart,
    );
  }

  get _getInputPart {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: _screenConfig.isLargeScreen
                ? _screenConfig.rW(20)
                : _screenConfig.rW(0),
            right: _screenConfig.isLargeScreen
                ? _screenConfig.rW(20)
                : _screenConfig.rW(0)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _screenConfig.rH(8)),
            _getVerificationCodeTitle,
            SizedBox(height: _screenConfig.rH(2)),
            _getVerificationSubHeading,
            SizedBox(height: _screenConfig.rH(16)),
            _getInputField,
            SizedBox(height: _screenConfig.rH(5)),
            _getResendButton,
          ],
        ),
      ),
    );
  }

  get _getVerificationCodeTitle {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(oneTimePassword,
          textAlign: TextAlign.left,
          style: CustomFontStyle.mainHeading2Style(blackColor)),
    );
  }

  get _getVerificationSubHeading {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(enterSignUpPassCode,
          textAlign: TextAlign.left,
          style: CustomFontStyle.buttonTextStyle(blackColor)),
    );
  }

  get _getInputField {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 20),
        child: PinCodeTextField(
          pinBoxOuterPadding:
              EdgeInsets.symmetric(horizontal: _screenConfig.rW(2)),
          autofocus: false,
          controller: controller,
          hideCharacter: false,
          defaultBorderColor: disabledGrey,
          hasTextBorderColor: blackColor,
          maxLength: pinLength,
          hasError: hasError,
          onTextChanged: (text) {
            setState(() {
              hasError = false;
            });
          },
          onDone: (_otp) {
            _handleOTPVerification(_otp);
          },
          wrapAlignment: WrapAlignment.start,
          pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 30.0),
          pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }

  get _getResendButton {
    return new Center(
        child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(_screenConfig.rH(2)),
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            resend_passcode,
            style: CustomFontStyle.regularBoldTextStyle(blueColor),
          ),
        ),
      ),
      onTap: () {
        _handleResendOtp();
      },
    ));
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }
}
