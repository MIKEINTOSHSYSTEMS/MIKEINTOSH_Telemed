class TaxModel {
  num? totalAmount;
  num? totalTax;
  List<TaxData>? taxList;

  TaxModel({
    this.totalAmount,
    this.totalTax,
    this.taxList,
  });

  TaxModel.fromJson(json) {
    totalTax = json['tax_total'];
    totalAmount = json['total_amount'];
    taxList = json['data'] != null ? (json['data'] as List).map((taxData) => TaxData.fromJson(taxData)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tax_total'] = this.totalTax;
    json['total_amount'] = this.totalAmount;
    if (json['data'] != null) json['data'] = this.taxList?.map((e) => e.toJson()).toList();

    return json;
  }
}

class TaxData {
  String? id;
  String? taxName;

  String? rate;

  String? slug;
  num? taxRate;

  num? charges;
  String? taxSuffix;
  String? taxStatus;

  TaxData({
    this.id,
    this.taxName,
    this.taxRate,
    this.taxSuffix,
    this.taxStatus,
    this.charges,
    this.slug,
  });

  TaxData.fromJson(json) {
    id = json['id'];
    taxName = json['name'];
    taxRate = json['tax_value'];
    taxSuffix = json['tax_suffix'];
    taxStatus = json['status'];
    charges = json['charges'];
    slug = json['slug'];
    rate=json['rate'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['name'] = this.taxName;
    json['tax_value'] = this.taxRate;
    json['tax_suffix'] = this.taxSuffix;
    json['status'] = this.taxStatus;
    json['slug'] = this.slug;
    json['rate']=this.rate;
    return json;
  }
}

class ServiceRequestModel {
  String? serviceId;
  int? quantity;

  ServiceRequestModel({this.serviceId, this.quantity});

  ServiceRequestModel.fromJson(json) {
    serviceId = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.serviceId;
    json['quantity'] = this.quantity;
    return json;
  }
}
