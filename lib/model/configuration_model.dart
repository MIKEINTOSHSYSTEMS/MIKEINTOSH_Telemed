import 'package:momona_healthcare/model/user_permission.dart';

class ConfigurationModel {
  String? message;
  String? status;
  num? userId;
  String? role;

  String? termsEndCondition;
  bool? isTeleMedActive;
  bool? isKiviCareProOnName;
  bool? isKiviCareGoogleMeetActive;
  String? telemedType;
  String? isUploadFileAppointment;
  RestrictAppointment? restrictAppointment;
  String? isEnableGoogleCal;
  String? isPatientEnable;
  String? googleClientId;
  String? globalDateFormat;
  String? utc;
  bool? isRazorPayOn;
  bool? isWoocommerceOn;
  PaymentMethods? paymentMethod;

  UserPermission? permissions;

  String? nonce;

  ConfigurationModel({
    this.message,
    this.status,
    this.userId,
    this.role,
    this.isTeleMedActive,
    this.isKiviCareProOnName,
    this.isKiviCareGoogleMeetActive,
    this.telemedType,
    this.isUploadFileAppointment,
    this.restrictAppointment,
    this.isEnableGoogleCal,
    this.isPatientEnable,
    this.googleClientId,
    this.globalDateFormat,
    this.utc,
    this.permissions,
    this.paymentMethod,
    this.termsEndCondition,
    this.nonce,
  });

  ConfigurationModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    userId = json['user_id'];
    role = json['role'];
    termsEndCondition = json['term_and_condition'];
    permissions = json['permissions'] != null ? UserPermission.fromJson(json['permissions']) : null;
    isRazorPayOn = json['is_RazorPay_On'];
    isWoocommerceOn = json['is_Woocommerce_On'];
    isTeleMedActive = json['isTeleMedActive'];
    isKiviCareProOnName = json['isKiviCareProOnName'];
    isKiviCareGoogleMeetActive = json['isKiviCareGooglemeetActive'];
    telemedType = json['telemed_type'];
    isUploadFileAppointment = json['is_uploadfile_appointment'];
    restrictAppointment = json['restrict_appointment'] != null ? RestrictAppointment.fromJson(json['restrict_appointment']) : null;
    isEnableGoogleCal = json['is_enable_google_cal'];
    isPatientEnable = json['is_patient_enable'];
    googleClientId = json['google_client_id'];
    globalDateFormat = json['global_date_format'];
    paymentMethod = json['payment_methods'] != null ? PaymentMethods.fromJson(json['payment_methods']) : null;
    utc = json['UTC'];
    nonce = json['wc_nounce'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['message'] = message;
    map['status'] = status;
    map['user_id'] = userId;
    map['role'] = role;

    map['term_and_condition'] = termsEndCondition;
    map['isTeleMedActive'] = isTeleMedActive;
    map['isKiviCareProOnName'] = isKiviCareProOnName;
    map['isKiviCareGooglemeetActive'] = isKiviCareGoogleMeetActive;
    map['telemed_type'] = telemedType;
    map['is_uploadfile_appointment'] = isUploadFileAppointment;
    if (restrictAppointment != null) {
      map['restrict_appointment'] = restrictAppointment!.toJson();
    }
    map['is_enable_google_cal'] = isEnableGoogleCal;
    map['is_patient_enable'] = isPatientEnable;
    map['google_client_id'] = googleClientId;
    map['global_date_format'] = globalDateFormat;
    map['c_nwounce'] = nonce;
    map['UTC'] = utc;
    if (paymentMethod != null) {
      map['payment_methods'] = paymentMethod!.toJson();
    }
    return map;
  }
}

class RestrictAppointment {
  RestrictAppointment({
    this.pre,
    this.post,
  });

  RestrictAppointment.fromJson(dynamic json) {
    pre = json['pre'];
    post = json['post'];
  }

  String? pre;
  String? post;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['pre'] = pre;
    map['post'] = post;
    return map;
  }
}

class PaymentMethods {
  String? paymentOffline;
  String? paymentWoocommerce;
  String? paymentRazorpay;

  String? paymentStripePay;

  PaymentMethods({
    this.paymentOffline,
    this.paymentRazorpay,
    this.paymentWoocommerce,
    this.paymentStripePay,
  });

  PaymentMethods.fromJson(dynamic json) {
    paymentOffline = json['paymentOffline'];
    paymentWoocommerce = json['paymentWoocommerce'];
    paymentRazorpay = json['paymentRazorpay'];
    paymentStripePay = json['paymentStripepay'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paymentOffline'] = this.paymentOffline;
    json['paymentWoocommerce'] = this.paymentWoocommerce;
    json['paymentRazorpay'] = this.paymentRazorpay;
    json['paymentStripePay'] = this.paymentStripePay;
    return json;
  }
}

class BaseResponses {
  String? message;

  BaseResponses({this.message});

  factory BaseResponses.fromJson(Map<String, dynamic> json) {
    return BaseResponses(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
