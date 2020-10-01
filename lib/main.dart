import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyRestaurant/constants/Color.dart';
import 'package:BellyRestaurant/models/count_provider.dart';
import 'package:BellyRestaurant/ui/screens/home_page.dart';
import 'package:BellyRestaurant/ui/screens/welcome_page.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() => new MyAppState();

  MyApp({Key key}) : super(key: key);
}

class MyAppState extends State<MyApp> {
  Widget _defaultHome = new WelcomePage();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
  }

  void initSharedPreference() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var loggedIn = _sharedPreferences.getBool("loggedIn").toString();
    if (loggedIn != 'null' && loggedIn != 'false') {
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          _loading = false;
          _defaultHome = new HomeScreen();
        });
      });
    } else
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          _loading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    return ChangeNotifierProvider(
        create: (context) => CountModel(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: _loading ? SplashScreen() : _defaultHome,
          title: 'Belly Restaurant',
          theme: ThemeData(
            primarySwatch: primaryBlack,
            cursorColor: Colors.black,
          ),
        ));
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: greenBellyColor,
      child: Center(
          child: Container(
        child: Image.asset(
          'assets/splashscreen.png',
          fit: BoxFit.contain,
        ),
      )),
    );
  }
}
