import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/demo_login_model.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/common_models.dart';
import 'package:kivicare_flutter/utils/constants.dart';

List<DemoLoginModel> demoLoginList() {
  List<DemoLoginModel> demoLoginListData = [];
  demoLoginListData.add(DemoLoginModel(loginTypeImage: "images/icons/user.png"));
  demoLoginListData.add(DemoLoginModel(loginTypeImage: "images/icons/receptionistIcon.png"));
  demoLoginListData.add(DemoLoginModel(loginTypeImage: "images/icons/doctorIcon.png"));

  return demoLoginListData;
}

List<String> bloodGroupList = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
List<String> userRoleList = [UserRoleDoctor, UserRolePatient, UserRoleReceptionist];

List<WeeklyAppointment> emptyGraphListMonthly = [
  WeeklyAppointment(x: "W1", y: 0),
  WeeklyAppointment(x: "W2", y: 0),
  WeeklyAppointment(x: "W3", y: 0),
  WeeklyAppointment(x: "W4", y: 0),
  WeeklyAppointment(x: "W5", y: 0),
];

List<WeeklyAppointment> emptyGraphListYearly = [
  WeeklyAppointment(x: locale.lblJan, y: 0),
  WeeklyAppointment(x: locale.lblFeb, y: 0),
  WeeklyAppointment(x: locale.lblMar, y: 0),
  WeeklyAppointment(x: locale.lblApr, y: 0),
  WeeklyAppointment(x: locale.lblMay, y: 0),
  WeeklyAppointment(x: locale.lblJun, y: 0),
  WeeklyAppointment(x: locale.lblJul, y: 0),
  WeeklyAppointment(x: locale.lblAug, y: 0),
  WeeklyAppointment(x: locale.lblSep, y: 0),
  WeeklyAppointment(x: locale.lblOct, y: 0),
  WeeklyAppointment(x: locale.lblNov, y: 0),
  WeeklyAppointment(x: locale.lblDec, y: 0),
];

List<FilterModel> getProductFilters() {
  List<FilterModel> list = [];

  list.add(FilterModel(value: ProductFilters.date, title: locale.lblLatest));
  list.add(FilterModel(value: ProductFilters.rating, title: locale.lblAverageRating));
  list.add(FilterModel(value: ProductFilters.popularity, title: locale.lblPopularity));
  list.add(FilterModel(value: ProductFilters.price, title: locale.lblPrice));

  return list;
}
