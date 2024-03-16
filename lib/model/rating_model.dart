class RatingData {
  String? createdAt;
  int? doctorId;
  String? doctorName;
  String? doctorProfileImage;
  int? id;
  int? patientId;
  String? patientName;
  String? patientProfileImage;
  int? rating;
  String? reviewDescription;
  String? updatedAt;

  RatingData({this.createdAt, this.doctorId, this.doctorName, this.doctorProfileImage, this.patientName, this.patientProfileImage, this.id, this.patientId, this.rating, this.reviewDescription, this.updatedAt});

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      createdAt: json['created_at'],
      doctorId: json['doctor_id'],
      id: json['id'],
      patientId: json['patient_id'],
      doctorName: json['doctor_name'],
      doctorProfileImage: json['doctor_profile_image'],
      patientName: json['patient_name'],
      patientProfileImage: json['patient_profile_image'],
      rating: json['review'],
      reviewDescription: json['review_description'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['doctor_id'] = this.doctorId;
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['review'] = this.rating;
    data['review_description'] = this.reviewDescription;
    data['doctor_name'] = this.doctorName;
    data['doctor_profile_image'] = this.doctorProfileImage;
    data['patient_name'] = this.patientName;
    data['patient_profile_image'] = this.patientProfileImage;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class RatingResponse {
  List<RatingData>? data;

  RatingResponse({this.data});

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
