import 'dart:io';

import 'package:kivicare_flutter/model/prescription_module.dart';
import 'package:kivicare_flutter/model/qualification_model.dart';
import 'package:kivicare_flutter/model/rating_model.dart';
import 'package:kivicare_flutter/model/restrict_appointment_model.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/model/speciality_model.dart';
import 'package:nb_utils/nb_utils.dart';

import 'clinic_list_model.dart';
import 'encounter_module.dart';
import 'module_config_model.dart';

class UserModel {
  String? address;
  String? apiKey;
  String? apiSecret;
  String? city;
  List<Clinic>? clinic;
  String? country;

  String? dob;
  String? apiResponseMessage;

  List<EncounterModule>? encounterModules;
  String? firstName;
  String? gender;

  String? isPatientEnable;
  String? lastName;
  String? mobileNumber;
  List<ModuleConfig>? moduleConfig;

  String? noOfExperience;

  String? doctorId;

  List<Object>? notification;
  String? postalCode;
  List<PrescriptionModule>? prescriptionModule;
  String? price;
  String? priceType;
  String? profileImage;
  List<Qualification>? qualifications;
  String? role;
  List<SpecialtyModel>? specialties;
  String? token;
  String? doctorName;
  String? userDisplayName;
  String? userEmail;
  int? userId;
  String? userNiceName;
  String? zoomId;
  String? signatureImg;
  String? state;
  String? timeSlot;
  String? userLogin;
  String? bloodGroup;

  //new

  String? isUploadFileAppointment;
  String? message;
  String? globalDateFormat;
  RestrictAppointmentModel? restrictAppointment;

  //New
  String? available;
  String? clinicId;

  String? clinicName;
  String? displayName;
  int? iD;
  num? avgRating;
  String? userStatus;
  bool isCheck;
  List<RatingData>? ratingList;

  String? patientAddedBy;
  String? totalEncounter;
  String? userRegistered;

  String? charges;

  String? duration;

  String? serviceImage;
  String? mappingTableId;
  bool? multiple;

  String? status;
  bool? isTelemed;
  ServiceData? serviceData;

  File? imageFile;
  String? utc;

  String? serviceId;

  UserModel({
    this.address,
    this.apiKey,
    this.apiSecret,
    this.city,
    this.clinic,
    this.clinicId,
    this.country,
    this.dob,
    this.imageFile,
    this.doctorName,
    this.encounterModules,
    this.firstName,
    this.apiResponseMessage,
    this.gender,
    this.isPatientEnable,
    this.lastName,
    this.mobileNumber,
    this.moduleConfig,
    this.noOfExperience,
    this.notification,
    this.postalCode,
    this.prescriptionModule,
    this.price,
    this.priceType,
    this.profileImage,
    this.qualifications,
    this.role,
    this.specialties,
    this.token,
    this.userDisplayName,
    this.userEmail,
    this.userId,
    this.userNiceName,
    this.zoomId,
    this.utc,
    this.signatureImg,
    this.userLogin,
    this.bloodGroup,
    this.timeSlot,
    this.state,
    this.isUploadFileAppointment,
    this.restrictAppointment,
    this.message,
    this.globalDateFormat,
    this.available,
    this.clinicName,
    this.displayName,
    this.avgRating,
    this.ratingList,
    this.iD,
    this.serviceId,
    this.userStatus,
    this.patientAddedBy,
    this.totalEncounter,
    this.userRegistered,
    this.doctorId,
    this.isCheck = false,
    this.charges,
    this.duration,
    this.serviceImage,
    this.mappingTableId,
    this.multiple,
    this.status,
    this.isTelemed,
    this.serviceData,
  });

  String get getDoctorSpeciality => specialties.validate().map((e) => e.label.validate()).join(', ');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      address: json['address'],
      apiKey: json['api_key'],
      apiSecret: json['api_secret'],
      patientAddedBy: json['patient_added_by'],
      totalEncounter: json['total_encounter'],
      userRegistered: json['user_registered'],
      city: json['city'],
      apiResponseMessage: json['message'],
      clinic: json['clinic'] != null ? (json['clinic'] as List).map((i) => Clinic.fromJson(i)).toList() : null,
      country: json['country'],
      dob: json['dob'],
      encounterModules: json['enocunter_modules'] != null ? (json['enocunter_modules'] as List).map((i) => EncounterModule.fromJson(i)).toList() : null,
      firstName: json['first_name'] != null ? json['first_name'] : json['display_name'].toString().split(' ').first,
      gender: json['gender'],
      utc: json['UTC'],
      isPatientEnable: json['is_patient_enable'],
      lastName: json['last_name'] != null ? json['last_name'] : json['display_name'].toString().split(' ').last,
      mobileNumber: json['mobile_number'],
      moduleConfig: json['module_config'] != null ? (json['module_config'] as List).map((i) => ModuleConfig.fromJson(i)).toList() : null,
      noOfExperience: json['no_of_experience'],
      postalCode: json['postal_code'],
      prescriptionModule: json['prescription_module'] != null ? (json['prescription_module'] as List).map((i) => PrescriptionModule.fromJson(i)).toList() : null,
      price: json['price'],
      priceType: json['price_type'],
      profileImage: json['profile_image'],
      qualifications: json['qualifications'] != null ? (json['qualifications'] as List).map((i) => Qualification.fromJson(i)).toList() : null,
      role: json['role'],
      specialties: json['specialties'] != null
          ? (json['specialities'].runtimeType == String
              ? (json['specialties']).split(',').map((e) => SpecialtyModel(label: e)).toList()
              : (json['specialties'] as List).map((e) => SpecialtyModel.fromJson(e)).toList())
          : json['specialties'],
      token: json['token'],
      userDisplayName: json['display_name'],
      userEmail: json['user_email'],
      userId: json['user_id'].runtimeType == String ? (json['user_id'] as String).toInt() : json['user_id'],
      doctorId: json['doctor_id'],
      doctorName: json['doctor_name'],
      userNiceName: json['user_nicename'],
      zoomId: json['zoom_id'],
      signatureImg: json['signature_img'],
      state: json['state'],
      timeSlot: json['time_slot'],
      userLogin: json['user_login'],
      bloodGroup: json['blood_group'],
      globalDateFormat: json['global_date_format'],
      isUploadFileAppointment: json['is_uploadfile_appointment'],
      message: json['message'],
      restrictAppointment: json['restrict_appointment'] != null ? RestrictAppointmentModel.fromJson(json['restrict_appointment']) : null,
      available: json['available'],
      avgRating: json['avgRating'],
      clinicName: json['clinic_name'],
      displayName: json['display_name'],
      iD: json['ID'],
      ratingList: json['review'] != null
          ? (json['review'] as List).map((i) => RatingData.fromJson(i)).toList()
          : json['reviews'] != null
              ? (json['reviews'] as List).map((i) => RatingData.fromJson(i)).toList()
              : null,
      userStatus: json['user_status'],
      charges: json['charges'],
      serviceId: json['service_id'],
      duration: json['duration'],
      serviceImage: json['image'],
      isTelemed: json['is_telemed'],
      mappingTableId: json['mapping_table_id'],
      multiple: json['is_multiple_selection'],
      status: json['status'].runtimeType == int ? (json['status'] as int).toString() : json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.clinicId != null) {
      data['clinic_Id'] = this.clinicId;
    }

    data['address'] = this.address;
    data['api_key'] = this.apiKey;
    data['api_secret'] = this.apiSecret;
    data['city'] = this.city;
    data['country'] = this.country;
    data['dob'] = this.dob;
    data['first_name'] = this.firstName;
    data['gender'] = this.gender;
    data['doctor_name'] = this.doctorName;
    data['UTC'] = this.utc;
    data['is_patient_enable'] = this.isPatientEnable;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['no_of_experience'] = this.noOfExperience;
    data['postal_code'] = this.postalCode;
    data['price'] = this.price;
    data['patient_added_by'] = this.patientAddedBy;
    data['total_encounter'] = this.totalEncounter;
    data['user_registered'] = this.userRegistered;
    data['price_type'] = this.priceType;
    data['profile_image'] = this.profileImage;
    data['role'] = this.role;
    data['token'] = this.token;
    data['user_display_name'] = this.userDisplayName;
    data['user_email'] = this.userEmail;
    data['user_id'] = this.userId;
    data['user_nicename'] = this.userNiceName;
    data['zoom_id'] = this.zoomId;

    data['charges'] = this.charges;
    data['doctor_id'] = this.doctorId;
    data['duration'] = this.duration;
    data['service_id'] = this.serviceId;

    data['image'] = this.serviceImage;
    data['mapping_table_id'] = this.mappingTableId;
    data['is_multiple_selection'] = this.multiple;

    data['status'] = this.status;
    data['is_telemed'] = this.isTelemed;

    if (this.clinic != null) {
      data['clinic'] = this.clinic!.map((v) => v.toJson()).toList();
    }

    if (this.encounterModules != null) {
      data['enocunter_modules'] = this.encounterModules!.map((v) => v.toJson()).toList();
    }
    if (this.moduleConfig != null) {
      data['module_config'] = this.moduleConfig!.map((v) => v.toJson()).toList();
    }

    if (this.prescriptionModule != null) {
      data['prescription_module'] = this.prescriptionModule!.map((v) => v.toJson()).toList();
    }
    if (this.qualifications != null) {
      data['qualifications'] = this.qualifications!.map((v) => v.toJson()).toList();
    }
    if (this.specialties != null) {
      data['specialties'] = this.specialties!.map((v) => v.toJson()).toList();
    }
    data['signature_img'] = this.signatureImg;
    data['user_login'] = this.userLogin;
    data['state'] = this.state;
    data['time_slot'] = this.timeSlot;

    data['blood_group'] = this.bloodGroup;

    data['global_date_format'] = this.globalDateFormat;
    data['is_uploadfile_appointment'] = this.isUploadFileAppointment;
    data['message'] = this.message;
    data['doctor_id'] = this.doctorId;

    return data;
  }
}
