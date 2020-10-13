import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/nav_drawer_data.dart';
import 'package:BellyRestaurant/models/list_menu_item_model.dart';
import 'package:BellyRestaurant/ui/screens/edit_products_new.dart';
import 'package:BellyRestaurant/ui/screens/profile_edit_page.dart';
import 'package:BellyRestaurant/ui/screens/welcome_page.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class HeaderMainScreen extends StatefulWidget {
  @override
  _HeaderMainScreenState createState() => _HeaderMainScreenState();
}

class _HeaderMainScreenState extends State<HeaderMainScreen> {
  bool _onlineButtonPressed = false;
  double _containerHeight = 0;
  bool _dataLoaded = false;
  String token;
  NavDrawerDataSource _dataSource = new NavDrawerDataSource();
  ListItemResponseModel data;
  AppConfig _screenConfig;
  double initialWidth = 0;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
  }

  void getData() async {
    data = await _dataSource.itemStatusDetail(token);
    if (data != null)
      setState(() {
        _dataLoaded = true;
      });
  }

  void refreshData() async {
    data = await _dataSource.itemStatusDetail(token);
    if (data != null) {
      setState(() {
        _containerHeight = 24;
        _dataLoaded = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _containerHeight = 0;
        });
      });
    }
  }

  changeRestaurantAvailability(status) async {
    bool _changedStatus =
        await _dataSource.changeRestaurantStatus(token, status);
    refreshData();
  }

  changeItemAvailability(id, status) async {
    bool _changedStatus = await _dataSource.changeItemStatus(token, id, status);
  }

  _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_phone', '');
    prefs.setBool('loggedIn', false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return Padding(
      padding: EdgeInsets.only(top: _screenConfig.rH(6)),
      child: Container(
        color: blackColor,
        child: _header(),
        width: _screenConfig.rW(80),
      ),
    );
  }

  Widget _header() => Container(
        color: whiteColor,
        child: Padding(
          padding: EdgeInsets.only(top: _screenConfig.rH(4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: _screenConfig.rH(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Text(
                        signOut,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          letterSpacing: 1.0,
                          fontFamily: 'NotoSansJP',
                          color: disabledGrey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildLogoutConfirmDialog(context));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: _screenConfig.rW(8),
                          right: _screenConfig.rW(8)),
                      child: InkWell(
                          child: Icon(
                            Icons.settings,
                            color: blackColor,
                            size: _screenConfig.rH(6),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileEditPage()),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              !_dataLoaded
                  ? LinearProgressIndicator(
                      backgroundColor: whiteColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        greenBellyColor,
                      ),
                    )
                  : Container(
                      height: 1,
                      color: cloudsColor,
                    ),
              !_dataLoaded
                  ? Container()
                  : data.availableStatus == "available"
                      ? AnimatedContainer(
                          duration: new Duration(milliseconds: 200),
                          height: _containerHeight,
                          color: lightGreenColor,
                          child: Center(
                            child: Text(
                              acceptingOrders,
                              style:
                                  CustomFontStyle.mediumTextStyle(Colors.green),
                            ),
                          ),
                        )
                      : AnimatedContainer(
                          duration: new Duration(milliseconds: 200),
                          height: _containerHeight,
                          color: lightPinkColor,
                          child: Center(
                            child: Text(
                              ordersSuspended,
                              style: CustomFontStyle.mediumTextStyle(redColor),
                            ),
                          ),
                        ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: _screenConfig.rH(2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Spacer(),
                    _dataLoaded
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                  child: data.availableStatus == "available"
                                      ? Icon(
                                          Icons.pause_circle_filled,
                                          color: greenColor,
                                          size: _screenConfig.rH(7),
                                        )
                                      : Icon(
                                          Icons.play_circle_filled,
                                          color: Colors.redAccent,
                                          size: _screenConfig.rH(7),
                                        ),
                                  onTap: () {
                                    data.availableStatus == "available"
                                        ? changeRestaurantAvailability(
                                            "not_accepting_order")
                                        : changeRestaurantAvailability(
                                            "available");
                                  }),
                              Text(
                                data.availableStatus == "available"
                                    ? stopOrders
                                    : acceptOrders,
                                style:
                                    CustomFontStyle.mediumTextStyle(greyColor),
                              ),
                            ],
                          )
                        : Container(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(right: _screenConfig.rW(4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                    child: Icon(
                                      Icons.add,
                                      color: blackColor,
                                      size: _screenConfig.rH(7),
                                    ),
                                    onTap: () {
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProductsNewPage()),
                                        );
                                      }
                                    }),
                                Center(
                                  child: Text(
                                    addToMenu,
                                    style: CustomFontStyle.mediumTextStyle(
                                        greyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _screenConfig.rW(2),
                    )
                  ],
                ),
              ),
              _dataLoaded
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: _screenConfig.rH(3),
                            left: _screenConfig.rH(3),
                            right: _screenConfig.rH(3)),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.name,
                                style: CustomFontStyle.mediumBoldTextStyle(
                                    blackColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: _screenConfig.rH(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      singleItem,
                                      style:
                                          CustomFontStyle.mediumBoldTextStyle(
                                              greyColor),
                                    ),
                                    Text(
                                      "all " +
                                          data.countSingle.toString() +
                                          " Product",
                                      style:
                                          CustomFontStyle.mediumBoldTextStyle(
                                              blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.single.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _menuItemCell(
                                      data.single[index], index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                height: 1,
                color: cloudsColor,
              ),
              Padding(padding: EdgeInsets.only(top: _screenConfig.rH(4))),
            ],
          ),
        ),
      );

  Widget _buildLogoutConfirmDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0)), //this right here
      child: SingleChildScrollView(
        child: Container(
          width: _screenConfig.rW(54),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    areYouSureWantLogout,
                    style: CustomFontStyle.mediumBoldTextStyle(blackColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cloudsColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Container(
                          width: _screenConfig.rW(14),
                          height: _screenConfig.isLargeScreen
                              ? _screenConfig.rH(7)
                              : _screenConfig.rH(10),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: _screenConfig.rW(2),
                                right: _screenConfig.rW(2)),
                            child: Center(
                              child: Text(
                                no,
                                style: CustomFontStyle.bottomButtonTextStyle(
                                    blackColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        _handleLogout();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: blackColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Container(
                          width: _screenConfig.rW(14),
                          height: _screenConfig.isLargeScreen
                              ? _screenConfig.rH(7)
                              : _screenConfig.rH(10),
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
                Padding(padding: EdgeInsets.only(top: _screenConfig.rH(6))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItemCell(var item, index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _screenConfig.rH(2)),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                item.name,
                style: CustomFontStyle.regularBoldTextStyle(blackColor),
              ),
            ),
//            InkWell(
//                child: item.availStatus == "Available"
//                    ? Container(
//                        padding: EdgeInsets.all(_screenConfig.rHP(1)),
//                        decoration:
//                            BoxDecoration(border: Border.all(color: greyColor)),
//                        child: Text(
//                          available,
//                          style: CustomFontStyle.smallTextStyle(blackColor),
//                        ),
//                      )
//                    : Container(
//                        padding: EdgeInsets.all(_screenConfig.rHP(1)),
//                        decoration: BoxDecoration(
//                            color: lightPinkColor,
//                            border: Border.all(
//                              color: Colors.redAccent,
//                            )),
//                        child: Text(
//                          soldOut,
//                          style: CustomFontStyle.smallTextStyle(
//                            Colors.redAccent,
//                          ),
//                        ),
//                      ),
//                onTap: () {
//                  item.availStatus == "Available"
//                      ? changeItemAvailability(item.id, "out_of_stock")
//                      : changeItemAvailability(item.id, "available");
//                  getData();
//                }),
          ],
        ),
      ),
    );
  }
}
