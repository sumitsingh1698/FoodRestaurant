class NewOrderModel {
  String orderNo;
  String slottime;
  String user;
  String id;
  List<Orderitems> orderitems;
  double grandtotal;

  NewOrderModel(
      {this.orderNo,
      this.slottime,
      this.user,
      this.id,
      this.orderitems,
      this.grandtotal});

  NewOrderModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Orderitems {
  String itemName;
  double itemPrice;
  int count;
  String size;
  String notes;

  Orderitems({this.itemName, this.itemPrice, this.count, this.size});

  Orderitems.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    count = json['count'];
    size = json['size'];
    notes = json["restaurant_note"];
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
