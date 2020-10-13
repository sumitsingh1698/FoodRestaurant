import 'package:BellyRestaurant/models/pricing_model.dart';

class EditItemResponseModel {
  Fooditems fooditems;
  bool status;

  EditItemResponseModel({this.fooditems, this.status});

  EditItemResponseModel.fromJson(Map<String, dynamic> json) {
    fooditems = json['fooditems'] != null
        ? new Fooditems.fromJson(json['fooditems'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fooditems != null) {
      data['fooditems'] = this.fooditems.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Fooditems {
  int single;
  int set;
  List<Item> list;

  Fooditems({this.single, this.set, this.list});

  Fooditems.fromJson(Map<String, dynamic> json) {
    single = json['single'];
    set = json['set'];
    if (json['list'] != null) {
      list = new List<Item>();
      json['list'].forEach((v) {
        list.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['single'] = this.single;
    data['set'] = this.set;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String type;
  List<Pricing> pricing;
  String image;
  int id;
  String shortDescription;
  String name;

  Item(
      {this.type,
      this.pricing,
      this.image,
      this.id,
      this.shortDescription,
      this.name});

  Item.fromJson(Map<String, dynamic> json) {
    type = json['type'];

    image = json['image'];
    id = json['id'];
    shortDescription = json['short_description'];
    name = json['name'];
    // print("pricing ${json['pricing'].toString()}");
    if (json['pricing'] != null) {
      pricing = new List<Pricing>();
      json['pricing'].forEach((v) {
        pricing.add(new Pricing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.pricing != null) {
      data['pricing'] = this.pricing.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    data['id'] = this.id;
    data['short_description'] = this.shortDescription;
    data['name'] = this.name;
    return data;
  }
}
