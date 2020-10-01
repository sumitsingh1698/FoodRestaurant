// import 'dart:html';

import 'package:flutter/material.dart';

class AppConfig {
  BuildContext _context;
  double _height;
  double _width;
  double _heightPadding;
  double _widthPadding;
  bool isLargeScreen = true;
  AppConfig(this._context) {
    MediaQueryData _queryData = MediaQuery.of(_context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
    if (_queryData.size.width > 600) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
  }

  double rH(double v) {
    return isLargeScreen ? _height * v : _height * (v * 0.5);
    // return _height * v;
  }

  double rW(double v) {
    return isLargeScreen ? _width * v : _width * (v);
    // return _width * v;
  }

  double rHP(double v) {
    return isLargeScreen ? _heightPadding * v : _widthPadding * (v * 0.5);
    // return _heightPadding * v;
  }

  double rWP(double v) {
    return isLargeScreen ? _widthPadding * v : _heightPadding * (v * 0.5);
    // return _widthPadding * v;
  }
}
