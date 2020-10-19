import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/new_orders_data.dart';
import 'package:BellyRestaurant/models/new_order_model.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class OrderDetailPage extends StatefulWidget {
  final NewOrderModel _selectedNewOrder;
  final StreamController _controller;

  OrderDetailPage(this._selectedNewOrder, this._controller);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String token;
  bool _loader = false;
  NewOrdersDataSource _newOrdersDataSource = new NewOrdersDataSource();
  AppConfig _screenConfig;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  _handleOrderAccept() async {
    showLoading();
    print('oooooorder iiiiddd');
    print(widget._selectedNewOrder.id);
    var res = await _newOrdersDataSource.acceptRejectOrder(
        token, widget._selectedNewOrder.id, "True");

    if (res[0]) {
      hideLoading();
      print('order accepted');
      print(res);
    } else {
      hideLoading();
      print('errorrrrrrrrrrrrrr');
      print(res);
      Utils.showSnackBar(_scaffoldKey, res[1]);
    }
    widget._controller.add(true);
  }

  _handleOrderReject() async {
    showLoading();
    var res = await _newOrdersDataSource.acceptRejectOrder(
        token, widget._selectedNewOrder.id, "False");

    if (res[0]) {
      hideLoading();
      Navigator.of(context).pop();
    } else {
      hideLoading();
      Navigator.of(context).pop();
      Utils.showSnackBar(_scaffoldKey, res[1]);
    }
    widget._controller.add(true);
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

  Widget _buildAcceptButton(context) {
    return InkWell(
      onTap: () {
        _handleOrderAccept();
      },
      child: Container(
        width: _screenConfig.rW(_screenConfig.isLargeScreen ? 14 : 30),
        height: _screenConfig.rH(_screenConfig.isLargeScreen ? 7 : 14),
        decoration: BoxDecoration(
          color: blackColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: _screenConfig.rW(_screenConfig.isLargeScreen ? 2 : 0),
              right: _screenConfig.rW(_screenConfig.isLargeScreen ? 2 : 0)),
          child: Center(
            child: Text(
              receiveAnOrder,
              textAlign: TextAlign.center,
              style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRejectButton(context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildDialog(context));
      },
      child: Container(
        width: _screenConfig.rW(_screenConfig.isLargeScreen ? 14 : 10),
        height: _screenConfig.rH(_screenConfig.isLargeScreen ? 7 : 14),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Center(
            child: Text(
              reject,
              style: CustomFontStyle.bottomButtonTextStyle(redColor),
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
            right: _screenConfig.rH(4)),
        child: Container(
          color: whiteColor,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: _screenConfig.rH(130)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(4)),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget._selectedNewOrder.orderitems.length,
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
                                        widget._selectedNewOrder
                                            .orderitems[index].count
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
                                              widget._selectedNewOrder
                                                  .orderitems[index].itemName,
                                              style: CustomFontStyle
                                                  .regularBoldTextStyle(
                                                      blackColor),
                                            ),
                                            Text(
                                              widget._selectedNewOrder
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
                                                    widget
                                                        ._selectedNewOrder
                                                        .orderitems[index]
                                                        .itemPrice
                                                        .toString(),
                                                style: CustomFontStyle
                                                    .mediumTextStyle(greyColor),
                                              )))
                                    ],
                                  ),
                                ),
                              ))),
                  Container(
                    height: 1,
                    color: cloudsColor,
                  ),
                  widget._selectedNewOrder.restaurantNote == ''
                      ? Container()
                      : SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Note : ",
                                style: CustomFontStyle.regularBoldTextStyle(
                                    blackColor),
                              ),
                              Text(
                                widget._selectedNewOrder.restaurantNote,
                                style:
                                    CustomFontStyle.smallTextStyle(greyColor),
                              ),
                            ],
                          ),
                        ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: <Widget>[
                  //       Text(
                  //         subTotal + "  ",
                  //         style: CustomFontStyle.mediumTextStyle(greyColor),
                  //       ),
                  //       Text(
                  //         widget._selectedNewOrder.grandtotal.toString(),
                  //         style: CustomFontStyle.mediumTextStyle(greyColor),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          totalAmount + "  ",
                          style:
                              CustomFontStyle.regularBoldTextStyle(blackColor),
                        ),
                        Text(
                          widget._selectedNewOrder.grandtotal.toString(),
                          style:
                              CustomFontStyle.regularBoldTextStyle(blackColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        widget._selectedNewOrder.orderitems[0].notes == null
                            ? ""
                            : 'Notes given: ${widget._selectedNewOrder.orderitems[0].notes}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: cloudsColor,
                  ),
                  Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildRejectButton(context),
                      _buildAcceptButton(context),
                    ],
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: _screenConfig.rH(4))),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildDialog(context) {
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
                padding: EdgeInsets.all(_screenConfig.rH(2)),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget._selectedNewOrder.slottime.substring(0, 5),
                      style: CustomFontStyle.regularBoldTextStyle(blackColor),
                    ),
                    SizedBox(
                      width: _screenConfig.rW(2),
                    ),
                    Text(
                      "ID " + widget._selectedNewOrder.orderNo,
                      style: CustomFontStyle.regularBoldTextStyle(blackColor),
                    ),
                    SizedBox(
                      width: _screenConfig.rW(2),
                    ),
                    Text(
                      widget._selectedNewOrder.user,
                      style: CustomFontStyle.regularBoldTextStyle(blackColor),
                    ),
                  ],
                ),
              ),
              Container(
                height: _screenConfig.rH(0.2),
                color: cloudsColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: _screenConfig.rH(10)),
                child: Text(
                  doYouWantToRejectThisOrder,
                  style: CustomFontStyle.regularBoldTextStyle(blackColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildNoButton(context),
                  _buildYesButton(context)
                ],
              ),
              Padding(padding: EdgeInsets.only(top: _screenConfig.rH(3))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYesButton(context) {
    return InkWell(
      onTap: () {
        _handleOrderReject();
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
                left: _screenConfig.rW(2), right: _screenConfig.rW(2)),
            child: Center(
              child: Text(
                yes,
                style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
              ),
            ),
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
}
