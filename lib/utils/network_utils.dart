import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  Future<dynamic> signUpPhoneValidation(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> sendOtp(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> signUpOtpAuthentication(String url, data) async {
    print(data);
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> loginPasswordAuthentication(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getCampuses(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getUniversities(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getRestaurantItems(String url, token) async {
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      print(parsed);
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postLoginRequest(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> signUpFormSubmission(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getCartDetails(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> addItemToCart(String url, String token, data) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getData(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      print('pickup error $parsed');
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getNewOrdersData(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getOrderHistory(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode == 200) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      return parsed;
    }
  }

  Future<dynamic> acceptorreject(String url, token, body) async {
    Map<String, String> requestHeaders = {
      // 'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> changeStatus(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postFCMToken(String url, token, data) async {
    var _body = json.encode(data);
    print('fffffffffffffcccccccccmmmmmmmmmmmmmmTTTTTOOOOOOOOOKKKKKEEENNNN');
    print(_body);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };

    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> putData(String url, data, token) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.put(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }
}
