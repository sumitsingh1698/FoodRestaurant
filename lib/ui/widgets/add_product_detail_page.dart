import 'dart:async';
import 'dart:io';
import 'package:BellyRestaurant/data/location_list_data.dart';
import 'package:BellyRestaurant/models/food_type_model.dart';
import 'package:BellyRestaurant/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as Picker;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/product_update_data.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/base_url.dart';
import 'package:image/image.dart' as _Image;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

class AddProductDetailPage extends StatefulWidget {
  final StreamController _controller;

  AddProductDetailPage(this._controller);

  @override
  _AddProductDetailPage createState() => _AddProductDetailPage();
}

class _AddProductDetailPage extends State<AddProductDetailPage> {
  TextEditingController _foodNameController;
  TextEditingController _descriptionController;

  bool _loader = true;
  bool _successFlag = false;
  bool _validate = false;
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool pressed = false;
  AppConfig _screenConfig;
  String _radioValue; //Initial definition of radio button value
  String choice;
  File _image;
  static final baseUrl = BaseUrl().mainUrl;
  static final saveNewItemUrl = baseUrl + "additems/";
  ProductDataSource addProductDataSource = new ProductDataSource();
  ListData listData = new ListData();
  List<FoodItemCategory> foodCatData = [];
  FoodItemCategory selectedFoodCat;
  String diet = "Non-veg";
  List<String> dietList = ["Veg", "Non-veg"];

  @override
  void initState() {
    super.initState();
    getFoodCategory();
    _radioValue = "Single";
    choice = _radioValue;
    _foodNameController = new TextEditingController();
    _descriptionController = new TextEditingController();
  }

  void getFoodCategory() async {
    var foodTypeRes = await listData.foodcategoryList();
    List<dynamic> types = foodTypeRes['results'];
    print(types.toString());
    foodCatData = (types).map((i) => FoodItemCategory.fromJson(i)).toList();
    setState(() {
      selectedFoodCat = foodCatData[0];
    });
    hideLoading();
  }

  _handleSaveDetails() async {
    showLoading();
    var res = await addNewItem({
      "image": _image.toString(),
      "name": _foodNameController.text,
      "short_description": _descriptionController.text,
      "type": choice,
      "food_category": selectedFoodCat.id,
      "diet": diet,
    }, _image);
    if (res['status']) {
      print('sucessssssssssssssssssssssssssssssssssss');
      widget._controller.add(true);
      hideLoading();
      showToast("Successfully Added", greenColor);
    } else {
      print('fffffffffffffffffffffffffffffffffffffffffffffffffff');
      hideLoading();
      showToast("Failed To Add", greyColor);
    }
  }

  Future<Map<String, dynamic>> addNewItem(var body, File file) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var stream;
    var length;
    var mulipartFile;
    var request = new http.MultipartRequest("POST", Uri.parse(saveNewItemUrl));
    if (file != null) {
      stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      length = await file.length();
      mulipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(file.path));
    }
    request.headers['Authorization'] = "Token " + token;
    request.fields['name'] = body['name'];
    request.fields['short_description'] = body['short_description'];

    request.fields['type'] = body['type'];
    request.fields['food_category'] = body['food_category'].toString();
    request.fields['diet'] = body['diet'];

    request.files.add(mulipartFile);

    http.StreamedResponse postresponse = await request.send();
    if (postresponse.statusCode == 200) {
      var res = await http.Response.fromStream(postresponse);
      print('xxxxxxxxxxxxxxxxxxxxxxx${res.body}');
      return json.decode(res.body);
    } else {
      print('failedfailedfailedfailedddddddddddddddddd');
      throw new Exception("Error while fetching data");
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
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: (_loader)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              )
            : orderItem(context),
      ),
    );
  }

  Widget _buildSaveButton(context) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
          if (_image == null) {
            showToast("Select Image", grey1Color);
          } else {
            setState(() {
              pressed = true;
              _handleSaveDetails();
            });
          }
        } else {
          showToast("Fill all field", greyColor);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: greenBellyColor,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          width: _screenConfig.rW(18),
          height: _screenConfig.rH(7),
          child: Padding(
            padding: EdgeInsets.only(
                left: _screenConfig.rW(2), right: _screenConfig.rW(2)),
            child: Center(
              child: Text(
                save,
                style: CustomFontStyle.bottomButtonTextStyle(whiteBellyColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderItem(BuildContext context) => Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _validate,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(4)),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: cloudsColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  height: _screenConfig.rH(15),
                                  width: _screenConfig.rH(15),
                                  child: _image == null
                                      ? Text('Please select an image.',
                                          style: _screenConfig.isLargeScreen
                                              ? CustomFontStyle.mediumTextStyle(
                                                  greyColor)
                                              : TextStyle(
                                                  fontSize: 12,
                                                ))
                                      : Image.file(_image),
                                ),
                              ),
                            ),
                            Positioned(
                              right: _screenConfig.rH(-3),
                              bottom: _screenConfig.rH(-3),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    width: _screenConfig.rH(8),
                                    height: _screenConfig.rH(8),
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: greyColor),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(_screenConfig.rH(1.4)),
                                      child: Image.asset(
                                        'images/icons/camera_icon.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _screenConfig.rH(5),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(productName,
                            style:
                                CustomFontStyle.regularTextStyle(blackColor)),
                      ),
                      Container(
                        child: TextFormField(
                          validator: validateString,
                          controller: _foodNameController,
                          decoration: new InputDecoration.collapsed(
                              hintText: 'Enter here'),
                          style:
                              CustomFontStyle.regularFormTextStyle(greyColor),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border(
                            bottom: BorderSide(
                              color: cloudsColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: _screenConfig.rH(2)),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: formBgColor,
                        border: Border.all(color: cloudsColor)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: _screenConfig.rH(2),
                          bottom: _screenConfig.rH(2),
                          left: _screenConfig.rH(2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(description,
                              style:
                                  CustomFontStyle.regularTextStyle(blackColor)),
                          Container(
                            child: TextFormField(
                              validator: validateString,
                              controller: _descriptionController,
                              decoration: new InputDecoration.collapsed(),
                              style: CustomFontStyle.regularFormTextStyle(
                                  greyColor),
                              keyboardType: TextInputType.multiline,
                              minLines: 7,
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                      child: DropdownButton<FoodItemCategory>(
                        isExpanded: true,
                        items: foodCatData.map((FoodItemCategory val) {
                          return new DropdownMenuItem<FoodItemCategory>(
                            value: val,
                            child: new Text(val.name,
                                style: CustomFontStyle.bottomButtonTextStyle(
                                    blackColor)),
                          );
                        }).toList(),
                        value: selectedFoodCat ?? foodCatData[0],
                        onChanged: (FoodItemCategory val) {
                          setState(() {
                            selectedFoodCat = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
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
                      child: DropdownButton<String>(
                        isExpanded: true,
                        items: dietList.map((val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val,
                                style: CustomFontStyle.bottomButtonTextStyle(
                                    blackColor)),
                          );
                        }).toList(),
                        value: diet ?? "Non-veg",
                        onChanged: (val) {
                          setState(() {
                            diet = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildSaveButton(context),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
              ],
            ),
          ),
        ),
      );

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Single':
          choice = value;
          break;
        case 'Set':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
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
              title: const Text(foodItemImage),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(eitherFromCameraOrGallery),
              ),
              actions: <Widget>[
                optionOne,
                optionTwo,
              ],
            ));
      },
    );
  }

  String validateString(String value) {
    if (value.length == 0) {
      return noEmptyFields;
    }
    return null;
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
    var thumbnail = _Image.copyResize(img, width: 120);
    setState(() {
      _image = image;
    });
  }
}
