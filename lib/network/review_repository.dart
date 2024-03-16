import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/rating_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

Future<BaseResponses> updateReviewAPI(Map<String, dynamic> request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/review/edit', request: request, method: HttpMethod.PATCH)));
}

Future<BaseResponses> addReviewAPI(Map<String, dynamic> request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/review/add', request: request, method: HttpMethod.POST)));
}

Future<BaseResponses> deleteReviewAPI({required int id}) async {
  List<String> param = [];
  param.add('review_id=$id');
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/review/delete', params: param), method: HttpMethod.DELETE)));
}

Future<List<RatingData>> doctorReviewsListAPI(
    {required int page, required List<RatingData> ratingList, Function(bool)? lastPageCallback, Function(int)? getTotalReviews, required int doctorId}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }
  appStore.setLoading(true);

  RatingResponse res =
      RatingResponse.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/review/get', page: page, params: ["doctor_id=$doctorId"]), method: HttpMethod.GET)));
  if (page == 1) ratingList.clear();
  lastPageCallback?.call(res.data.validate().length != PER_PAGE);

  appStore.setLoading(false);

  return res.data.validate();
}
