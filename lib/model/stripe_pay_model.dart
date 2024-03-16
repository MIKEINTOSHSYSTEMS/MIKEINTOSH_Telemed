class StripePayModel {
  String? object;
  int? amount;
  int? amountCapturable;
  int? amountReceived;
  String? application;
  String? applicationFeeAmount;
  String? canceledAt;
  String? cancellationReason;
  String? captureMethod;
  Charges? charges;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  String? customer;
  String? description;
  String? id;
  String? invoice;
  String? lastPaymentError;
  bool? livemode;
  String? nextAction;
  String? onBehalfOf;
  String? paymentMethod;
  PaymentMethodOptions? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  String? receiptEmail;
  String? review;
  String? setupFutureUsage;
  String? shipping;
  String? source;
  String? statementDescriptor;
  String? statementDescriptorSuffix;
  String? status;
  String? transferData;
  String? transferGroup;

  StripePayModel({
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.charges,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.id,
    this.invoice,
    this.lastPaymentError,
    this.livemode,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  factory StripePayModel.fromJson(Map<String, dynamic> json) {
    return StripePayModel(
      object: json['object'],
      amount: json['amount'],
      amountCapturable: json['amount_capturable'],
      amountReceived: json['amount_received'],
      application: json['application'],
      applicationFeeAmount: json['application_fee_amount'],
      canceledAt: json['canceled_at'],
      cancellationReason: json['cancellation_reason'],
      captureMethod: json['capture_method'],
      charges: json['charges'] != null ? Charges.fromJson(json['charges']) : null,
      clientSecret: json['client_secret'],
      confirmationMethod: json['confirmation_method'],
      created: json['created'],
      currency: json['currency'],
      customer: json['customer'],
      description: json['description'],
      id: json['id'],
      invoice: json['invoice'],
      lastPaymentError: json['last_payment_error'],
      livemode: json['livemode'],
      nextAction: json['next_action'],
      onBehalfOf: json['on_behalf_of'],
      paymentMethod: json['payment_method'],
      paymentMethodOptions: json['payment_method_options'] != null ? PaymentMethodOptions.fromJson(json['payment_method_options']) : null,
      paymentMethodTypes: json['payment_method_types'] != null ? new List<String>.from(json['payment_method_types']) : null,
      receiptEmail: json['receipt_email'],
      review: json['review'],
      setupFutureUsage: json['setup_future_usage'],
      shipping: json['shipping'],
      source: json['source'],
      statementDescriptor: json['statement_descriptor'],
      statementDescriptorSuffix: json['statement_descriptor_suffix'],
      status: json['status'],
      transferData: json['transfer_data'],
      transferGroup: json['transfer_group'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['`object`'] = this.object;
    data['amount'] = this.amount;
    data['amount_capturable'] = this.amountCapturable;
    data['amount_received'] = this.amountReceived;
    data['application'] = this.application;
    data['application_fee_amount'] = this.applicationFeeAmount;
    data['canceled_at'] = this.canceledAt;
    data['cancellation_reason'] = this.cancellationReason;
    data['capture_method'] = this.captureMethod;
    data['client_secret'] = this.clientSecret;
    data['confirmation_method'] = this.confirmationMethod;
    data['created'] = this.created;
    data['currency'] = this.currency;
    data['customer'] = this.customer;
    data['description'] = this.description;
    data['id'] = this.id;
    data['invoice'] = this.invoice;
    data['last_payment_error'] = this.lastPaymentError;
    data['livemode'] = this.livemode;
    data['next_action'] = this.nextAction;
    data['on_behalf_of'] = this.onBehalfOf;
    data['payment_method'] = this.paymentMethod;
    data['receipt_email'] = this.receiptEmail;
    data['review'] = this.review;
    data['setup_future_usage'] = this.setupFutureUsage;
    data['shipping'] = this.shipping;
    data['source'] = this.source;
    data['statement_descriptor'] = this.statementDescriptor;
    data['statement_descriptor_suffix'] = this.statementDescriptorSuffix;
    data['status'] = this.status;
    data['transfer_data'] = this.transferData;
    data['transfer_group'] = this.transferGroup;
    if (this.charges != null) {
      data['charges'] = this.charges!.toJson();
    }
    if (this.paymentMethodOptions != null) {
      data['payment_method_options'] = this.paymentMethodOptions!.toJson();
    }
    if (this.paymentMethodTypes != null) {
      data['payment_method_types'] = this.paymentMethodTypes;
    }
    return data;
  }
}

class PaymentMethodOptions {
  Card? card;

  PaymentMethodOptions({this.card});

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) {
    return PaymentMethodOptions(
      card: json['card'] != null ? Card.fromJson(json['card']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.card != null) {
      data['card'] = this.card!.toJson();
    }
    return data;
  }
}

class Card {
  String? installments;
  String? network;
  String? requestThreeDSecure;

  Card({this.installments, this.network, this.requestThreeDSecure});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      installments: json['installments'],
      network: json['network'],
      requestThreeDSecure: json['request_three_d_secure'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['installments'] = this.installments;
    data['network'] = this.network;
    data['request_three_d_secure'] = this.requestThreeDSecure;
    return data;
  }
}

class Charges {
  String? object;
  bool? hasMore;
  int? totalCount;
  String? url;

  Charges({this.object, this.hasMore, this.totalCount, this.url});

  factory Charges.fromJson(Map<String, dynamic> json) {
    return Charges(
      object: json['object'],
      hasMore: json['has_more'],
      totalCount: json['total_count'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['`object`'] = this.object;
    data['has_more'] = this.hasMore;
    data['total_count'] = this.totalCount;
    data['url'] = this.url;
    return data;
  }
}
