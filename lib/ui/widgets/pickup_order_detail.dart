import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/constants/constants.dart';
import 'package:BellyRestaurant/data/pickup_orders_data.dart';
import 'package:BellyRestaurant/models/pickup_order_model.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class PickUpOrderDetailPage extends StatefulWidget {
  final PickupOrdersResponseModel _selectedOrder;
  StreamController _controller;

  PickUpOrderDetailPage(this._selectedOrder, this._controller);

  @override
  _PickUpOrderDetailPageState createState() => _PickUpOrderDetailPageState();
}

class _PickUpOrderDetailPageState extends State<PickUpOrderDetailPage> {
  bool pressed = false;
  String token;
  bool _loader = false;
  AppConfig _screenConfig;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  PickupOrdersDataSource _pickupOrdersDataSource = new PickupOrdersDataSource();

  _handleOrderPickup() async {
    showLoading();
    var res = await _pickupOrdersDataSource.startPickupOrder(
        token, widget._selectedOrder.id, "True");
    if (res[0]) {
      widget._controller.add(true);
      hideLoading();
    } else {
      hideLoading();
      Utils.showSnackBar(_scaffoldKey, res[1]);
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
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: formBgColor,
        child: (_loader)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              )
            : orderItem(),
      ),
    );
  }

  Widget _buildPickUpButton(context) {
    return InkWell(
      onTap: () {
        _handleOrderPickup();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: blackBellyColor,
            borderRadius: BorderRadius.circular(4.0),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: _screenConfig.rW(20),
            height: _screenConfig.rH(14),
            child: Center(
              child: Text(
                deliveryCompleted,
                textAlign: TextAlign.center,
                style: CustomFontStyle.bottomButtonTextStyle(whiteBellyColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orderItem() => Padding(
        padding: EdgeInsets.only(
            top: _screenConfig.rH(4),
            bottom: _screenConfig.rH(4),
            right: _screenConfig.isLargeScreen
                ? _screenConfig.rH(4)
                : _screenConfig.rH(0)),
        child: Container(
          color: whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(2)),
                  child: Text(
                    willArriveSoon,
                    style: CustomFontStyle.regularBoldTextStyle(blackColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 24.0,
                        backgroundImage:
                            widget._selectedOrder.driver.profilePic != null
                                ? NetworkImage(
                                    widget._selectedOrder.driver.profilePic)
                                : NetworkImage(userImageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: _screenConfig.rW(2),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget._selectedOrder.driver.name,
                            style: CustomFontStyle.regularBoldTextStyle(
                                blackColor),
                          ),
                          Text(
                            widget._selectedOrder.driver.phone,
                            style:
                                CustomFontStyle.regularBoldTextStyle(greyColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                widget._selectedOrder.restaurantNote == ""
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.all(_screenConfig.rH(2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Note : ",
                                  style: CustomFontStyle.regularBoldTextStyle(
                                      blackColor),
                                ),
                                Text(
                                  widget._selectedOrder.restaurantNote,
                                  style: CustomFontStyle.regularBoldTextStyle(
                                      greyColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
              ]),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: _screenConfig.rH(40)),
                  child: Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(4)),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget._selectedOrder.orderitems.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: _screenConfig.rH(1)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        widget._selectedOrder.orderitems[index]
                                            .count
                                            .toString(),
                                        style: CustomFontStyle
                                            .regularBoldTextStyle(blackColor),
                                      ),
                                      SizedBox(width: _screenConfig.rW(2)),
                                      SizedBox(
                                        width: _screenConfig.rW(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              widget._selectedOrder
                                                  .orderitems[index].itemName,
                                              style: CustomFontStyle
                                                  .regularBoldTextStyle(
                                                      blackColor),
                                            ),
                                            Text(
                                              widget._selectedOrder
                                                  .orderitems[index].size,
                                              style: CustomFontStyle
                                                  .smallTextStyle(greyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "₹ " +
                                              widget._selectedOrder
                                                  .orderitems[index].itemPrice
                                                  .toString(),
                                          style:
                                              CustomFontStyle.mediumTextStyle(
                                                  greyColor),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ))),
                ),
              ),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: _screenConfig.isLargeScreen
                        ? _screenConfig.rH(2)
                        : _screenConfig.rH(0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildPickUpButton(context),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: <Widget>[
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: <Widget>[
                        //     Text(
                        //       subTotal + "  ",
                        //       style: CustomFontStyle.mediumTextStyle(greyColor),
                        //     ),
                        //     Text(
                        //       widget._selectedOrder.grandtotal.toString(),
                        //       style: CustomFontStyle.mediumTextStyle(greyColor),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              totalAmount + "  ",
                              style: CustomFontStyle.regularBoldTextStyle(
                                  blackColor),
                            ),
                            Text(
                              widget._selectedOrder.grandtotal.toString(),
                              style: CustomFontStyle.regularBoldTextStyle(
                                  blackColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
            ],
          ),
        ),
      );
}
