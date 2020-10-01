class ListItemResponseModel {
  List<Set> set;
  List<Single> single;
  String name;
  String availableStatus;
  int id;
  int countSet;
  int countSingle;

  ListItemResponseModel(
      {this.set,
      this.single,
      this.name,
      this.availableStatus,
      this.id,
      this.countSet,
      this.countSingle});

  ListItemResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['set'] != null) {
      set = new List<Set>();
      json['set'].forEach((v) {
        set.add(new Set.fromJson(v));
      });
    }
    if (json['single'] != null) {
      single = new List<Single>();
      json['single'].forEach((v) {
        single.add(new Single.fromJson(v));
      });
    }
    name = json['name'];
    availableStatus = json['available_status:'];
    id = json['id'];
    countSet = json['count_set'];
    countSingle = json['count_single'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.set != null) {
      data['set'] = this.set.map((v) => v.toJson()).toList();
    }
    if (this.single != null) {
      data['single'] = this.single.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['available_status:'] = this.availableStatus;
    data['id'] = this.id;
    data['count_set'] = this.countSet;
    data['count_single'] = this.countSingle;
    return data;
  }
}

class Set {
  String name;
  double price;
  String availStatus;
  String image;
  int id;

  Set({this.name, this.price, this.availStatus, this.image, this.id});

  Set.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    availStatus = json['avail_status'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['avail_status'] = this.availStatus;
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}

class Single {
  String name;
  double price;
  String availStatus;
  String image;
  int id;

  Single({this.name, this.price, this.availStatus, this.image, this.id});

  Single.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    availStatus = json['avail_status'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['avail_status'] = this.availStatus;
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}
