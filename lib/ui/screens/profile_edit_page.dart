import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'dart:ui';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/constants.dart';
import 'package:BellyRestaurant/data/location_list_data.dart';
import 'package:BellyRestaurant/data/profile_data.dart';
import 'package:BellyRestaurant/models/location_response_model.dart';
import 'package:BellyRestaurant/models/university_model.dart';
import 'package:BellyRestaurant/models/user_model.dart';
import 'package:BellyRestaurant/ui/widgets/close_appbar.dart';
import 'package:BellyRestaurant/ui/widgets/form_field.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/base_url.dart';
import 'package:image/image.dart' as _Image;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart' as Picker;
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController _storeNameController;
  TextEditingController _firstNameController;
  TextEditingController _passwordController;
  TextEditingController _newPasswordController;
  TextEditingController _lastNameController;
  TextEditingController _mobileController;
  TextEditingController _emailController;
  TextEditingController _discountController;
  bool isLoading = true;
  SharedPreferences prefs;
  AppConfig _screenConfig;
  GlobalKey<FormState> _formKey = new GlobalKey();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var passKey = GlobalKey<FormFieldState>();
  bool _validate = false;
  File _image;
  String token;
  ListData listData = new ListData();
  ProfileDataSource profileData = new ProfileDataSource();
  UserModel _userResponse;
  static final baseUrl = BaseUrl().mainUrl;
  static final saveEditProfileUrl = baseUrl + "editprofile/";
  String oTime;
  String cTime;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getInitialData();
  }

  void getInitialData() async {
    var _response = await profileData.getMyProfileData(token);
    if (_response[0] == true) _userResponse = _response[1];
    _mobileController = new TextEditingController(text: _userResponse.phone);
    _storeNameController = new TextEditingController(text: _userResponse.name);
    _firstNameController =
        new TextEditingController(text: _userResponse.firstName);
    _lastNameController =
        new TextEditingController(text: _userResponse.lastName);
    _emailController =
        new TextEditingController(text: _userResponse.emailAddress);
    _discountController = new TextEditingController(
        text: _userResponse.discountedPercentage.toString());
    _passwordController = new TextEditingController();
    _newPasswordController = new TextEditingController();
    setState(() {
      isLoading = false;
    });
  }

  void _takeImageFromCamera() async {
    var image =
        await Picker.ImagePicker.pickImage(source: Picker.ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  void _takeImageFromGallery() async {
    var image =
        await Picker.ImagePicker.pickImage(source: Picker.ImageSource.gallery);
    _Image.Image img = _Image.decodeImage(image.readAsBytesSync());
    setState(() {
      _image = image;
    });
  }

  _handleSaveDetails() async {
    showLoading();
    if (_passwordController.text != "") {
      bool passFlag = await profileData.changePassword(
          token, _passwordController.text, _newPasswordController.text);
      if (passFlag) {
        var res = await addNewItem({
          "store_number": _userResponse.storeNumber,
          "store_id": _userResponse.id.toString(),
          "name": _storeNameController.text,
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "email_address": _emailController.text,
          "phone": _mobileController.text,
          "discounted_percentage": _discountController.text,
          "restaurant_opening_time": oTime,
          "restaurant_closing_time": cTime
        }, _image);
        Utils.showSnackBar(_scaffoldKey, profileUpdated);
      } else
        Utils.showSnackBar(_scaffoldKey, passwordDoNotMatch);
    } else {
      var res = await addNewItem({
        "store_number": _userResponse.storeNumber,
        "store_id": _userResponse.id.toString(),
        "name": _storeNameController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "email_address": _emailController.text,
        "phone": _mobileController.text,
        "discounted_percentage": _discountController.text,
        "restaurant_opening_time": oTime,
        "restaurant_closing_time": cTime
      }, _image);
      print('res of res after $res');
    }

    hideLoading();
  }

  Future<Map<String, dynamic>> addNewItem(var body, File file) async {
    print('body body is $body');
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var stream;
    var length;
    var mulipartFile;
    var request = new http.MultipartRequest("PUT",
        Uri.parse(saveEditProfileUrl + body['store_id'].toString() + "/"));
    if (file != null) {
      stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      length = await file.length();
      mulipartFile = new http.MultipartFile('logo', stream, length,
          filename: basename(file.path));
    }
    request.headers['Authorization'] = "Token " + token;
    request.fields['name'] = body['name'];
    request.fields['store_number'] = body['store_number'];
    request.fields['first_name'] = body['first_name'];

    request.fields['last_name'] = body['last_name'];
    request.fields['id'] = body['store_id'];
    request.fields['email_address'] = body['email_address'];
    request.fields['phone'] = body['phone'];
    request.fields['discounted_percentage'] = body['discounted_percentage'];
    if (oTime != null)
      request.fields['restaurant_opening_time'] =
          body['restaurant_opening_time'];
    if (cTime != null)
      request.fields['restaurant_closing_time'] =
          body['restaurant_closing_time'];
    print('inside file is file $file');
    if (file != null) {
      request.files.add(mulipartFile);
    }

    http.StreamedResponse postresponse = await request.send();
    if (postresponse.statusCode == 200) {
      print('inside sucesss sucess sucess');
      var res = await http.Response.fromStream(postresponse);
      Utils.showSnackBar(_scaffoldKey, profileUpdated);
      return json.decode(res.body);
    } else {
      hideLoading();
      print('INSIDE EXCEPTION handeling');
      throw new Exception("Error while fetching data");
    }
  }

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: CloseAppBar(),
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    color: formBgColor,
                  ),
                  _buildProfileView(context),
                ],
              ));
  }

  Widget _buildProfileView(context) {
    return Padding(
      padding: EdgeInsets.only(
          top: _screenConfig.rH(4),
          left: _screenConfig.rH(4),
          bottom: _screenConfig.rH(4),
          right: _screenConfig.rH(4)),
      child: Container(
        color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(_screenConfig.rH(5)),
              child: new Text(accountSettings,
                  style: CustomFontStyle.mediumBoldTextStyle(blackColor)),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _screenConfig.rH(4),
                    ),
                    child: InkWell(
                      onTap: () {
                        showAlertDialog(context);
                      },
                      child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              width: _screenConfig.rW(30),
                              height: _screenConfig.rH(30),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: SizedBox(
                                  height: _screenConfig.rH(20),
                                  width: _screenConfig.rH(20),
                                  child: _image == null
                                      ? CachedNetworkImage(
                                          imageUrl: _userResponse.logo != null
                                              ? _userResponse.logo
                                              : "",
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(_image),
                                ),
                              ),
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                            Container(
                              width: _screenConfig.rW(30),
                              height: _screenConfig.rH(30),
                              child: new BackdropFilter(
                                filter: new ImageFilter.blur(
                                    sigmaX: 0.0, sigmaY: 0.0),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.black.withOpacity(0.4)),
                                ),
                              ),
                            ),
                            Container(
                              width: 50.0,
                              height: 50.0,
                              child: new Image.asset(
                                'images/icons/camera_icon.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: _buildAuthenticationUi(context, _screenConfig),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticationUi(context, AppConfig _screenConfig) {
    return Padding(
      padding: EdgeInsets.only(
          left: _screenConfig.rW(_screenConfig.isLargeScreen ? 5 : 0),
          right: _screenConfig.rW(_screenConfig.isLargeScreen ? 10 : 1)),
      child: Form(
        key: _formKey,
        autovalidate: _validate,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        TimeOfDay openingTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (openingTime != null) {
                          print('otime right now $oTime');
                          setState(() {
                            oTime = openingTime.hour.toString() +
                                ":" +
                                openingTime.minute.toString();
                          });

                          print('Opening time changed to $oTime');
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Opening Time',
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          oTime == null ? SizedBox.shrink() : Text(oTime)
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () async {
                        TimeOfDay closingTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (closingTime != null) {
                          print('ctime right now $cTime');
                          setState(() {
                            cTime = closingTime.hour.toString() +
                                ":" +
                                closingTime.minute.toString();
                          });

                          print('Closing time changed to $cTime');
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Closing Time',
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          cTime == null ? SizedBox.shrink() : Text(cTime)
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  CustomFormField(
                    title: storeName,
                    hint: enterStoreName,
                    fieldValidator: validateName,
                    controller: _storeNameController,
                    obscure: false,
                  ),
                  SizedBox(height: _screenConfig.rH(6)),
                  CustomFormField(
                    title: firstName,
                    hint: enterFirstName,
                    fieldValidator: validateName,
                    controller: _firstNameController,
                    obscure: false,
                  ),
                  SizedBox(
                    width: _screenConfig.rW(2),
                  ),
                  CustomFormField(
                    title: lastName,
                    hint: "Enter Last name",
                    fieldValidator: validateName,
                    controller: _lastNameController,
                    obscure: false,
                  ),
                  SizedBox(
                    width: _screenConfig.rW(2),
                  ),
                  CustomFormField(
                    title: discount,
                    hint: enterDiscount,
                    fieldValidator: validateName,
                    controller: _discountController,
                    obscure: false,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    width: _screenConfig.rW(2),
                  ),
                  SizedBox(height: _screenConfig.rH(6)),
                  CustomFormField(
                    title: phoneNumber,
                    hint: enterPhoneNumber,
                    keyboardType: TextInputType.phone,
                    controller: _mobileController,
                    obscure: false,
                  ),
                  SizedBox(height: _screenConfig.rH(6)),
                  CustomFormField(
                    title: mailAddress,
                    hint: enterEmail,
                    fieldValidator: validateEmail,
                    controller: _emailController,
                    obscure: false,
                  ),
                  SizedBox(height: _screenConfig.rH(6)),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       color: cloudsColor,
                  //       shape: BoxShape.rectangle,
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(8.0),
                  //       )),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 4.0, horizontal: 8.0),
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<UniversityResponse>(
                  //             isExpanded: true,
                  //             items:
                  //                 universityData.map((UniversityResponse val) {
                  //               return new DropdownMenuItem<UniversityResponse>(
                  //                 value: val,
                  //                 child: new Text(val.name,
                  //                     style:
                  //                         CustomFontStyle.bottomButtonTextStyle(
                  //                             blackColor)),
                  //               );
                  //             }).toList(),
                  //             value: selectedUniversity ??
                  //                 universityData.toList()[0],
                  //             onChanged: (UniversityResponse val) {
                  //               selectedUniversity = val;
                  //               universitySelectedItem = val.name;
                  //               setState(() {
                  //                 getCampuses(val.slug);
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 1,
                  //         color: lightGrey,
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 4.0, horizontal: 8.0),
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<CampusResponse>(
                  //             isExpanded: true,
                  //             items: campusData.map((CampusResponse val) {
                  //               return new DropdownMenuItem<CampusResponse>(
                  //                 value: val,
                  //                 child: new Text(val.name,
                  //                     style:
                  //                         CustomFontStyle.bottomButtonTextStyle(
                  //                             blackColor)),
                  //               );
                  //             }).toList(),
                  //             value: selectedCampus ?? campusData.toList()[0],
                  //             onChanged: (CampusResponse val) {
                  //               selectedCampus = val;
                  //               campusSelectedItem = val.name;
                  //               setState(() {});
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                          padding: EdgeInsets.all(_screenConfig.rH(1)),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            keyboardType: TextInputType.text,
                            style: CustomFontStyle.regularFormTextStyle(
                                blackColor),
                            decoration: new InputDecoration.collapsed(
                                hintText: oldPassword),
                          ),
                        ),
                      ),
                      SizedBox(height: _screenConfig.rH(6)),
                      Container(
                        decoration: BoxDecoration(
                          color: cloudsColor,
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(_screenConfig.rH(1)),
                          child: TextFormField(
                            key: passKey,
                            controller: _newPasswordController,
                            obscureText: true,
                            style: CustomFontStyle.regularFormTextStyle(
                                blackColor),
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration.collapsed(
                                hintText: enterPassword),
                            validator: (password) {
                              String pattern =
                                  r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{8,20}';
                              RegExp regExp = new RegExp(pattern);
                              if (_passwordController.text != "") {
                                if (password.length == 0) {
                                  return noEmptyFields;
                                } else if (!regExp.hasMatch(password)) {
                                  return passwordShould8digits;
                                } else {
                                  return null;
                                }
                              } else
                                return null;
                            },
                          ),
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
                      padding: EdgeInsets.all(_screenConfig.rH(1)),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        style: CustomFontStyle.regularFormTextStyle(greyColor),
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
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _handleSaveDetails();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: blackBellyColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Container(
                        height: _screenConfig.rH(8),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Center(
                            child: Text(save,
                                style: CustomFontStyle.bottomButtonTextStyle(
                                    whiteColor)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _screenConfig.rH(10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the list options
    Widget optionOne = CupertinoDialogAction(
      child: const Text(camera),
      onPressed: () {
        _takeImageFromCamera();
        Navigator.of(context).pop();
      },
    );
    Widget optionTwo = CupertinoDialogAction(
      child: const Text(gallery),
      onPressed: () {
        _takeImageFromGallery();
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData.light(),
            child: CupertinoAlertDialog(
              title: const Text(restaurantImage),
              content: new Text(eitherFromCameraOrGallery),
              actions: <Widget>[
                optionOne,
                optionTwo,
              ],
            ));
      },
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
  } else if (value.length != 11) {
    return phoneShouldbe10Digits;
  } else if (!regExp.hasMatch(value)) {
    return "Invalid phone number";
  }
  return null;
}
