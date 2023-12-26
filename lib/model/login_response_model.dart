class LoginResponseModel {
  String? address;
  String? api_key;
  String? api_secret;
  String? city;
  List<Clinic>? clinic;
  List<Object>? common_setting;
  String? country;
  String? dob;
  bool? enableTeleMed;
  List<EnocunterModule>? enocunter_modules;
  String? first_name;
  String? gender;
  String? google_client_id;
  bool? isKiviCareProOnName;
  bool? isTeleMedActive;
  String? is_enable_doctor_gcal;
  String? is_enable_google_cal;
  String? is_patient_enable;
  String? last_name;
  String? mobile_number;
  List<ModuleConfig>? module_config;
  String? no_of_experience;
  List<Object>? notification;
  String? postal_code;
  List<PrescriptionModule>? prescription_module;
  String? price;
  String? price_type;
  String? profile_image;
  List<Qualification>? qualifications;
  String? role;
  List<Specialty>? specialties;
  String? token;
  String? user_display_name;
  String? user_email;
  int? user_id;
  String? user_nicename;
  String? zoom_id;

  LoginResponseModel(
      {this.address,
      this.api_key,
      this.api_secret,
      this.city,
      this.clinic,
      this.common_setting,
      this.country,
      this.dob,
      this.enableTeleMed,
      this.enocunter_modules,
      this.first_name,
      this.gender,
      this.google_client_id,
      this.isKiviCareProOnName,
      this.isTeleMedActive,
      this.is_enable_doctor_gcal,
      this.is_enable_google_cal,
      this.is_patient_enable,
      this.last_name,
      this.mobile_number,
      this.module_config,
      this.no_of_experience,
      this.notification,
      this.postal_code,
      this.prescription_module,
      this.price,
      this.price_type,
      this.profile_image,
      this.qualifications,
      this.role,
      this.specialties,
      this.token,
      this.user_display_name,
      this.user_email,
      this.user_id,
      this.user_nicename,
      this.zoom_id});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      address: json['address'],
      api_key: json['api_key'],
      api_secret: json['api_secret'],
      city: json['city'],
      clinic: json['clinic'] != null ? (json['clinic'] as List).map((i) => Clinic.fromJson(i)).toList() : null,
      //   common_setting: json['common_setting'] != null ? (json['common_setting'] as List).map((i) => Object.fromJson(i)).toList() : null,
      country: json['country'],
      dob: json['dob'],
      enableTeleMed: json['enableTeleMed'],
      enocunter_modules: json['enocunter_modules'] != null ? (json['enocunter_modules'] as List).map((i) => EnocunterModule.fromJson(i)).toList() : null,
      first_name: json['first_name'],
      gender: json['gender'],
      google_client_id: json['google_client_id'],
      isKiviCareProOnName: json['isKiviCareProOnName'],
      isTeleMedActive: json['isTeleMedActive'],
      is_enable_doctor_gcal: json['is_enable_doctor_gcal'],
      is_enable_google_cal: json['is_enable_google_cal'],
      is_patient_enable: json['is_patient_enable'],
      last_name: json['last_name'],
      mobile_number: json['mobile_number'],
      module_config: json['module_config'] != null ? (json['module_config'] as List).map((i) => ModuleConfig.fromJson(i)).toList() : null,
      no_of_experience: json['no_of_experience'],
      //  notification: json['notification'] != null ? (json['notification'] as List).map((i) => Object.fromJson(i)).toList() : null,
      postal_code: json['postal_code'],
      prescription_module: json['prescription_module'] != null ? (json['prescription_module'] as List).map((i) => PrescriptionModule.fromJson(i)).toList() : null,
      price: json['price'],
      price_type: json['price_type'],
      profile_image: json['profile_image'],
      qualifications: json['qualifications'] != null ? (json['qualifications'] as List).map((i) => Qualification.fromJson(i)).toList() : null,
      role: json['role'],
      specialties: json['specialties'] != null ? (json['specialties'] as List).map((i) => Specialty.fromJson(i)).toList() : null,
      token: json['token'],
      user_display_name: json['user_display_name'],
      user_email: json['user_email'],
      user_id: json['user_id'],
      user_nicename: json['user_nicename'],
      zoom_id: json['zoom_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['api_key'] = this.api_key;
    data['api_secret'] = this.api_secret;
    data['city'] = this.city;
    data['country'] = this.country;
    data['dob'] = this.dob;
    data['enableTeleMed'] = this.enableTeleMed;
    data['first_name'] = this.first_name;
    data['gender'] = this.gender;
    data['google_client_id'] = this.google_client_id;
    data['isKiviCareProOnName'] = this.isKiviCareProOnName;
    data['isTeleMedActive'] = this.isTeleMedActive;
    data['is_enable_doctor_gcal'] = this.is_enable_doctor_gcal;
    data['is_enable_google_cal'] = this.is_enable_google_cal;
    data['is_patient_enable'] = this.is_patient_enable;
    data['last_name'] = this.last_name;
    data['mobile_number'] = this.mobile_number;
    data['no_of_experience'] = this.no_of_experience;
    data['postal_code'] = this.postal_code;
    data['price'] = this.price;
    data['price_type'] = this.price_type;
    data['profile_image'] = this.profile_image;
    data['role'] = this.role;
    data['token'] = this.token;
    data['user_display_name'] = this.user_display_name;
    data['user_email'] = this.user_email;
    data['user_id'] = this.user_id;
    data['user_nicename'] = this.user_nicename;
    data['zoom_id'] = this.zoom_id;
    if (this.clinic != null) {
      data['clinic'] = this.clinic!.map((v) => v.toJson()).toList();
    }
    /* if (this.common_setting != null) {
            data['common_setting'] = this.common_setting.map((v) => v.toJson()).toList();
        }*/
    if (this.enocunter_modules != null) {
      data['enocunter_modules'] = this.enocunter_modules!.map((v) => v.toJson()).toList();
    }
    if (this.module_config != null) {
      data['module_config'] = this.module_config!.map((v) => v.toJson()).toList();
    }
    /*  if (this.notification != null) {
            data['notification'] = this.notification.map((v) => v.toJson()).toList();
        }*/
    if (this.prescription_module != null) {
      data['prescription_module'] = this.prescription_module!.map((v) => v.toJson()).toList();
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
  dynamic year;

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

class Specialty {
  dynamic id;
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

class PrescriptionModule {
  String? label;
  String? name;
  String? status;

  PrescriptionModule({this.label, this.name, this.status});

  factory PrescriptionModule.fromJson(Map<String, dynamic> json) {
    return PrescriptionModule(
      label: json['label'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}

class Clinic {
  String? clinic_email;
  String? clinic_id;
  String? clinic_name;
  String? city;
  String? country;
  String? status;
  String? clinic_logo;
  String? profile_image;
  Extra? extra;

  Clinic({
    this.clinic_email,
    this.clinic_id,
    this.clinic_name,
    this.extra,
    this.city,
    this.country,
    this.status,
    this.clinic_logo,
    this.profile_image,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinic_email: json['clinic_email'],
      clinic_id: json['clinic_id'],
      clinic_name: json['clinic_name'],
      city: json['city'],
      country: json['country'],
      status: json['status'],
      clinic_logo: json['clinic_logo'],
      profile_image: json['profile_image'],
      extra: json['extra'] != null ? Extra.fromJson(json['extra']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinic_email'] = this.clinic_email;
    data['clinic_id'] = this.clinic_id;
    data['clinic_name'] = this.clinic_name;
    data['city'] = this.city;
    data['country'] = this.country;
    data['status'] = this.status;
    data['clinic_logo'] = this.clinic_logo;
    data['profile_image'] = this.profile_image;
    if (this.extra != null) {
      data['extra'] = this.extra!.toJson();
    }
    return data;
  }
}

class Extra {
  String? currency_postfix;
  String? currency_prefix;
  DecimalPoint? decimal_point;

  Extra({this.currency_postfix, this.currency_prefix, this.decimal_point});

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      currency_postfix: json['currency_postfix'],
      currency_prefix: json['currency_prefix'],
      // decimal_point: json['decimal_point'] != null ? DecimalPoint.fromJson(json['decimal_point']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_postfix'] = this.currency_postfix;
    data['currency_prefix'] = this.currency_prefix;
    // if (this.decimal_point != null) {
    //   data['decimal_point'] = this.decimal_point!.toJson();
    // }
    return data;
  }
}

class DecimalPoint {
  int? id;
  String? label;

  DecimalPoint({this.id, this.label});

  DecimalPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class ModuleConfig {
  String? label;
  String? name;
  String? status;

  ModuleConfig({this.label, this.name, this.status});

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    return ModuleConfig(
      label: json['label'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}

class EnocunterModule {
  String? label;
  String? name;
  String? status;

  EnocunterModule({this.label, this.name, this.status});

  factory EnocunterModule.fromJson(Map<String, dynamic> json) {
    return EnocunterModule(
      label: json['label'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
