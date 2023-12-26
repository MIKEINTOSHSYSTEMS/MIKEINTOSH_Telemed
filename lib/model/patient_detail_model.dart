class PatientDetailModel {
  String? address;
  String? blood_group;
  String? city;
  String? country;
  String? dob;
  String? first_name;
  String? gender;
  String? last_name;
  String? mobile_number;
  String? postal_code;
  String? profile_image;
  String? state;
  String? user_email;
  String? user_login;

  PatientDetailModel({this.address, this.blood_group, this.city, this.country, this.dob, this.first_name, this.gender, this.last_name, this.mobile_number, this.postal_code, this.profile_image, this.state, this.user_email, this.user_login});

  factory PatientDetailModel.fromJson(Map<String, dynamic> json) {
    return PatientDetailModel(
      address: json['address'],
      blood_group: json['blood_group'],
      city: json['city'],
      country: json['country'],
      dob: json['dob'],
      first_name: json['first_name'],
      gender: json['gender'],
      last_name: json['last_name'],
      mobile_number: json['mobile_number'],
      postal_code: json['postal_code'],
      profile_image: json['profile_image'],
      state: json['state'],
      user_email: json['user_email'],
      user_login: json['user_login'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['blood_group'] = this.blood_group;
    data['city'] = this.city;
    data['country'] = this.country;
    data['dob'] = this.dob;
    data['first_name'] = this.first_name;
    data['gender'] = this.gender;
    data['last_name'] = this.last_name;
    data['mobile_number'] = this.mobile_number;
    data['postal_code'] = this.postal_code;
    data['profile_image'] = this.profile_image;
    data['state'] = this.state;
    data['user_email'] = this.user_email;
    data['user_login'] = this.user_login;
    return data;
  }
}
