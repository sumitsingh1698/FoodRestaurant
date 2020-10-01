import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/ui/screens/forgot_password_page.dart';
import 'package:BellyRestaurant/ui/screens/home_page.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/ui/widgets/form_field.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  bool _loader = false;
  bool loginSuccessFlag = false;
  bool _validate = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  AuthDataSource authData = new AuthDataSource();
  AppConfig _screenConfig;

  @override
  void initState() {
    super.initState();

    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _handleLogin() async {
    showLoading();
    loginSuccessFlag = await authData.loginPasswordAuthentication(
        _emailController.text, _passwordController.text);
    if (loginSuccessFlag) {
      _loader = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      hideLoading();
      Utils.showSnackBar(_scaffoldKey, loginError);
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
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: CustomCloseAppBar(),
      body: (_loader)
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
      child: Form(
        key: _formKey,
        autovalidate: _validate,
        child: Padding(
          padding: EdgeInsets.only(
              left: _screenConfig.rW(20), right: _screenConfig.rW(20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: _screenConfig.rH(8)),
              Text(login, style: CustomFontStyle.mainHeadingStyle(blackColor)),
              SizedBox(height: _screenConfig.rH(8)),
              CustomFormField(
                fieldValidator: validateEmail,
                title: enterEmail,
                hint: mailAddress,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                obscure: false,
              ),
              SizedBox(height: _screenConfig.rH(6)),
              CustomFormField(
                title: enterPassword,
                hint: password,
                obscure: true,
                controller: _passwordController,
              ),
              SizedBox(height: _screenConfig.rH(4)),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(_screenConfig.rH(1)),
                    child: Text(forgotPassword,
                        style:
                            CustomFontStyle.regularBoldTextStyle(greenColor)),
                  )),
              SizedBox(
                height: _screenConfig.rH(8),
              ),
              _buildBottomButton(
                  context,
                  _screenConfig.isLargeScreen
                      ? _screenConfig.rH(8)
                      : _screenConfig.rH(12)),
              SizedBox(
                height: _screenConfig.rH(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(context, _height) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
          FocusScope.of(context).requestFocus(new FocusNode());
          _handleLogin();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: blackBellyColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Container(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Text(
                login,
                style: CustomFontStyle.bottomButtonTextStyle(whiteBellyColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return noEmptyFields;
    } else if (!regExp.hasMatch(value)) {
      return invalidEmail;
    } else {
      return null;
    }
  }
}
