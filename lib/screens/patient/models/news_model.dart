import 'package:momona_healthcare/utils/common.dart';

class NewsModel {
  List<NewsData>? newsData;
  String? total;

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
  String? human_time_diff;
  int? iD;
  String? image;
  String? no_of_comments;
  String? post_author_name;
  String? post_content;
  String? post_date;
  String? post_date_gmt;
  String? post_excerpt;
  String? post_title;
  String? readable_date;
  String? share_url;

  NewsData({this.human_time_diff, this.iD, this.image, this.no_of_comments, this.post_author_name, this.post_content, this.post_date, this.post_date_gmt, this.post_excerpt, this.post_title, this.readable_date, this.share_url});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      human_time_diff: json['human_time_diff'],
      iD: json['iD'],
      image: json['image'],
      no_of_comments: json['no_of_comments'],
      post_author_name: json['post_author_name'],
      post_content: json['post_content'],
      post_date: json['post_date'],
      post_date_gmt: json['post_date_gmt'],
      post_excerpt: json['post_excerpt'],
      post_title: parseHtmlString(json['post_title']),
      readable_date: json['readable_date'],
      share_url: json['share_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['human_time_diff'] = this.human_time_diff;
    data['iD'] = this.iD;
    data['image'] = this.image;
    data['no_of_comments'] = this.no_of_comments;
    data['post_author_name'] = this.post_author_name;
    data['post_content'] = this.post_content;
    data['post_date'] = this.post_date;
    data['post_date_gmt'] = this.post_date_gmt;
    data['post_excerpt'] = this.post_excerpt;
    data['post_title'] = this.post_title;
    data['readable_date'] = this.readable_date;
    data['share_url'] = this.share_url;
    return data;
  }
}
