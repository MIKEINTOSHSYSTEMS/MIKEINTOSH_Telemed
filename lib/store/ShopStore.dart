import 'package:momona_healthcare/model/woo_commerce/billing_address_model.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'ShopStore.g.dart';

class ShopStore = ShopStoreBase with _$ShopStore;

abstract class ShopStoreBase with Store {
  int? itemsInCartCount = 0;

  BillingAddressModel? billingAddress;

  BillingAddressModel? shippingAddress;

  void setCartCount(int value) {
    itemsInCartCount = value;
    setValue(CartKeys.cartItemCountKey, value);
  }

  void setBillingAddress(BillingAddressModel address) {
    billingAddress = address;
    setValue(CartKeys.billingAddress, address);
  }

  void setShippingAddress(BillingAddressModel address) {
    shippingAddress = address;
    setValue(CartKeys.shippingAddress, address);
  }
}
