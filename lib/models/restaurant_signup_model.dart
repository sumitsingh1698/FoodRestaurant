class RestaurantSignupModel {
  String emailAddress;
  String password;
  String firstName;
  String lastName;
  String countryPrefix;
  String phone;
  String name;
  String buildingAddress;
  RestaurantLocation restaurantLocation;
  String storeNumber;
  String foodType;
  String mobile;
  String otp;
  String fssai;

  RestaurantSignupModel(
      this.emailAddress,
      this.password,
      this.firstName,
      this.lastName,
      this.countryPrefix,
      this.phone,
      this.name,
      this.buildingAddress,
      this.restaurantLocation,
      this.storeNumber,
      this.foodType,
      this.mobile,
      this.otp,
      this.fssai);

  RestaurantSignupModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json['email_address'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['first_name'];
    countryPrefix = json['country_prefix'];
    phone = json['phone'];
    name = json['name'];
    buildingAddress = json['building_address'];
    restaurantLocation = json['restaurant_location'] != null
        ? new RestaurantLocation.fromJson(json['restaurant_location'])
        : null;
    storeNumber = json['store_number'];
    foodType = json['food_type'];
    mobile = json['mobile'];
    otp = json['otp'];
    fssai = json['fssai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_address'] = this.emailAddress;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['country_prefix'] = this.countryPrefix;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['building_address'] = this.buildingAddress;
    if (this.restaurantLocation != null) {
      data['restaurant_location'] = this.restaurantLocation.toJson();
    }
    data['store_number'] = this.storeNumber;
    data['food_type'] = this.foodType;
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    data['fssai'] = this.fssai;
    return data;
  }
}

class RestaurantLocation {
  String location;

  RestaurantLocation(this.location);

  RestaurantLocation.fromJson(Map<String, dynamic> json) {
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    return data;
  }
}
