import 'package:BellyRestaurant/data/location_list_data.dart';
import 'package:BellyRestaurant/models/food_type_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'dart:async';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/data/product_update_data.dart';
import 'package:BellyRestaurant/models/edit_item_response_model.dart';
import 'package:BellyRestaurant/ui/widgets/add_product_detail_page.dart';
import 'package:BellyRestaurant/ui/widgets/close_appbar.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/base_url.dart';
import 'package:image/image.dart' as _Image;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart' as Picker;
import 'dart:io';

class EditProductsNewPage extends StatefulWidget {
  @override
  _EditProductsPageState createState() => _EditProductsPageState();
}

class _EditProductsPageState extends State<EditProductsNewPage> {
  StreamController<bool> _controller = StreamController<bool>();
  bool isLoading = false;
  SharedPreferences prefs;
  AppConfig _screenConfig;
  String token;
  var count = 0;
  ProductDataSource _editItemsDataSource = new ProductDataSource();
  EditItemResponseModel data;
  int selectedItem = 0;
  TextEditingController _foodNameController;
  TextEditingController _sizeNameController;
  TextEditingController _priceController;
  TextEditingController _descriptionController;

  bool _loader = false;
  bool _validate = false;
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool pressed = false;
  String _radioValue; //Initial definition of radio button value
  String choice;
  File _image;
  static final baseUrl = BaseUrl().mainUrl;
  static final saveEditItemUrl = baseUrl + "edititems/";
  ListData listData = new ListData();
  List<FoodItemCategory> foodCatData = [];
  FoodItemCategory selectedFoodCat;
  String diet = "Non-veg";
  List<String> dietList = ["Veg", "Non-veg"];
  @override
  void initState() {
    super.initState();

    _controller.stream.listen((onData) {
      if (onData == true) {
        print('get data');
        this.getData();
      }
    });
    isLoading = true;
    getSharedPrefs();
    getFoodCategory();
  }

  void getFoodCategory() async {
    setState(() {
      _loader = true;
    });
    var foodTypeRes = await listData.foodcategoryList();
    List<dynamic> types = foodTypeRes['results'];
    print(types.toString());
    foodCatData = (types).map((i) => FoodItemCategory.fromJson(i)).toList();
    setState(() {
      selectedFoodCat = foodCatData[0];
    });
    setState(() {
      _loader = false;
    });
  }

  _handleSaveDetails(itemId) async {
    showLoading();
    var res = await addNewItem(
        itemId,
        {
          "name": _foodNameController.text,
          "short_description": _descriptionController.text,
          "size": _sizeNameController.text,
          "price": _priceController.text,
          "type": choice,
          // "food_category": selectedFoodCat.id,
          // "diet": "veg",
        },
        _image);
    print('response of food edit is $res');
    hideLoading();
  }

  Future<Map<String, dynamic>> addNewItem(int id, var body, File file) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var stream;
    var length;
    var mulipartFile;
    var request = new http.MultipartRequest(
        "PUT", Uri.parse(saveEditItemUrl + id.toString() + "/"));
    if (file != null) {
      stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      length = await file.length();
      mulipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(file.path));
    }
    request.headers['Authorization'] = "Token " + token;
    request.fields['name'] = body['name'];
    request.fields['short_description'] = body['short_description'];
    request.fields['size'] = body['size'];
    request.fields['price'] = body['price'];
    request.fields['type'] = body['type'];
    // request.fields['food_category'] = body['food_category'].toString();
    // request.fields['diet'] = body['diet'];
    if (file != null) {
      request.files.add(mulipartFile);
    }

    http.StreamedResponse postresponse = await request.send();
    var rsp = postresponse;
    if (postresponse.statusCode == 200) {
      var res = await http.Response.fromStream(postresponse);
      getData();
      return json.decode(res.body);
    } else {
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

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    var temp = await _editItemsDataSource.getAllItemsData(token);
    getFoodCategory();
    setState(() {
      isLoading = false;
      data = temp;
    });
    refreshData();
  }

  void refreshData() async {
    if (data.fooditems.list.length != 0) {
      _foodNameController = new TextEditingController(
        text: data.fooditems.list[selectedItem].name,
      );
      _sizeNameController = new TextEditingController(
          text: data.fooditems.list[selectedItem].size);
      _priceController = new TextEditingController(
          text: data.fooditems.list[selectedItem].price.toString());
      _descriptionController = new TextEditingController(
          text: data.fooditems.list[selectedItem].shortDescription);
      _radioValue = data.fooditems.list[selectedItem].type;
      choice = _radioValue;
    } else {
      _foodNameController = new TextEditingController();
      _sizeNameController = new TextEditingController();
      _priceController = new TextEditingController();
      _descriptionController = new TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Scaffold(
        appBar: CloseAppBar(),
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              )
            : SafeArea(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: formBgColor,
                    ),
                    _buildProductsList(context),
                  ],
                ),
              ));
  }

  Widget _buildProductsList(context) {
    int setCount = data.fooditems.set;
    int singleCount = data.fooditems.single;
    int total = setCount + singleCount;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(_screenConfig.rH(4)),
          child: new Text("All $total Product;",
              style: CustomFontStyle.mediumBoldTextStyle(blackColor)),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                left: _screenConfig.rH(4),
                bottom: _screenConfig.rH(4),
                right: _screenConfig.rH(4)),
            child: Container(
              color: whiteColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.fooditems.list.length != 0
                                ? data.fooditems.list.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildItemCell(
                                  data.fooditems.list[index], index);
                            },
                          ),
                          _buildNewItemCell(
                              context, data.fooditems.list.length),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          width: _screenConfig.rH(52),
                          child: selectedItem == data.fooditems.list.length
                              ? AddProductDetailPage(_controller)
                              : _buildDetails(
                                  data.fooditems.list[selectedItem], context),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: cloudsColor)))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(Item item, BuildContext buildContext) {
    return Container(
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
                        showAlertDialog(buildContext);
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
                              padding: const EdgeInsets.all(0.0),
                              child: SizedBox(
                                height: _screenConfig.rH(20),
                                width: _screenConfig.rH(20),
                                child: _image == null
                                    ? CachedNetworkImage(
                                        imageUrl: item.image,
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      )
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
                                      shape: BoxShape.circle, color: greyColor),
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
                          style: CustomFontStyle.regularTextStyle(blackColor)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Container(
                        child: TextFormField(
                          validator: validateString,
                          controller: _foodNameController,
                          decoration: new InputDecoration.collapsed(),
                          style:
                              CustomFontStyle.regularFormTextStyle(greyColor),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(sizeOrQuantity,
                          style: CustomFontStyle.regularTextStyle(blackColor)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Container(
                        child: TextFormField(
                          //initialValue: widget._selectedOrder.size,
                          validator: validateString,
                          controller: _sizeNameController,
                          decoration: new InputDecoration.collapsed(),
                          style:
                              CustomFontStyle.regularFormTextStyle(greyColor),
                          keyboardType: TextInputType.text,
                        ),
                      ),
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
                      child: Padding(
                        padding: EdgeInsets.only(top: _screenConfig.rH(2)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(price,
                                style: CustomFontStyle.regularTextStyle(
                                    blackColor)),
                            SizedBox(
                              width: _screenConfig.rW(1),
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  validator: validateString,
                                  controller: _priceController,
                                  decoration: new InputDecoration.collapsed(),
                                  style: CustomFontStyle.regularFormTextStyle(
                                      greyColor),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _screenConfig.rH(2)),
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
                            // initialValue:
                            //     widget._selectedOrder.shortDescription,
                            validator: validateString,
                            controller: _descriptionController,
                            decoration: new InputDecoration.collapsed(),
                            style:
                                CustomFontStyle.regularFormTextStyle(greyColor),
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
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Stack(children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  pressed = true;
                                  _handleSaveDetails(item.id);
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: blackBellyColor,
                                shape: BoxShape.rectangle,
                              ),
                              child: Container(
                                width: _screenConfig.rW(18),
                                height: _screenConfig.rH(7),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: _screenConfig.rW(2),
                                      right: _screenConfig.rW(2)),
                                  child: Center(
                                    child: Text(
                                      save,
                                      style:
                                          CustomFontStyle.bottomButtonTextStyle(
                                              whiteBellyColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: Icon(
                                Icons.delete,
                                color: redColor,
                                size: _screenConfig.rH(4),
                              ),
                              onTap: () {
                                showDialog(
                                    context: buildContext,
                                    builder: (BuildContext context) =>
                                        _buildDeleteConfirmDialog(
                                            item, buildContext));
                              },
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteConfirmDialog(Item _item, context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0)), //this right here
      child: SingleChildScrollView(
        child: Container(
          width: _screenConfig.rW(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: _screenConfig.rH(10)),
                child: Text(
                  areYouSureToDelete,
                  style: CustomFontStyle.regularBoldTextStyle(blackColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildNoButton(context),
                  InkWell(
                    onTap: () async {
                      bool _itemDeleted = await _editItemsDataSource.deleteItem(
                          token, _item.id);
                      if (_itemDeleted) {
                        Navigator.of(context).pop();
                        getData();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: blackColor,
                        shape: BoxShape.rectangle,
                      ),
                      child: Container(
                        width: _screenConfig.rW(14),
                        height: _screenConfig.rH(7),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: _screenConfig.rW(2),
                              right: _screenConfig.rW(2)),
                          child: Center(
                            child: Text(
                              yes,
                              style: CustomFontStyle.bottomButtonTextStyle(
                                  whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: _screenConfig.rH(3))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoButton(context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          color: cloudsColor,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          width: _screenConfig.rW(14),
          height: _screenConfig.rH(7),
          child: Padding(
            padding: EdgeInsets.only(
                left: _screenConfig.rW(2), right: _screenConfig.rW(2)),
            child: Center(
              child: Text(
                no,
                style: CustomFontStyle.bottomButtonTextStyle(blackColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCell(Item item, index) {
    return Container(
        height: _screenConfig.rH(10),
        decoration: BoxDecoration(
          color: selectedItem == index ? blackBellyColor : whiteColor,
          border: Border(
            bottom: BorderSide(
              color: cloudsColor,
              width: 1.0,
            ),
          ),
        ),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(_screenConfig.rH(1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(1)),
                      child: Text(item.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: _screenConfig.isLargeScreen
                              ? CustomFontStyle.mediumBoldTextStyle(
                                  selectedItem == index
                                      ? whiteBellyColor
                                      : greyColor)
                              : TextStyle(
                                  fontSize: 11,
                                  color: selectedItem == index
                                      ? whiteBellyColor
                                      : greyColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              selectedItem = index;
              _image = null;
              refreshData();
            });
          },
        ));
  }

  Widget _buildNewItemCell(context, itemsCount) {
    return Container(
        height: _screenConfig.rH(10),
        decoration: BoxDecoration(
          color: selectedItem == itemsCount ? greenBellyColor : whiteColor,
          border: Border(
            bottom: BorderSide(
              color: cloudsColor,
              width: 1.0,
            ),
          ),
        ),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(_screenConfig.rH(1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: selectedItem == itemsCount
                            ? whiteBellyColor
                            : greyColor,
                        size: _screenConfig.rH(4),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(addANewItem,
                          style: _screenConfig.isLargeScreen
                              ? CustomFontStyle.bottomButtonTextStyle(
                                  selectedItem == itemsCount
                                      ? whiteBellyColor
                                      : greyColor)
                              : TextStyle(
                                  fontSize: 14,
                                  color: selectedItem == itemsCount
                                      ? whiteBellyColor
                                      : greyColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              selectedItem = itemsCount;
            });
          },
        ));
  }

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
