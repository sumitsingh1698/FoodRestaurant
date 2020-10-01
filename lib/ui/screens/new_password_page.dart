import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/ui/screens/login_page.dart';
import 'package:BellyRestaurant/ui/widgets/bottom_button.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/ui/widgets/form_field.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class PasswordResetPage extends StatefulWidget {
  final String phone;

  const PasswordResetPage({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController _passwordController = new TextEditingController();

  bool _loader = false;
  bool resetSucessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  var passKey = GlobalKey<FormFieldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  AppConfig _screenConfig;
  AuthDataSource authData = new AuthDataSource();

  _handlePasswordReset() async {
    showLoading();
    resetSucessFlag =
        await authData.resetPassword(widget.phone, _passwordController.text);
    if (resetSucessFlag) {
      _loader = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      hideLoading();
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: _screenConfig.rH(8)),
              Text(resetting_password,
                  style: CustomFontStyle.mainHeadingStyle(blackColor)),
              SizedBox(height: _screenConfig.rH(8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(enter_new_password,
                      style: CustomFontStyle.subHeadingStyle(blackColor)),
                  SizedBox(height: _screenConfig.rH(2)),
                  Container(
                    decoration: BoxDecoration(
                      color: cloudsColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(1)),
                      child: TextFormField(
                        key: passKey,
                        decoration:
                            new InputDecoration.collapsed(hintText: password),
                        style: CustomFontStyle.regularFormTextStyle(blackColor),
                        controller: this._passwordController,
                        obscureText: true,
                        validator: passwordValidator,
                      ),
                    ),
                  ),
                ],
              ),
//              CustomFormField(
//                key: passKey,
//                title: enter_new_password,
//                hint: password,
//                obscure: true,
//                controller: _passwordController,
//                fieldValidator: passwordValidator,
//              ),
              SizedBox(height: _screenConfig.rH(6)),
              Container(
                decoration: BoxDecoration(
                  color: cloudsColor,
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(1)),
                  child: TextFormField(
                    decoration: new InputDecoration.collapsed(
                        hintText: confirmPassword),
                    style: CustomFontStyle.regularFormTextStyle(greyColor),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (confirmation) {
                      var password = passKey.currentState.value;
                      return (confirmation == password)
                          ? null
                          : passwordDoNotMatch;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: _screenConfig.rH(12),
              ),
              _buildBottomButton(context),
              SizedBox(
                height: _screenConfig.rH(20),
              ),
            ],
          ),
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
              if (_formKey.currentState.validate()) {
                FocusScope.of(context).requestFocus(new FocusNode());
                _handlePasswordReset();
              }
            },
            child: BottomButton(
              text: set,
              textColor: whiteBellyColor,
              color: blackBellyColor,
            )));
  }

  String passwordValidator(String password) {
    String pattern = r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{8,20}';
    RegExp regExp = new RegExp(pattern);
    if (password.length == 0) {
      return noEmptyFields;
    } else if (!regExp.hasMatch(password)) {
      return passwordShould8digits;
    } else {
      return null;
    }
  }
}
