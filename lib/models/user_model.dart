class UserModel {
  int id;
  String firstName;
  String lastName;
  String emailAddress;
  Campus campus;
  String phone;
  String logo;
  String name;
  String countryPrefix;
  String storeNumber;

  UserModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.emailAddress,
        this.campus,
        this.phone,
        this.logo,
        this.name,
        this.countryPrefix,
        this.storeNumber});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailAddress = json['email_address'];
    campus =
    json['campus'] != null ? new Campus.fromJson(json['campus']) : null;
    phone = json['phone'];
    logo = json['logo'];
    name = json['name'];
    countryPrefix = json['country_prefix'];
    storeNumber = json['store_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_address'] = this.emailAddress;
    if (this.campus != null) {
      data['campus'] = this.campus.toJson();
    }
    data['phone'] = this.phone;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['country_prefix'] = this.countryPrefix;
    data['store_number'] = this.storeNumber;
    return data;
  }
}

class Campus {
  String name;
  University university;
  String slug;

  Campus({this.name, this.university, this.slug});

  Campus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    university = json['university'] != null
        ? new University.fromJson(json['university'])
        : null;
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.university != null) {
      data['university'] = this.university.toJson();
    }
    data['slug'] = this.slug;
    return data;
  }
}

class University {
  String name;
  String slug;
  int id;

  University({this.name, this.slug, this.id});

  University.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['id'] = this.id;
    return data;
  }
}
