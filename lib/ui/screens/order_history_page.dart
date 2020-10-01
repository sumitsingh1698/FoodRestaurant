import 'package:flutter/cupertino.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'dart:async';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/data/order_history_data.dart';
import 'package:BellyRestaurant/models/order_history_model.dart';
import 'package:BellyRestaurant/ui/widgets/order_history_detail_page.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool isLoading = false;
  SharedPreferences prefs;
  AppConfig _screenConfig;
  String _radioValue; //Initial definition of radio button value
  bool todayDataBool = true;
  int selectedItem = 0;
  var dateFormatter = new DateFormat('yyyy/MM/dd');
  DateTime todayD = DateTime.now();
  DateTime todayDate;
  DateTime _endDateTime;
  DateTime _startDateTime;
  DateTime yesterdayDate;
  TextEditingController _startDateController, _endDateController;
  OrderHistoryDataSource _orderHistoryDataSource = new OrderHistoryDataSource();
  var data;
  int count = 0;
  String token;

  @override
  void initState() {
    super.initState();

    _radioValue = "today";
    todayDate = DateTime(todayD.year, todayD.month, todayD.day);
    yesterdayDate = new DateTime(todayD.year, todayD.month, todayD.day - 1);
    _endDateTime = todayDate;
    _startDateTime = yesterdayDate;
    _startDateController =
        new TextEditingController(text: dateFormatter.format(_startDateTime));
    _endDateController =
        new TextEditingController(text: dateFormatter.format(_endDateTime));
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // getData();
  }

  void getData() async {
    isLoading = true;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);

    return Scaffold(
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
                  _screenConfig.isLargeScreen
                      ? _buildOrdersList(context)
                      : _buildOrdersListResponsive(context)
                ],
              ));
  }

  Widget _buildOrdersListResponsive(context) {
    Color _tempColor;
    _radioValue == "today" ? _tempColor = greyColor : _tempColor = blackColor;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(_screenConfig.rH(4)),
          child: Column(
            children: <Widget>[
              new Text("History",
                  style: CustomFontStyle.mediumBoldTextStyle(blackColor)),
              Column(
                children: <Widget>[
                  SizedBox(
                    width: _screenConfig.rW(4),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        activeColor: blackColor,
                        value: 'today',
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(today,
                          style: CustomFontStyle.regularTextStyle(greyColor)),
                    ],
                  ),
                  SizedBox(
                    width: _screenConfig.rW(4),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        activeColor: blackColor,
                        value: 'range',
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        selectDateRange,
                        style: CustomFontStyle.regularTextStyle(greyColor),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: _screenConfig.rW(14)),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: _tempColor, width: 1.4),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            if (!todayDataBool) {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 240,
                                    child: CupertinoDatePicker(
                                      backgroundColor: whiteColor,
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime: _startDateTime,
                                      maximumDate: _endDateTime,
                                      onDateTimeChanged:
                                          (DateTime newDateTime) {
                                        setState(() {
                                          _startDateTime = newDateTime;
                                          _startDateController.value =
                                              TextEditingValue(
                                                  text: dateFormatter
                                                      .format(_startDateTime));
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              width: 80,
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _startDateController,
                                  decoration: new InputDecoration.collapsed(),
                                  style: CustomFontStyle.mediumTextStyle(
                                      _tempColor),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _screenConfig.rW(2),
                    ),
                    Text(
                      "~",
                      style: CustomFontStyle.mediumTextStyle(greyColor),
                    ),
                    SizedBox(
                      width: _screenConfig.rW(2),
                    ),
                    Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: _tempColor, width: 1.4),
                      ),
                      child: Center(
                        child: Container(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                if (!todayDataBool) {
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 240,
                                        child: CupertinoDatePicker(
                                          backgroundColor: whiteColor,
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: _endDateTime,
                                          maximumDate: todayDate,
                                          minimumDate: _startDateTime,
                                          onDateTimeChanged:
                                              (DateTime newDateTime) {
                                            setState(() {
                                              _endDateTime = newDateTime;
                                              _endDateController.value =
                                                  TextEditingValue(
                                                      text:
                                                          dateFormatter.format(
                                                              _endDateTime));
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Center(
                                child: Container(
                                  width: 80,
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      controller: _endDateController,
                                      decoration: InputDecoration.collapsed(),
                                      style: CustomFontStyle.mediumTextStyle(
                                          _tempColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<OrderHistoryModel>>(
            future: _orderHistoryDataSource.getOrderHistoryData(todayDataBool,
                _startDateController.text, _endDateController.text, token, "1"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return snapshot.data.length != 0
                    ? StatefulBuilder(builder: (context, setModelState) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: PagewiseListView(
                                          pageSize: snapshot.data.length,
                                          loadingBuilder: (context) {
                                            return CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(yellow),
                                            );
                                          },
                                          itemBuilder: (context,
                                              OrderHistoryModel snapshot,
                                              int index) {
                                            return InkWell(
                                              child: new Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                                  child: _buildOrderCell(
                                                      context,
                                                      index,
                                                      snapshot,
                                                      setModelState)),
                                            );
                                          },
                                          pageFuture: (pageIndex) =>
                                              _orderHistoryDataSource
                                                  .getOrderHistoryData(
                                                      todayDataBool,
                                                      _startDateController.text,
                                                      _endDateController.text,
                                                      token,
                                                      (pageIndex + 1)
                                                          .toString()))),
                                ],
                              ),
                            ),
                            Container(
                                width: _screenConfig.rH(52),
                                child: OrderHistoryDetailPage(
                                    snapshot.data[selectedItem]))
                          ],
                        );
                      })
                    : Container();
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList(context) {
    Color _tempColor;
    _radioValue == "today" ? _tempColor = greyColor : _tempColor = blackColor;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(_screenConfig.rH(4)),
          child: Row(
            children: <Widget>[
              new Text(orderHistory,
                  style: CustomFontStyle.mediumBoldTextStyle(blackColor)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: _screenConfig.rH(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: _screenConfig.rW(4),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          activeColor: blackColor,
                          value: 'today',
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(today,
                            style: CustomFontStyle.regularTextStyle(greyColor)),
                      ],
                    ),
                    SizedBox(
                      width: _screenConfig.rW(4),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          activeColor: blackColor,
                          value: 'range',
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          selectDateRange,
                          style: CustomFontStyle.regularTextStyle(greyColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: _screenConfig.rW(4),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: _tempColor, width: 1.4),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: _screenConfig.rW(2),
                      top: _screenConfig.rH(0.5),
                      bottom: _screenConfig.rH(0.5)),
                  child: Container(
                    height: _screenConfig.rH(6),
                    width: _screenConfig.rW(16),
                    child: InkWell(
                      onTap: () {
                        if (!todayDataBool) {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 240,
                                child: CupertinoDatePicker(
                                  backgroundColor: whiteColor,
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: _startDateTime,
                                  maximumDate: _endDateTime,
                                  onDateTimeChanged: (DateTime newDateTime) {
                                    setState(() {
                                      _startDateTime = newDateTime;
                                      _startDateController.value =
                                          TextEditingValue(
                                              text: dateFormatter
                                                  .format(_startDateTime));
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: IgnorePointer(
                        child: Center(
                          child: TextFormField(
                            controller: _startDateController,
                            decoration: new InputDecoration.collapsed(),
                            style: CustomFontStyle.mediumTextStyle(_tempColor),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _screenConfig.rW(2),
              ),
              Text(
                "~",
                style: CustomFontStyle.mediumTextStyle(greyColor),
              ),
              SizedBox(
                width: _screenConfig.rW(2),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: _tempColor, width: 1.4),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: _screenConfig.rW(2),
                      top: _screenConfig.rH(0.5),
                      bottom: _screenConfig.rH(0.5)),
                  child: Container(
                    height: _screenConfig.rH(6),
                    width: _screenConfig.rW(16),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          if (!todayDataBool) {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 240,
                                  child: CupertinoDatePicker(
                                    backgroundColor: whiteColor,
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: _endDateTime,
                                    maximumDate: todayDate,
                                    minimumDate: _startDateTime,
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      setState(() {
                                        _endDateTime = newDateTime;
                                        _endDateController.value =
                                            TextEditingValue(
                                                text: dateFormatter
                                                    .format(_endDateTime));
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: _endDateController,
                            decoration: new InputDecoration.collapsed(),
                            style: CustomFontStyle.mediumTextStyle(_tempColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<OrderHistoryModel>>(
            future: _orderHistoryDataSource.getOrderHistoryData(todayDataBool,
                _startDateController.text, _endDateController.text, token, "1"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return snapshot.data.length != 0
                    ? StatefulBuilder(builder: (context, setModelState) {
                        return Row(
                          children: <Widget>[
                            // Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   // mainAxisAlignment: MainAxisAlignment.start,
                            //   children: <Widget>[
                            Container(
                              width: _screenConfig.isLargeScreen ? 300 : 100,
                              child: PagewiseListView(
                                  pageSize: snapshot.data.length,
                                  loadingBuilder: (context) {
                                    return CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              yellow),
                                    );
                                  },
                                  itemBuilder: (context,
                                      OrderHistoryModel snapshot, int index) {
                                    return InkWell(
                                      child: new Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: _buildOrderCell(context, index,
                                              snapshot, setModelState)),
                                    );
                                  },
                                  pageFuture: (pageIndex) =>
                                      _orderHistoryDataSource
                                          .getOrderHistoryData(
                                              todayDataBool,
                                              _startDateController.text,
                                              _endDateController.text,
                                              token,
                                              (pageIndex + 1).toString())),
                            ),
                            Expanded(
                              child: Container(
                                  width: _screenConfig.rH(52),
                                  child: OrderHistoryDetailPage(
                                      snapshot.data[selectedItem])),
                            )
                          ],
                        );
                      })
                    : Container();
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      selectedItem = 0;
      _radioValue = value;
      switch (value) {
        case 'today':
          todayDataBool = true;
          break;
        case 'range':
          todayDataBool = false;
          break;
        default:
          todayDataBool = true;
      } //Debug the choice in console
    });
  }

  Widget _buildOrderCell(
      context, index, OrderHistoryModel data, StateSetter setModelState) {
    String date = data.slottime.substring(5, 7) +
        "/" +
        data.slottime.substring(8, 10) +
        "  " +
        data.slottime.substring(11, 16);
    return Container(
        color: whiteBellyColor,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(_screenConfig.rH(1)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(data.paymentStatus,
                                    style: CustomFontStyle.mediumTextStyle(
                                        greenColor)),
                              ),
                              Text(date,
                                  style: CustomFontStyle.mediumTextStyle(
                                      selectedItem == index
                                          ? blackColor
                                          : greyColor)),
                              Container(
                                child: Text("ID " + data.orderNo,
                                    style: CustomFontStyle.mediumTextStyle(
                                        selectedItem == index
                                            ? blackColor
                                            : greyColor)),
                              ),
                              Container(
                                child: data.user != null
                                    ? Text(data.user.name,
                                        // overflow: TextOverflow.ellipsis,
                                        style: CustomFontStyle.mediumTextStyle(
                                            selectedItem == index
                                                ? blackColor
                                                : greyColor))
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//                  Container(
//                    width:_screenConfig.rW(5) ,
//                    child: Padding(
//                        padding: EdgeInsets.all(_screenConfig.rH(1)),
//                        child: data.driver != null
//                            ? Text(data.driver.name,
//                                overflow: TextOverflow.fade,
//                                style: CustomFontStyle.mediumTextStyle(
//                                    selectedItem == index
//                                        ? blackColor
//                                        : greyColor))
//                            : Container()),
//                  ),

              Icon(
                selectedItem == index
                    ? Icons.arrow_back_ios
                    : Icons.arrow_forward_ios,
                color: selectedItem == index ? blackColor : greyColor,
                size: _screenConfig.rH(4),
              ),
            ],
          ),
          onTap: () {
            setModelState(() {
              selectedItem = index;
            });
          },
        ));
  }
}
