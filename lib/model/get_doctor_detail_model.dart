class GetDoctorDetailModel {
  var id;
  String? address;
  String? api_key;
  String? api_secret;
  String? city;
  String? country;
  List<CustomField>? custom_fields;
  String? dob;
  bool? enableTeleMed;
  String? first_name;
  String? gender;
  String? last_name;
  String? mobile_number;
  String? no_of_experience;
  String? postal_code;
  String? price;
  String? price_type;
  String? profile_image;
  List<Qualification>? qualifications;
  String? role;
  List<Specialty>? specialties;
  String? state;
  String? time_slot;
  String? user_email;
  String? user_login;
  var video_price;
  String? zoom_id;

  GetDoctorDetailModel(
      {this.id,
      this.address,
      this.api_key,
      this.api_secret,
      this.city,
      this.country,
      this.custom_fields,
      this.dob,
      this.enableTeleMed,
      this.first_name,
      this.gender,
      this.last_name,
      this.mobile_number,
      this.no_of_experience,
      this.postal_code,
      this.price,
      this.price_type,
      this.profile_image,
      this.qualifications,
      this.role,
      this.specialties,
      this.state,
      this.time_slot,
      this.user_email,
      this.user_login,
      this.video_price,
      this.zoom_id});

  factory GetDoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return GetDoctorDetailModel(
      id: json['ID'],
      address: json['address'],
      api_key: json['api_key'],
      api_secret: json['api_secret'],
      city: json['city'],
      country: json['country'],
      custom_fields: json['custom_fields'] != null ? (json['custom_fields'] as List).map((i) => CustomField.fromJson(i)).toList() : null,
      dob: json['dob'],
      enableTeleMed: json['enableTeleMed'],
      first_name: json['first_name'],
      gender: json['gender'],
      last_name: json['last_name'],
      mobile_number: json['mobile_number'],
      no_of_experience: json['no_of_experience'],
      postal_code: json['postal_code'],
      price: json['price'],
      price_type: json['price_type'],
      profile_image: json['profile_image'],
      qualifications: json['qualifications'] != null ? (json['qualifications'] as List).map((i) => Qualification.fromJson(i)).toList() : null,
      role: json['role'],
      specialties: json['specialties'] != null ? (json['specialties'] as List).map((i) => Specialty.fromJson(i)).toList() : null,
      state: json['state'],
      time_slot: json['time_slot'],
      user_email: json['user_email'],
      user_login: json['user_login'],
      video_price: json['video_price'],
      zoom_id: json['zoom_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['address'] = this.address;
    data['api_key'] = this.api_key;
    data['api_secret'] = this.api_secret;
    data['city'] = this.city;
    data['country'] = this.country;
    data['dob'] = this.dob;
    data['enableTeleMed'] = this.enableTeleMed;
    data['first_name'] = this.first_name;
    data['gender'] = this.gender;
    data['last_name'] = this.last_name;
    data['mobile_number'] = this.mobile_number;
    data['no_of_experience'] = this.no_of_experience;
    data['postal_code'] = this.postal_code;
    data['price'] = this.price;
    data['price_type'] = this.price_type;
    data['profile_image'] = this.profile_image;
    data['role'] = this.role;
    data['state'] = this.state;
    data['time_slot'] = this.time_slot;
    data['user_email'] = this.user_email;
    data['user_login'] = this.user_login;
    data['video_price'] = this.video_price;
    data['zoom_id'] = this.zoom_id;
    if (this.custom_fields != null) {
      data['custom_fields'] = this.custom_fields!.map((v) => v.toJson()).toList();
    }
    if (this.qualifications != null) {
      data['qualifications'] = this.qualifications!.map((v) => v.toJson()).toList();
    }
    if (this.specialties != null) {
      data['specialties'] = this.specialties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Qualification {
  String? file;
  String? degree;
  String? university;
  var year;

  Qualification({this.file, this.degree, this.university, this.year});

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      file: json['file'],
      degree: json['degree'],
      university: json['university'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['degree'] = this.degree;
    data['university'] = this.university;
    data['year'] = this.year;
    return data;
  }
}

class CustomField {
  String? created_at;
  Fields? fields;
  String? id;
  String? module_id;
  String? module_type;
  String? status;

  CustomField({this.created_at, this.fields, this.id, this.module_id, this.module_type, this.status});

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      created_at: json['created_at'],
      fields: json['fields'] != null ? Fields.fromJson(json['fields']) : null,
      id: json['id'],
      module_id: json['module_id'],
      module_type: json['module_type'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['module_id'] = this.module_id;
    data['module_type'] = this.module_type;
    data['status'] = this.status;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    return data;
  }
}

class Fields {
  String? isRequired;
  String? label;
  String? name;
  String? placeholder;
  String? priority;
  String? status;
  String? type;
  String? value;

  Fields({this.isRequired, this.label, this.name, this.placeholder, this.priority, this.status, this.type, this.value});

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      isRequired: json['isRequired'],
      label: json['label'],
      name: json['name'],
      placeholder: json['placeholder'],
      priority: json['priority'],
      status: json['status'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRequired'] = this.isRequired;
    data['label'] = this.label;
    data['name'] = this.name;
    data['placeholder'] = this.placeholder;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class Specialty {
  String? id;
  String? label;

  Specialty({this.id, this.label});

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}
