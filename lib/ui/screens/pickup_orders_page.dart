import 'package:BellyRestaurant/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'dart:async';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/constants.dart';
import 'package:BellyRestaurant/data/pickup_orders_data.dart';
import 'package:BellyRestaurant/models/pickup_order_model.dart';
import 'package:BellyRestaurant/ui/widgets/new_order_detail_screen.dart';
import 'package:BellyRestaurant/ui/widgets/order_detail_temp.dart';
import 'package:BellyRestaurant/ui/widgets/pickup_order_detail.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class PickUpOrdersPage extends StatefulWidget {
  @override
  _PickUpOrdersPageState createState() => _PickUpOrdersPageState();
}

class _PickUpOrdersPageState extends State<PickUpOrdersPage> {
  bool isLoading = false;
  SharedPreferences prefs;
  AppConfig _screenConfig;
  String token;
  var count = 0;
  PickupOrdersDataSource _pickupOrdersDataSource = new PickupOrdersDataSource();
  int selectedItem = 0;
  List<PickupOrdersResponseModel> data;
  StreamController<bool> _controller = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getSharedPrefs();
    _controller.stream.listen((onData) {
      if (onData) {
        print('stream controller');
        selectedItem = 0;
        this.getData();
      }
    });
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
  }

  void getData() async {
    isLoading = true;
    data = await _pickupOrdersDataSource.getPickupOrdersData(token);
    count = data.length;
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
            : (count == 0)
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Text(
                          noPickedUpOrders,
                          textAlign: TextAlign.justify,
                          style:
                              CustomFontStyle.mediumBoldTextStyle(blackColor),
                        )))
                : Stack(
                    children: <Widget>[
                      Container(
                        color: formBgColor,
                      ),
                      _buildOrdersList(context),
                    ],
                  ));
  }

  Widget _buildOrdersList(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_screenConfig.rH(4)),
                child: new Text(waitingForPickUp,
                    style: CustomFontStyle.mediumBoldTextStyle(blackColor)),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: new Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: _buildOrderCell(data[index], index)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
            width: _screenConfig.rH(52),
            child: PickUpOrderDetailPage(data[selectedItem], _controller))
      ],
    );
  }

  Widget _buildOrderCell(PickupOrdersResponseModel _pickupOrder, index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _screenConfig.rH(4)),
      child: Container(
          color: whiteColor,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(_screenConfig.rH(1)),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(_screenConfig.rH(2)),
                          child: Text(_pickupOrder.slottime.substring(0, 5),
                              style: CustomFontStyle.regularBoldTextStyle(
                                  selectedItem == index
                                      ? blackColor
                                      : greyColor)),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(_screenConfig.rH(2)),
                          child: Text("ID " + _pickupOrder.orderNo,
                              style: CustomFontStyle.regularBoldTextStyle(
                                  selectedItem == index
                                      ? blackColor
                                      : greyColor)),
                        ),
                      ),
                      Container(
                        child: Text(_pickupOrder.user,
                            style: TextStyle(
                              color: selectedItem == index
                                  ? blackColor
                                  : greyColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSansJP',
                              fontSize: 14.0,
                            )
                            //  CustomFontStyle.regularBoldTextStyle(
                            //     selectedItem == index
                            //         ? blackColor
                            //         : greyColor)
                            ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: _pickupOrder.driver.profilePic != null
                        ? NetworkImage(_pickupOrder.driver.profilePic)
                        : NetworkImage(userImageUrl),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: _screenConfig.rW(3),
                  ),
                  Icon(
                    selectedItem == index
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: selectedItem == index ? blackColor : greyColor,
                    size: _screenConfig.rH(4),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                selectedItem = index;
              });
            },
          )),
    );
  }
}
