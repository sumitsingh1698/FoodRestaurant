import 'package:provider/provider.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'dart:async';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/data/new_orders_data.dart';
import 'package:BellyRestaurant/models/count_provider.dart';
import 'package:BellyRestaurant/models/new_order_model.dart';
import 'package:BellyRestaurant/ui/widgets/new_order_detail_screen.dart';
import 'package:BellyRestaurant/utils/app_config.dart';

class NewOrdersPage extends StatefulWidget {
  final Key stateKey;

  NewOrdersPage({Key key, this.stateKey}) : super(key: stateKey);

  @override
  NewOrdersPageState createState() => NewOrdersPageState();
}

class NewOrdersPageState extends State<NewOrdersPage> {
  bool isLoading = true;
  SharedPreferences prefs;
  AppConfig _screenConfig;
  String token;
  var count = 0;
  NewOrdersDataSource _newOrdersDataSource = new NewOrdersDataSource();
  int selectedItem = 0;
  List<NewOrderModel> data;
  StreamController<bool> _controller = StreamController<bool>();
  Timer timer;
  CountModel _countsProvider;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    _controller.stream.listen((onData) {
      if (onData) {
        print('stream controller');
        selectedItem = 0;
        this.getData();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    _controller.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_countsProvider == null) {
      _countsProvider = Provider.of<CountModel>(context);
    }
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
//    timer = Timer.periodic(Duration(seconds: 10),
//        (Timer t) => _countsProvider.getCountData(token));
    data = await _newOrdersDataSource.getNewOrdersData(token);
    count = data.length;
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
            : (count == 0)
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Text(
                          noNewOrders,
                          textAlign: TextAlign.justify,
                          style:
                              CustomFontStyle.mediumBoldTextStyle(blackColor),
                        )))
                : Stack(
                    children: <Widget>[
                      Container(
                        color: formBgColor,
                      ),
                      _buildNewOrdersList(context),
                    ],
                  ));
  }

  Widget _buildNewOrdersList(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_screenConfig.rH(4)),
                child: new Text("Orders",
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
                          child: _buildNewOrderCell(
                            data[index],
                            index,
                          )),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
            width: _screenConfig.rH(52),
            child: OrderDetailPage(data[selectedItem], _controller))
      ],
    );
  }

  Widget responsiveNewOrder(NewOrderModel newOrder, index) {
    if (MediaQuery.of(context).size.width > 600) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(2)),
                  child: Text(newOrder.slottime.substring(0, 5),
                      style: CustomFontStyle.regularBoldTextStyle(
                          selectedItem == index ? blackColor : greyColor)),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(2)),
                  child: Text("ID " + newOrder.orderNo,
                      style: CustomFontStyle.regularBoldTextStyle(
                          selectedItem == index ? blackColor : greyColor)),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(_screenConfig.rH(2)),
                  child: Text(newOrder.user,
                      style: CustomFontStyle.regularBoldTextStyle(
                          selectedItem == index ? blackColor : greyColor)),
                ),
              ),
            ],
          ),
          Icon(
            selectedItem == index
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
            color: selectedItem == index ? blackColor : greyColor,
            size: _screenConfig.rH(4),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(_screenConfig.rH(2)),
              child: Text(newOrder.slottime.substring(0, 5),
                  style: CustomFontStyle.regularBoldTextStyle(
                      selectedItem == index ? blackColor : greyColor)),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(_screenConfig.rH(2)),
              child: Text("ID " + newOrder.orderNo,
                  style: CustomFontStyle.regularBoldTextStyle(
                      selectedItem == index ? blackColor : greyColor)),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(_screenConfig.rH(2)),
              child: Text(newOrder.user,
                  style: CustomFontStyle.regularBoldTextStyle(
                      selectedItem == index ? blackColor : greyColor)),
            ),
          ),
          Icon(
            selectedItem == index
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
            color: selectedItem == index ? blackColor : greyColor,
            size: _screenConfig.rH(4),
          ),
        ],
      );
    }
  }

  Widget _buildNewOrderCell(NewOrderModel newOrder, index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _screenConfig.rH(4)),
      child: Container(
          color: whiteColor,
          child: InkWell(
            child: Padding(
                padding: EdgeInsets.all(_screenConfig.rH(1)),
                child: responsiveNewOrder(newOrder, index)),
            onTap: () {
              setState(() {
                selectedItem = index;
              });
            },
          )),
    );
  }
}
