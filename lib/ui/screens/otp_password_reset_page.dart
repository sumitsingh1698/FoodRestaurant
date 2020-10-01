import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/ui/screens/new_password_page.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  final String label;

  const OtpVerificationPage({
    Key key,
    @required this.phone,
    @required this.label,
  }) : super(key: key);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpVerificationPage>
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

  AuthDataSource authData = new AuthDataSource();
  bool otpCorrectFlag = false;
  bool otpResentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();

  AppConfig _screenConfig;

  _handleOTPVerification(String otp) async {
    otpCorrectFlag = await authData.verifyOtpCode(widget.phone, otp);
    if (otpCorrectFlag) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordResetPage(
                  phone: widget.phone,
                )),
      );
    } else
      Utils.showSnackBar(_key, invalidCode);
  }

  _handleResendOtp() async {
    otpResentFlag = await authData.sendOtpCode(widget.phone);
    if (otpResentFlag) {
      Utils.showSnackBar(_key, otpResend);
    }
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
      body: _getInputPart,
    );
  }

  get _getInputPart {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: _screenConfig.rW(20), right: _screenConfig.rW(20)),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _screenConfig.rH(8)),
            _getVerificationCodeLabel,
            SizedBox(height: _screenConfig.rH(16)),
            _getInputField,
            SizedBox(height: _screenConfig.rH(5)),
            _getResendButton,
          ],
        ),
      ),
    );
  }

  get _getVerificationCodeLabel {
    return new Text(enter_passcode,
        textAlign: TextAlign.left,
        style: CustomFontStyle.mainHeading2Style(blackColor));
  }

  get _getInputField {
    return Padding(
      padding: EdgeInsets.only(left: _screenConfig.rW(10)),
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
