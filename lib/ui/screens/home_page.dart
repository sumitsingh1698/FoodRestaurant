import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/constants/String.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/Style.dart';
import 'package:BellyRestaurant/data/authentication_data.dart';
import 'package:BellyRestaurant/models/count_provider.dart';
import 'package:BellyRestaurant/ui/screens/new_orders_page.dart';
import 'package:BellyRestaurant/ui/screens/order_history_page.dart';
import 'package:BellyRestaurant/ui/screens/pickup_orders_page.dart';
import 'package:BellyRestaurant/ui/widgets/header_screen.dart';
import 'package:BellyRestaurant/ui/widgets/order_cancelled_alert_dialog.dart';
import 'package:BellyRestaurant/ui/widgets/no_internet_dialog.dart';
import 'package:BellyRestaurant/utils/app_config.dart';
import 'package:BellyRestaurant/utils/internet_connectivity.dart';
import 'package:BellyRestaurant/utils/show_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var events = [];
  TabController _tabController;
  AppConfig _screenConfig;
  final GlobalKey _scaffoldKey = new GlobalKey();
  AuthDataSource _authDataSource = new AuthDataSource();
  var data;
  String token;
  bool isOffline = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  GlobalKey<NewOrdersPageState> _keyChild1 = GlobalKey();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    Future.delayed(Duration(seconds: 1), () {
      MyConnectivity.instance.initialise();
      MyConnectivity.instance.myStream.listen((onData) {
        if (MyConnectivity.instance.isIssue(onData)) {
          if (MyConnectivity.instance.isShow == false) {
            MyConnectivity.instance.isShow = true;
            showDialogNotInternet(context).then((onValue) {
              MyConnectivity.instance.isShow = false;
            });
          }
        } else {
          if (MyConnectivity.instance.isShow == true) {
            Navigator.of(context).pop();
            MyConnectivity.instance.isShow = false;
          }
        }
      });
    });
  }

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getFCMToken();
  }

  void getFCMToken() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        if (message['type'] == "neworder")
          onDidReceiveNewOrder(message);
        else if (message['type'] == "ordercancelled") {
          showOrderCancelledDialog(context, message);
          FlutterRingtonePlayer.playNotification();
        }
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        if (_tabController.index == 0)
          _keyChild1.currentState.getData();
        else
          _tabController.animateTo(0);

        FlutterRingtonePlayer.playNotification();
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        return;
      },
    );
    if (Platform.isIOS)
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((fcmToken) {
      try {
        print("fcm token : " + fcmToken);
        _authDataSource.sendFCMToken(token, fcmToken);
      } on Exception catch (e) {
        print(e);
      }
    });
  }

  Future onDidReceiveNewOrder(Map<String, dynamic> message) async {
    if (_tabController.index == 0) _keyChild1.currentState.getData();
    //   final audioPlayer = AudioPlayer(playerId: 'my_unique_playerId');
    //       final audioPlayer = AudioPlayer(playerId: 'notification');
    //  final file = new File('${(await getTemporaryDirectory()).path}/assets/audios/presto.mp3');
    //  await file.writeAsBytes((await loadAsset()).buffer.asUint8List());
    //  final result = await audioPlayer.play(file.path, isLocal: true);
    FlutterRingtonePlayer.playNotification();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: InkWell(
          onTap: () {
            _tabController.animateTo(0);
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Container(
            color: blackBellyColor,
            height: _screenConfig.rH(100),
            width: _screenConfig.rW(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _screenConfig.rH(24),
                        height: _screenConfig.rH(24),
                        decoration: new BoxDecoration(
                          color: offCream,
                          shape: BoxShape.circle,
                        ),
                        child: new Center(
                          child: new Text("1",
                              style: TextStyle(
                                color: whiteBellyColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'NotoSansJP',
                                fontSize: 64.0,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 50.0)),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    newOrders,
                    style: CustomFontStyle.mainHeading2Style(whiteBellyColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    touchToViewNewOrders,
                    style: CustomFontStyle.subHeadingStyle(whiteBellyColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: HeaderMainScreen(),
          appBar: AppBar(
              bottom: PreferredSize(
                  child: Container(
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width:
                              // 60,
                              _screenConfig.rW(70),
                          child: Consumer<CountModel>(
                              builder: (context, _counts, child) {
                            return TabBar(
                                controller: _tabController,
                                labelPadding:
                                    EdgeInsets.only(left: 0, right: 0),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                indicatorColor: Colors.white,
                                indicatorSize: TabBarIndicatorSize.tab,
                                isScrollable: false,
                                tabs: [
                                  tabItemUI(
                                      Icon(
                                        Icons.notifications,
                                        color: _tabController.index == 0
                                            ? blackColor
                                            : greyColor,
                                        size: _screenConfig.rH(5),
                                      ),
                                      "Orders",
                                      _counts.getNewOrderCount != null
                                          ? _counts.getNewOrderCount.toString()
                                          : "0"),
                                  tabItemUI(
                                      Icon(
                                        Icons.timelapse,
                                        color: _tabController.index == 1
                                            ? blackColor
                                            : greyColor,
                                        size: _screenConfig.rH(5),
                                      ),
                                      pickUp,
                                      _counts.pickUpOrderCount != null
                                          ? _counts.pickUpOrderCount.toString()
                                          : "0"),
                                  tabItemUI(
                                      Icon(
                                        Icons.history,
                                        color: _tabController.index == 2
                                            ? blackColor
                                            : greyColor,
                                        size: _screenConfig.rH(5),
                                      ),
                                      "History",
                                      "0")
                                ]);
                          }),
                        ),
                        Builder(
                          builder: (context) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _screenConfig.rW(4)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.account_circle,
                                  color: blackColor,
                                  size: _screenConfig.rH(5),
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                  preferredSize:
                      Size.fromHeight(_screenConfig.isLargeScreen ? 15 : 15))),
          body: new ExtendedTabBarView(
            controller: _tabController,
            children: <Widget>[
              NewOrdersPage(stateKey: _keyChild1),
              PickUpOrdersPage(),
              OrderHistoryPage(),
            ],
          ),
        ));
  }

  Widget tabItemUI(Icon icon, String text, count) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: CustomFontStyle.regularBoldTextStyle(blackColor),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              text == orderHistory
                  ? Container()
                  : Container(
                      child: Text(
                        count,
                        style: CustomFontStyle.smallTextStyle(whiteColor),
                      ),
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      padding: EdgeInsets.all(_screenConfig.rH(0.5)),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
