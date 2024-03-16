class OrderResponseModel {
  String? id;
  String? entity;
  num? amount;
  num? amountPaid;
  num? amountDue;
  String? currency;
  String? receipt;
  String? status;
  num? attempts;

  num? createdAt;
  Error? error;

  OrderResponseModel({this.id, this.entity, this.amount, this.amountPaid, this.amountDue, this.currency, this.receipt, this.status, this.attempts, this.createdAt, this.error});

  OrderResponseModel.fromJson(dynamic json) {
    this.id = json['id'];
    this.entity = json['entity'];
    this.amount = json['amount'];
    this.amountPaid = json['amount_paid'];
    this.amountDue = json['amount_due'];
    this.currency = json['currency'];
    this.receipt = json['receipt'];
    this.status = json['status'];
    this.attempts = json['attempts'];
    this.createdAt = json['created_at'];
    this.error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['entity'] = entity;
    map['amount'] = amount;
    map['amount_paid'] = amountPaid;
    map['amount_due'] = amountDue;
    map['currency'] = currency;
    map['receipt'] = receipt;
    map['status'] = status;
    map['attempts'] = attempts;
    map['created_at'] = createdAt;
    return map;
  }
}

class ErrorModel {
  String? code;
  String? message;
  String? source;
  String? step;
  String? reason;
  MetaData? metaData;
  String? field;

  ErrorModel.fromJson(dynamic json) {
    this.code = json['code'];
    this.message = json['description'];
    this.source = json['source'];
    this.step = json['step'];
    this.reason = json['reason'];
    this.field = json['field'];
    //this.metaData = json['status'];
  }
}

class MetaData {}
