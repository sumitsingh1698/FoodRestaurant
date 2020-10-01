import 'package:BellyRestaurant/utils/base_url.dart';
import 'package:BellyRestaurant/utils/network_utils.dart';

class ListData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String foodTypeList =
      "http://15.207.180.104/userapp/foodtypelist/";

  static final String foodCategoryList =
      "http://15.207.180.104/restapp/foodcategory/";

  Future<Map> foodTypes() {
    return _netUtil.getUniversities(foodTypeList).then((dynamic res) async {
      return res;
    });
  }

  Future<Map> foodcategoryList() {
    return _netUtil.getUniversities(foodCategoryList).then((dynamic res) async {
      return res;
    });
  }
}
