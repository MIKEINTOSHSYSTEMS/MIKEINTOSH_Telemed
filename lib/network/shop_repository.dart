import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/cart_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/category_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/country_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/coupon_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/customer_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/order_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/order_notes_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/payment_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/product_detail_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/product_list_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/product_review_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<ProductListModel>> getProductsList({
  int page = 1,
  int? categoryId,
  String? orderBy,
  String? searchString,
  required List<ProductListModel> productList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  if (categoryId != null) params.add('category=$categoryId');
  if (searchString.validate().isNotEmpty) params.add('search=$searchString');
  if (orderBy.validate().isNotEmpty) params.add('orderby=$orderBy');
  params.add('page=$page&per_page=$PER_PAGE');

  if (!appStore.isConnectedToInternet) {
    return [];
  }

  Iterable it = await handleResponse(await buildHttpResponse(
    getEndPoint(endPoint: ApiEndPoints.productsList, params: params),
    requiredToken: false,
    isOauth: true,
  ));

  if (page == 1) productList.clear();

  productList.addAll(it.validate().map((e) => ProductListModel.fromJson(e)));

  lastPageCallback?.call(productList.validate().length != PER_PAGE);

  return productList;
}

Future<ProductDetailModel> getProductDetail({required int productId}) async {
  return ProductDetailModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.productDetailEndPoint}/$productId',
    isOauth: true,
    requiredToken: false,
  )));
}

Future<RelatedProductModel> getRelatedProduct({required int productId}) async {
  return RelatedProductModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.productDetailEndPoint}/$productId',
    isOauth: true,
    requiredToken: false,
  )));
}

Future<List<ProductReviewModel>> getProductReviews({required int productId}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.productReviews}?product=$productId',
    isOauth: true,
    requiredToken: false,
  ));

  return it.map((e) => ProductReviewModel.fromJson(e)).toList();
}

Future<ProductReviewModel> addProductReview({required Map request}) async {
  return ProductReviewModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.productReviews}',
    request: request,
    method: HttpMethod.POST,
    isOauth: true,
    requiredToken: false,
  )));
}

Future<ProductReviewModel> updateProductReview({required Map request, required int reviewId}) async {
  return ProductReviewModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.productReviews}/$reviewId',
    request: request,
    method: HttpMethod.POST,
    isOauth: true,
    requiredToken: false,
  )));
}

Future<ProductReviewModel> deleteProductReview({required int reviewId}) async {
  Map request = {"force": true};

  return ProductReviewModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.productReviews}/$reviewId',
    request: request,
    method: HttpMethod.DELETE,
    isOauth: true,
    requiredToken: false,
  )));
}

/// Cart

Future<CartModel> getCartDetails() async {
  return CartModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.cart}',
    requiredNonce: true,
  )));
}

Future<CartModel> applyCoupon({required String code}) async {
  return CartModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.applyCoupon}?code=$code',
    method: HttpMethod.POST,
    requiredNonce: true,
  )));
}

Future<CartModel> removeCoupon({required String code}) async {
  return CartModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.removeCoupon}?code=$code',
    method: HttpMethod.POST,
    requiredNonce: true,
  )));
}

Future<List<CouponModel>> getCouponsList({
  required List<CouponModel> couponList,
  Function(bool)? lastPageCallback,
  page,
}) async {
  List<String> params = [];

  params.add('page=$page&per_page=$PER_PAGE');
  if (!appStore.isConnectedToInternet) {
    return [];
  }
  Iterable it = await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.coupons}',
    headerRequired: false,
    isOauth: true,
  ));
  if (page == 1) couponList.clear();

  couponList.addAll(it.validate().map((e) => CouponModel.fromJson(e)));

  lastPageCallback?.call(couponList.validate().length != PER_PAGE);

  return couponList;
}

Future<CartModel> addItemToCart({required int productId, required int quantity}) async {
  Map request = {"id": productId, "quantity": quantity};
  return CartModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.addCartItems}',
    method: HttpMethod.POST,
    request: request,
    requiredNonce: true,
  )));
}

Future<CartModel> updateCartItem({required String productKey, required int quantity}) async {
  Map request = {"key": productKey, "quantity": quantity};

  return CartModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.updateCartItems}',
    method: HttpMethod.POST,
    request: request,
    requiredNonce: true,
  )));
}

Future<CartModel> removeCartItem({required String productKey}) async {
  Map request = {"key": productKey};

  return CartModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.removeCartItems}',
    method: HttpMethod.POST,
    request: request,
    requiredNonce: true,
  )));
}

Future<List<PaymentModel>> getPaymentMethods() async {
  Iterable it = await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.getPaymentMethods}',
    headerRequired: false,
    isOauth: true,
  ));

  return it.map((e) => PaymentModel.fromJson(e)).toList();
}

Future<List<CategoryModel>> getCategoryList() async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }
  Iterable it = await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.categories}',
    isOauth: true,
    requiredToken: false,
  ));

  return it.map((e) => CategoryModel.fromJson(e)).toList();
}

Future<List<OrderModel>> getOrderList({
  int page = 1,
  String? status,
  required List<OrderModel> orderList,
  Function(bool)? lastPageCallback,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }
  List<String> params = [];
  params.add('customer=${userStore.userId}');
  params.add('status=$status');

  params.add('page=$page&per_page=$PER_PAGE');

  Iterable it = await handleResponse(await buildHttpResponse(
    getEndPoint(endPoint: '${ApiEndPoints.orders}', params: params),
    isOauth: true,
    requiredToken: false,
  ));

  if (page == 1) orderList.clear();

  orderList.addAll(it.validate().map((e) => OrderModel.fromJson(e)));

  lastPageCallback?.call(orderList.validate().length != PER_PAGE);

  return orderList;
}

Future<OrderModel> getOrder({required int orderId}) async {
  return OrderModel.fromJson(await handleResponse(
    await buildHttpResponse(
      '${ApiEndPoints.orders}/$orderId',
      isOauth: true,
      requiredToken: false,
    ),
  ));
}

Future<OrderModel> createOrder({required Map request}) async {
  return OrderModel.fromJson(await handleResponse(
    await buildHttpResponse(
      '${ApiEndPoints.orders}',
      method: HttpMethod.POST,
      request: request,
      requiredNonce: true,
      isOauth: true,
      requiredToken: false,
    ),
  ));
}

Future<OrderNotesModel> createOrderNotes({required Map request, required int orderId}) async {
  return OrderNotesModel.fromJson(await handleResponse(
    await buildHttpResponse(
      '${ApiEndPoints.orders}/$orderId/notes',
      method: HttpMethod.POST,
      request: request,
      requiredNonce: true,
      isOauth: true,
      requiredToken: false,
    ),
  ));
}

Future<OrderModel> cancelOrder({required int orderId, required String note}) async {
  Map request = {"status": "cancelled", "customer_note": note};

  return OrderModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.orders}/$orderId',
    method: HttpMethod.POST,
    requiredNonce: true,
    isOauth: true,
    requiredToken: false,
    request: request,
  )));
}

Future<OrderModel> deleteOrder({required int orderId}) async {
  return OrderModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.orders}/$orderId',
    method: HttpMethod.DELETE,
    requiredNonce: true,
    isOauth: true,
    requiredToken: false,
  )));
}

Future<CustomerModel> getCustomer() async {
  return CustomerModel.fromJson(await handleResponse(await buildHttpResponse(
    '${ApiEndPoints.customers}/${userStore.userId}',
    isOauth: true,
    requiredToken: false,
  )));
}

Future<CustomerModel> updateCustomer({required Map request}) async {
  return CustomerModel.fromJson(await handleResponse(
    await buildHttpResponse(
      '${ApiEndPoints.customers}/${userStore.userId}',
      method: HttpMethod.POST,
      request: request,
      requiredNonce: true,
      isOauth: true,
      requiredToken: false,
    ),
  ));
}

Future<List<CountryModel>> getCountries({String? status}) async {
  Iterable it = await handleResponse(await buildHttpResponse(
    ApiEndPoints.countries,
    isOauth: true,
    requiredToken: false,
  ));

  return it.map((e) => CountryModel.fromJson(e)).toList();
}
