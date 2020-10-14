class PickupOrdersResponseModel {
  String orderNo;
  String slottime;
  String user;
  String id;
  List<Orderitems> orderitems;
  double grandtotal;
  Driver driver;
  String restaurantNote;

  PickupOrdersResponseModel(
      {this.orderNo,
      this.slottime,
      this.user,
      this.id,
      this.orderitems,
      this.grandtotal,
      this.driver,
      this.restaurantNote});

  PickupOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    slottime = json['slottime'];
    user = json['user'];
    id = json['id'];
    if (json['orderitems'] != null) {
      orderitems = new List<Orderitems>();
      json['orderitems'].forEach((v) {
        orderitems.add(new Orderitems.fromJson(v));
      });
    }
    grandtotal = json['grandtotal'];
    restaurantNote = json['restaurant_note'];
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['slottime'] = this.slottime;
    data['user'] = this.user;
    data['id'] = this.id;
    if (this.orderitems != null) {
      data['orderitems'] = this.orderitems.map((v) => v.toJson()).toList();
    }
    data['grandtotal'] = this.grandtotal;
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    data['restaurant_note'] = restaurantNote;

    return data;
  }
}

class Orderitems {
  String itemName;
  double itemPrice;
  int count;
  String size;

  Orderitems({this.itemName, this.itemPrice, this.count, this.size});

  Orderitems.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    count = json['count'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['item_price'] = this.itemPrice;
    data['count'] = this.count;
    data['size'] = this.size;
    return data;
  }
}

class Driver {
  String profilePic;
  String phone;
  String name;

  Driver({this.profilePic, this.phone, this.name});

  Driver.fromJson(Map<String, dynamic> json) {
    profilePic = json['profile_pic'];
    phone = json['phone'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_pic'] = this.profilePic;
    data['phone'] = this.phone;
    data['name'] = this.name;
    return data;
  }
}
