import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/data/location_list_data.dart';
import 'package:BellyRestaurant/models/campus_model.dart';
import 'package:BellyRestaurant/models/food_type_model.dart';
import 'package:BellyRestaurant/models/restaurant_signup_model.dart';
import 'package:BellyRestaurant/models/university_model.dart';
import 'package:BellyRestaurant/ui/screens/signup_otp_page.dart';
import 'package:BellyRestaurant/ui/widgets/bottom_button.dart';
import 'package:BellyRestaurant/ui/widgets/custom_close_bar.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/ui/widgets/form_field.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class SignUpStoreSetupPage extends StatefulWidget {
  final RestaurantSignupModel userData;

  const SignUpStoreSetupPage({
    Key key,
    @required this.userData,
  }) : super(key: key);

  @override
  _SignUpStoreSetupState createState() => _SignUpStoreSetupState();
}

class _SignUpStoreSetupState extends State<SignUpStoreSetupPage> {
  TextEditingController _storeNumberController;

  bool _loader = true;
  bool signUpSuccessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  AppConfig _screenConfig;
  List<UniversityResponse> universityData = [];
  List<CampusResponse> campusData = [];
  List<FoodTypeResponse> foodTypeData = [];
  FoodTypeResponse selectedFoodType;
  ListData listData = new ListData();
  AuthDataSource authData = new AuthDataSource();
  bool otpSentFlag = false;
  bool _isButtonDisabled;

  _handleStoreSignUpOtp() async {
    setState(() {
      _isButtonDisabled = true;
    });
    // print("IN handle store Sign OTP");
    widget.userData.storeNumber = _storeNumberController.text;
    widget.userData.foodType = selectedFoodType.name;
    var _response = await authData.sendSignUpOtpCode(
        widget.userData.phone, widget.userData.emailAddress);
    // print("In 2");
    print(_response);
    if (_response[0]) {
      _loader = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpSignUpVerificationPage(widget.userData)),
      );
    } else {
      setState(() {
        _loader = false;
        _isButtonDisabled = false;
      });
      Utils.showSnackBar(_key, _response[1]);
    }
  }

  void initState() {
    super.initState();
    print('ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
    _storeNumberController = new TextEditingController();
    _isButtonDisabled = false;
    getFoodTypes();
  }

  void getFoodTypes() async {
    setState(() {
      _loader = true;
    });
    var foodTypeRes = await listData.foodTypes();
    List<dynamic> types = foodTypeRes['results'];
    print(types.toString());
    foodTypeData = (types).map((i) => FoodTypeResponse.fromJson(i)).toList();
    setState(() {
      selectedFoodType = foodTypeData.toList()[0];
    });
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
        child: Padding(
          padding: EdgeInsets.only(
              left: _screenConfig.rW(20), right: _screenConfig.rW(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: _screenConfig.rH(8)),
              Text(signup, style: CustomFontStyle.mainHeadingStyle(blackColor)),
              SizedBox(height: _screenConfig.rH(8)),
              CustomFormField(
                title: numberOfStores,
                hint: pleaseEnterNumberOfStores,
                obscure: false,
                fieldValidator: validateName,
                controller: _storeNumberController,
              ),
              SizedBox(height: _screenConfig.rH(6)),
              Text(typeOfDish,
                  style: CustomFontStyle.subHeadingStyle(blackColor)),
              SizedBox(height: _screenConfig.rH(2)),
              Container(
                decoration: BoxDecoration(
                    color: cloudsColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(1)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FoodTypeResponse>(
                      isExpanded: true,
                      items: foodTypeData.map((FoodTypeResponse val) {
                        return new DropdownMenuItem<FoodTypeResponse>(
                          value: val,
                          child: new Text(val.name,
                              style: CustomFontStyle.bottomButtonTextStyle(
                                  blackColor)),
                        );
                      }).toList(),
                      value: selectedFoodType ?? foodTypeData.toList()[0],
                      onChanged: (FoodTypeResponse val) {
                        setState(() {
                          selectedFoodType = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: _screenConfig.rH(6)),
              // Text(deliveryUniversity,
              //     style: CustomFontStyle.subHeadingStyle(blackColor)),
              SizedBox(height: _screenConfig.rH(2)),
              // Container(
              //   decoration: BoxDecoration(
              //       color: cloudsColor,
              //       shape: BoxShape.rectangle,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(8.0),
              //       )),
              //   child: Padding(
              //     padding: EdgeInsets.all(_screenConfig.rH(1)),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton<UniversityResponse>(
              //         isExpanded: true,
              //         items: universityData.map((UniversityResponse val) {
              //           return new DropdownMenuItem<UniversityResponse>(
              //             value: val,
              //             child: new Text(val.name,
              //                 style: CustomFontStyle.bottomButtonTextStyle(
              //                     blackColor)),
              //           );
              //         }).toList(),
              //         value: selectedUniversity ?? universityData.toList()[0],
              //         onChanged: (UniversityResponse val) {
              //           selectedUniversity = val;
              //           setState(() {
              //             getCampuses(val.slug);
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: _screenConfig.rH(2)),
              // Container(
              //   decoration: BoxDecoration(
              //       color: cloudsColor,
              //       shape: BoxShape.rectangle,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(8.0),
              //       )),
              //   child: Padding(
              //     padding: EdgeInsets.all(_screenConfig.rH(1)),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton<CampusResponse>(
              //         isExpanded: true,
              //         items: campusData.map((CampusResponse val) {
              //           return new DropdownMenuItem<CampusResponse>(
              //             value: val,
              //             child: new Text(val.name,
              //                 style: CustomFontStyle.bottomButtonTextStyle(
              //                     blackColor)),
              //           );
              //         }).toList(),
              //         value: selectedCampus ?? campusData.toList()[0],
              //         onChanged: (CampusResponse val) {
              //           setState(() {
              //             selectedCampus = val;
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
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
              print(_isButtonDisabled);
              print(_isButtonDisabled);
              if (_formKey.currentState.validate()) {
                _isButtonDisabled ? null : _handleStoreSignUpOtp();
              }
            },
            child: BottomButton(
              text: signup,
              textColor: whiteBellyColor,
              color: blackBellyColor,
            )));
  }
}

String validateName(String value) {
  if (value.length == 0) {
    return noEmptyFields;
  }
  return null;
}
