import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/constants/constants.dart';
import 'package:BellyRestaurant/models/order_history_model.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class OrderHistoryDetailPage extends StatefulWidget {
  final OrderHistoryModel _selectedOrder;

  OrderHistoryDetailPage(this._selectedOrder);

  @override
  _OrderHistoryDetailPageState createState() => _OrderHistoryDetailPageState();
}

class _OrderHistoryDetailPageState extends State<OrderHistoryDetailPage> {
  bool pressed = false;
  AppConfig _screenConfig;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Scaffold(
      body: Container(
        color: formBgColor,
        child: orderItem(),
      ),
    );
  }

  Widget orderItem() {
    Driver _driver = widget._selectedOrder.driver;
    String _phone = _driver?.phone.toString() ?? "";
    return Container(
      color: whiteColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _driver != null
                ? Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            deliveryMan,
                            style:
                                CustomFontStyle.regularBoldTextStyle(greyColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(_screenConfig.rH(2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _driver != null
                              ? CircleAvatar(
                                  radius: 24.0,
                                  backgroundImage: NetworkImage(
                                      _driver.profilePic == null
                                          ? userImageUrl
                                          : _driver.profilePic),
                                  backgroundColor: Colors.transparent,
                                )
                              : Container(),
                          SizedBox(
                            width: _screenConfig.rW(2),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _driver?.name ?? "",
                                style: CustomFontStyle.regularBoldTextStyle(
                                    blackColor),
                              ),
                              Text(
                                _phone == "null" ? "" : _phone,
                                style: CustomFontStyle.regularBoldTextStyle(
                                    greyColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ])
                : Container(),
            Container(
              height: 1,
              color: cloudsColor,
            ),
            Padding(
                padding: EdgeInsets.all(_screenConfig.rH(4)),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget._selectedOrder.orderitems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _screenConfig.rH(1)),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  widget._selectedOrder.orderitems[index].count
                                      .toString(),
                                  style: CustomFontStyle.regularBoldTextStyle(
                                      blackColor),
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
                                              .regularBoldTextStyle(blackColor),
                                        ),
                                        widget._selectedOrder.orderitems[index]
                                                    .size ==
                                                null
                                            ? Container()
                                            : Text(
                                                widget._selectedOrder
                                                    .orderitems[index].size,
                                                style: CustomFontStyle
                                                    .smallTextStyle(greyColor),
                                              ),
                                      ],
                                    )),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "₹ " +
                                          widget._selectedOrder
                                              .orderitems[index].itemPrice
                                              .toString(),
                                      style: CustomFontStyle.mediumTextStyle(
                                          greyColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))),
            Container(
              height: 1,
              color: cloudsColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _screenConfig.rH(2),
                  vertical: _screenConfig.rH(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              subTotal,
                              style: CustomFontStyle.mediumTextStyle(greyColor),
                            ),
                            Text(
                              "  ₹ " +
                                  widget._selectedOrder.grandtotal.toString(),
                              style: CustomFontStyle.mediumTextStyle(greyColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              totalAmount,
                              style: CustomFontStyle.regularBoldTextStyle(
                                  blackColor),
                            ),
                            Text(
                              "  ₹ " +
                                  widget._selectedOrder.grandtotal.toString(),
                              style: CustomFontStyle.regularBoldTextStyle(
                                  blackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: _screenConfig.rH(4))),
          ],
        ),
      ),
    );
  }
}
