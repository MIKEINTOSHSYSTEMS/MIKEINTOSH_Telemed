import 'package:kivicare_flutter/utils/common.dart';

class NewsModel {
  List<NewsData>? newsData;
  num? total;

  NewsModel({this.newsData, this.total});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      newsData: json['data'] != null ? (json['data'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.newsData != null) {
      data['data'] = this.newsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewsData {
  String? humanTimeDiff;
  int? iD;
  String? image;
  String? noOfComments;
  String? postAuthorName;
  String? postContent;
  String? postDate;
  String? postDateGmt;
  String? postExcerpt;
  String? postTitle;
  String? readableDate;
  String? shareUrl;

  NewsData(
      {this.humanTimeDiff,
      this.iD,
      this.image,
      this.noOfComments,
      this.postAuthorName,
      this.postContent,
      this.postDate,
      this.postDateGmt,
      this.postExcerpt,
      this.postTitle,
      this.readableDate,
      this.shareUrl});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      humanTimeDiff: json['human_time_diff'],
      iD: json['ID'],
      image: json['image'],
      noOfComments: json['no_of_comments'],
      postAuthorName: json['post_author_name'],
      postContent: json['post_content'],
      postDate: json['post_date'],
      postDateGmt: json['post_date_gmt'],
      postExcerpt: json['post_excerpt'],
      postTitle: parseHtmlString(json['post_title']),
      readableDate: json['readable_date'],
      shareUrl: json['share_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['human_time_diff'] = this.humanTimeDiff;
    data['ID'] = this.iD;
    data['image'] = this.image;
    data['no_of_comments'] = this.noOfComments;
    data['post_author_name'] = this.postAuthorName;
    data['post_content'] = this.postContent;
    data['post_date'] = this.postDate;
    data['post_date_gmt'] = this.postDateGmt;
    data['post_excerpt'] = this.postExcerpt;
    data['post_title'] = this.postTitle;
    data['readable_date'] = this.readableDate;
    data['share_url'] = this.shareUrl;
    return data;
  }
}
