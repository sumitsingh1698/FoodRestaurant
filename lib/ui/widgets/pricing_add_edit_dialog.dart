import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/new_orders_data.dart';
import 'package:BellyRestaurant/models/pricing_model.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PricingAddEditDialog extends StatefulWidget {
  Pricing pricing;
  int itemId;

  PricingAddEditDialog({this.pricing, this.itemId});

  @override
  _PricingAddEditDialogState createState() => _PricingAddEditDialogState();
}

class _PricingAddEditDialogState extends State<PricingAddEditDialog> {
  final _priceTextController = TextEditingController();
  final _sizeTextController = TextEditingController();
  final _totalQuantityTextController = TextEditingController();
  NewOrdersDataSource newOrdersDataSource;
  GlobalKey<FormState> _formKey = new GlobalKey();
  AppConfig _screenConfig;
  bool isButtonDisable = false;

  String token;

  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;

    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    setData();
  }

  void setData() async {
    if (widget.pricing != null) {
      _sizeTextController.text = widget.pricing.size.toString();
      _priceTextController.text = widget.pricing.price.toString();
      _totalQuantityTextController.text =
          widget.pricing.totalQuantity.toString();
      print(widget.pricing.totalQuantity.toString());
    }

    newOrdersDataSource = NewOrdersDataSource();
    setState(() {
      isLoading = false;
    });
  }

  void _handleUpdatePricing() async {
    setState(() {
      isLoading = true;
      isButtonDisable = true;
    });
    if (_formKey.currentState.validate()) {
      try {
        if (widget.pricing != null)
          await newOrdersDataSource
              .putPricing(
                  token,
                  widget.pricing.id,
                  widget.itemId,
                  _sizeTextController.text,
                  _totalQuantityTextController.text,
                  _priceTextController.text)
              .then((value) {
            if (value) {
              Fluttertoast.showToast(
                  msg: "Successfully Added",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context, true);
            }
          });
        else {
          await newOrdersDataSource
              .addPricing(token, widget.itemId, _sizeTextController.text,
                  _totalQuantityTextController.text, _priceTextController.text)
              .then((value) {
            if (value) {
              Fluttertoast.showToast(
                  msg: "Successfully Added",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context, false);
            }
          });
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SimpleDialog(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(price,
                      style: CustomFontStyle.regularTextStyle(blackColor)),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        validator: validateString,
                        controller: _priceTextController,
                        decoration: new InputDecoration.collapsed(),
                        style: CustomFontStyle.regularFormTextStyle(greyColor),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 16.0),
            //   child: Container(
            //     child: TextFormField(
            //       validator: validateString,
            //       controller: _priceTextController,
            //       decoration: new InputDecoration.collapsed(),
            //       style: CustomFontStyle.regularFormTextStyle(greyColor),
            //       keyboardType: TextInputType.number,
            //     ),
            //   ),
            // ),
            Container(
              height: 1,
              color: Colors.grey,
            ),

            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Size",
                      style: CustomFontStyle.regularTextStyle(blackColor)),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        validator: validateString,
                        controller: _sizeTextController,
                        decoration: new InputDecoration.collapsed(),
                        style: CustomFontStyle.regularFormTextStyle(greyColor),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: Colors.grey,
            ),

            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Total Quantity",
                      style: CustomFontStyle.regularTextStyle(blackColor)),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        validator: validateString,
                        controller: _totalQuantityTextController,
                        decoration: new InputDecoration.collapsed(),
                        style: CustomFontStyle.regularFormTextStyle(greyColor),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                        child: RaisedButton(
                      color: Colors.green,
                      onPressed: isButtonDisable == true
                          ? () {}
                          : _handleUpdatePricing,
                      child: Text("Save"),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                        child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String validateNumber(String value) {
    if (value.length == 0) {
      return noEmptyFields;
    }
    return null;
  }

  String validateString(String value) {
    if (value.length == 0) {
      return noEmptyFields;
    }
    return null;
  }
}
