import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:nb_utils/nb_utils.dart';

class ConfirmAppointmentResponseModel {
  String? message;
  bool? status;
  bool? isAppointmentAlreadyBooked;
  String? woocommerceRedirect;
  int? appointmentId;
  OrderData? orderData;
  UpcomingAppointmentModel? appointmentData;

  ConfirmAppointmentResponseModel({
    this.message,
    this.status,
    this.isAppointmentAlreadyBooked,
    this.appointmentId,
    this.orderData,
    this.appointmentData,
    this.woocommerceRedirect,
  });

  factory ConfirmAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return ConfirmAppointmentResponseModel(
      message: json['message'],
      status: json['status'],
      appointmentId: json['appointment_id'],
      orderData: json['checkout_detail'] != null ? OrderData.fromJson(json['checkout_detail']) : null,
      //appointmentData: json['data'] != null ? UpcomingAppointmentModel.fromJson(json['data']) : null,
      woocommerceRedirect: json['woocommerce_redirect'],
      isAppointmentAlreadyBooked: json['is_appointment_already_booked'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['appointment_id'] = this.appointmentId;
    if (orderData != null) {
      data['checkout_detail'] = orderData!.toJson();
    }
    if (appointmentData != null) {
      data['data'] = this.appointmentData;
    }
    data['woocommerce_redirect'] = this.woocommerceRedirect;
    data['is_appointment_already_booked'] = this.isAppointmentAlreadyBooked;
    return data;
  }
}

class OrderData {
  String? razorKey;
  String? razorSecretKey;

  String? stripePublishableKey;
  String? stripeSecretKey;
  String? stripeURL;

  String? currencyCode;
  String? woocommerceRedirect;
  String? receiverName;
  String? orderDescription;
  String? orderId;
  String? receipt;
  String? nonce;
  String? iconImage;
  String? themeData;
  num? amount;
  int? appointmentId;
  int? page;
  Prefill? prefillData;
  Notes? notes;

  OrderData({
    this.appointmentId,
    this.razorKey,
    this.razorSecretKey,
    this.stripePublishableKey,
    this.stripeSecretKey,
    this.stripeURL,
    this.woocommerceRedirect,
    this.currencyCode,
    this.amount,
    this.iconImage,
    this.orderId,
    this.themeData,
    this.page,
    this.notes,
    this.orderDescription,
    this.prefillData,
    this.receipt,
    this.receiverName,
    this.nonce,
  });

  bool get isTest => stripeSecretKey.validate().contains('test');

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      appointmentId: json['appointment_id'],
      razorKey: json['api_key'],
      razorSecretKey: json['secret_key'],
      stripePublishableKey: json['publishable_key'],
      stripeSecretKey: json['api_key'],
      currencyCode: json['currency'],
      receiverName: json['name'],
      orderDescription: json['description'],
      orderId: json['order_id'],
      receipt: json['receipt'],
      nonce: json['nonce'],
      themeData: json['theme'],
      amount: json['amount'],
      prefillData: json['prefill'] != null ? Prefill.fromJson(json['prefill']) : null,
      notes: json['notes'] != null ? Notes.fromJson(json['notes']) : null,
      page: json['page'],
      woocommerceRedirect: json['woocommerce_redirect'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['appointment_id'] = this.appointmentId;
    json['woocommerce_redirect'] = this.woocommerceRedirect;
    json['api_key'] = this.razorKey;
    json['secret_key'] = this.razorSecretKey;
    json['currency'] = this.currencyCode;
    json['name'] = this.receiverName;
    json['description'] = this.orderDescription;
    json['order_id'] = this.orderId;
    json['receipt'] = this.receipt;
    json['nonce'] = this.nonce;
    json['theme'] = this.themeData;
    json['amount'] = this.amount;
    json['page'] = this.page;
    if (this.prefillData != null) {
      json['prefill'] = prefillData!.toJson();
    }
    if (this.notes != null) {
      json['notes'] = notes!.toJson();
    }

    return json;
  }
}

class Prefill {
  String? name;
  String? email;
  String? contactNumber;

  Prefill({this.contactNumber, this.name, this.email});

  factory Prefill.fromJson(Map<String, dynamic> json) {
    return Prefill(
      email: json['email'],
      name: json['name'],
      contactNumber: json['contact'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    return data;
  }
}

class Notes {
  String? orderedProduct;

  Notes({this.orderedProduct});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(orderedProduct: json['order_product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['order_product'] = this.orderedProduct;
    return data;
  }
}
