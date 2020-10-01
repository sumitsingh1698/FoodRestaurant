import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'dart:ui';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/constants/constants.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/models/restaurant_signup_model.dart';
import 'package:BellyRestaurant/ui/screens/signup_second_page.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/ui/widgets/form_field.dart';
import 'package:BellyRestaurant/ui/widgets/place_picker.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  TextEditingController _storeNameController;
  TextEditingController _firstNameController;
  TextEditingController _passwordController;
  TextEditingController _buildingNameController;
  TextEditingController _lastNameController;
  TextEditingController _mobileController;
  TextEditingController _emailController;
  RestaurantLocation _resLocation;

  var universitySelectedItem = "Waseda University",
      campusSelectedItem = "Waseda Campus";
  bool _loader = false;
  bool signUpSuccessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  var passKey = GlobalKey<FormFieldState>();
  bool _validate = false;
  var signUpResponse;
  AppConfig screenConfig;
  AuthDataSource authData = new AuthDataSource();
  bool successFlag = false;
  String _storeAddress = storeAddress;

  @override
  void initState() {
    super.initState();
    _storeNameController = new TextEditingController();
    _firstNameController = new TextEditingController();
    _buildingNameController = new TextEditingController();
    _lastNameController = new TextEditingController();
    _mobileController = new TextEditingController();
    _passwordController = new TextEditingController();
    _emailController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleSignUpDataSubmission() async {
    //showLoading();
    String phone = _mobileController.text;
    RestaurantSignupModel _userData = RestaurantSignupModel(
      _emailController.text,
      _passwordController.text,
      _firstNameController.text,
      _lastNameController.text,
      countryCode,
      phone,
      _storeNameController.text,
      _buildingNameController.text,
      _resLocation,
      'xxx',
      'xxx',
      phone,
      'xxxx',
    );
    // hideLoading();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SignUpStoreSetupPage(userData: _userData)),
    );
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
    screenConfig = AppConfig(context);
    return new Scaffold(
      key: _key,
      backgroundColor: whiteColor,
      appBar: CustomCloseAppBar(),
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : SingleChildScrollView(
              child: _buildAuthenticationUi(context, screenConfig),
            ),
    );
  }

  Widget _buildAuthenticationUi(context, AppConfig _screenConfig) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenConfig.isLargeScreen
              ? screenConfig.rW(20)
              : screenConfig.rW(8),
          right: _screenConfig.isLargeScreen
              ? screenConfig.rW(20)
              : screenConfig.rW(8)),
      child: Form(
        key: _formKey,
        autovalidate: _validate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _screenConfig.rH(8)),
            Text(signup, style: CustomFontStyle.mainHeadingStyle(blackColor)),
            SizedBox(height: _screenConfig.rH(8)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomFormField(
                  title: storeName,
                  hint: enterStoreName,
                  fieldValidator: validateName,
                  controller: _storeNameController,
                  obscure: false,
                ),
                SizedBox(height: _screenConfig.rH(6)),
                Row(
                  children: <Widget>[
                    Expanded(
                      // flex: 1,
                      child: InkWell(
                          onTap: () async {
                            LocationResult result =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  map_api_key,
                                ),
                              ),
                            );
                            if (result != null) {
                              print("result " +
                                  result.name +
                                  "?" +
                                  result.street);
                              _resLocation = RestaurantLocation(
                                  "${result.name},${result.latLng.latitude},${result.latLng.longitude}");
                              setState(() {
                                _storeAddress = result.name;
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(storeLocation,
                                  style: CustomFontStyle.subHeadingStyle(
                                      blackColor)),
                              SizedBox(height: _screenConfig.rH(2)),
                              Container(
                                height: screenConfig.isLargeScreen
                                    ? screenConfig.rH(7)
                                    : screenConfig.rH(12),
                                width: screenConfig.isLargeScreen
                                    ? screenConfig.rW(27)
                                    : screenConfig.rW(40),
                                decoration: BoxDecoration(
                                  color: cloudsColor,
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(_screenConfig.rH(2)),
                                  child: Text(_storeAddress,
                                      style:
                                          CustomFontStyle.regularFormTextStyle(
                                              blackColor)),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: _screenConfig.rW(2),
                    ),
                    Expanded(
                      // flex: 1,
                      child: CustomFormField(
                        title: buildingNameRoomNumber,
                        hint: buildingNameRoomNumber,
                        fieldValidator: validateName,
                        controller: _buildingNameController,
                        obscure: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _screenConfig.rH(6)),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CustomFormField(
                        title: firstName,
                        hint: enterFirstName,
                        fieldValidator: validateName,
                        controller: _firstNameController,
                        obscure: false,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomFormField(
                        title: lastName,
                        hint: enterSecondName,
                        fieldValidator: validateName,
                        controller: _lastNameController,
                        obscure: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _screenConfig.rH(6)),
                CustomFormField(
                  title: phoneNumber,
                  hint: enterPhoneNumber,
                  keyboardType: TextInputType.phone,
                  fieldValidator: validateMobile,
                  controller: _mobileController,
                  obscure: false,
                ),
                SizedBox(height: _screenConfig.rH(6)),
                CustomFormField(
                  title: mailAddress,
                  hint: enterEmail,
                  fieldValidator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  obscure: false,
                ),
                SizedBox(height: _screenConfig.rH(6)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(password,
                        style: CustomFontStyle.subHeadingStyle(blackColor)),
                    SizedBox(height: _screenConfig.rH(2)),
                    Container(
                      decoration: BoxDecoration(
                        color: cloudsColor,
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(_screenConfig.rH(2)),
                        child: TextFormField(
                            key: passKey,
                            cursorColor: blackColor,
                            obscureText: true,
                            controller: _passwordController,
                            style: CustomFontStyle.regularFormTextStyle(
                                blackColor),
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration.collapsed(
                                hintText: enterPassword),
                            validator: passwordValidator),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _screenConfig.rH(2)),
                Container(
                  decoration: BoxDecoration(
                    color: cloudsColor,
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(_screenConfig.rH(2)),
                    child: TextFormField(
                      cursorColor: blackColor,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: CustomFontStyle.regularFormTextStyle(blackColor),
                      decoration: new InputDecoration.collapsed(
                          hintText: confirmPassword),
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
                  height: _screenConfig.rH(10),
                ),
                _buildBottomButton(
                    context,
                    screenConfig.isLargeScreen
                        ? screenConfig.rH(8)
                        : screenConfig.rH(12)),
                SizedBox(
                  height: _screenConfig.rH(20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(context, _height) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate() && _storeAddress != storeAddress) {
          _handleSignUpDataSubmission();
        } else
          Utils.showSnackBar(_key, noEmptyFields);
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
              child: Text(next,
                  style: CustomFontStyle.bottomButtonTextStyle(whiteColor)),
            ),
          ),
        ),
      ),
    );
  }
}

String validateName(String value) {
  if (value.length == 0) {
    return noEmptyFields;
  }
  return null;
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

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return noEmptyFields;
  } else if (value.length != 10) {
    return phoneShouldbe10Digits;
  } else if (!regExp.hasMatch(value)) {
    return "Invalid phone number";
  }
  return null;
}
