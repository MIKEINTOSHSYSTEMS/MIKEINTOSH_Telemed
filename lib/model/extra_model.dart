import 'decimal_point_model.dart';

class Extra {
  String? currencyPostfix;
  String? currencyPrefix;
  DecimalPoint? decimalPoint;

  Extra({this.currencyPostfix, this.currencyPrefix, this.decimalPoint});

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      currencyPostfix: json['currency_postfix'],
      currencyPrefix: json['currency_prefix'],
      // decimal_point: json['decimal_point'] != null ? DecimalPoint.fromJson(json['decimal_point']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_postfix'] = this.currencyPostfix;
    data['currency_prefix'] = this.currencyPrefix;
    // if (this.decimal_point != null) {
    //   data['decimal_point'] = this.decimal_point!.toJson();
    // }
    return data;
  }
}
