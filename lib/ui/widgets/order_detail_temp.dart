import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class OrderDetailPage2 extends StatefulWidget {
  int _selectedOrder;

  OrderDetailPage2(this._selectedOrder);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage2> {
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

  Widget _buildAcceptButton(context) {
    return InkWell(
      onTap: () {
        setState(() {
          pressed = true;
        });
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
                receiveAnOrder,
                style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRejectButton(context) {
    return InkWell(
      onTap: () {
        setState(() {
          pressed = true;
        });
      },
      child: Container(
        width: _screenConfig.rW(14),
        height: _screenConfig.rH(7),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Text(
              receiveAnOrder,
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_screenConfig.rH(4)),
//                  child: ListView.builder(
//                      scrollDirection: Axis.vertical,
//                      itemCount: 2,
//                      shrinkWrap: true,
//                      physics: ClampingScrollPhysics(),
//                      itemBuilder: (BuildContext context, int index) =>
//                          Container(
//                            child: Padding(
//                              padding: EdgeInsets.symmetric(
//                                  vertical: _screenConfig.rH(1)),
//                              child: Row(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Text(
//
//                                    "2",
//                                    style: CustomFontStyle.regularBoldTextStyle(
//                                        blackColor),
//                                  ),
//                                  Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceEvenly,
//                                    mainAxisSize: MainAxisSize.max,
//                                    children: <Widget>[
//                                      Text(
//                                        "チーズバーガー",
//                                        style: CustomFontStyle
//                                            .regularBoldTextStyle(blackColor),
//                                      ),
//                                      Text(
//                                        "サイズM",
//                                        style: CustomFontStyle.smallTextStyle(
//                                            greyColor),
//                                      ),
//                                    ],
//                                  ),
//                                  Text(
//                                    "₹ 285",
//                                    style: CustomFontStyle.mediumTextStyle(
//                                        greyColor),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ))
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: _screenConfig.rH(1)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "3",
                              style: CustomFontStyle.regularBoldTextStyle(
                                  blackColor),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _screenConfig.rW(2)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "cheeseburger",
                                      style:
                                          CustomFontStyle.regularBoldTextStyle(
                                              blackColor),
                                    ),
                                    Text(
                                      "Size M",
                                      style: CustomFontStyle.smallTextStyle(
                                          greyColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "₹ 100",
                              style: CustomFontStyle.mediumTextStyle(greyColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: _screenConfig.rH(1)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "2",
                              style: CustomFontStyle.regularBoldTextStyle(
                                  blackColor),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _screenConfig.rW(2)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Mac fries",
                                      style:
                                          CustomFontStyle.regularBoldTextStyle(
                                              blackColor),
                                    ),
                                    Text(
                                      "Size M",
                                      style: CustomFontStyle.smallTextStyle(
                                          greyColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "₹ 150",
                              style: CustomFontStyle.mediumTextStyle(greyColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              Spacer(),
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
                      "   ₹ 600",
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
                      style: CustomFontStyle.regularBoldTextStyle(blackColor),
                    ),
                    Text(
                      "   ₹ 600 ",
                      style: CustomFontStyle.regularBoldTextStyle(blackColor),
                    ),
                  ],
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
              Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
            ],
          ),
        ),
      );
}
