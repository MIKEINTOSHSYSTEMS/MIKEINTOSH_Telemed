class DurationModel {
  String? label;
  int? value;

  DurationModel({this.value, this.label});
}

List<DurationModel> getServiceDuration() {
  List<DurationModel> durationList = [];

  durationList.add(DurationModel(value: 5, label: '5 min'));
  durationList.add(DurationModel(value: 10, label: '10 min'));
  durationList.add(DurationModel(value: 15, label: '15 min'));
  durationList.add(DurationModel(value: 20, label: '20 min'));
  durationList.add(DurationModel(value: 25, label: '25 min'));
  durationList.add(DurationModel(value: 30, label: '30 min'));
  durationList.add(DurationModel(value: 35, label: '35 min'));
  durationList.add(DurationModel(value: 40, label: '40 min'));
  durationList.add(DurationModel(value: 45, label: '45 min'));
  durationList.add(DurationModel(value: 50, label: '50 min'));
  durationList.add(DurationModel(value: 55, label: '55 min'));
  durationList.add(DurationModel(value: 60, label: '1 hr'));
  durationList.add(DurationModel(value: 75, label: '1hr 15 min'));
  durationList.add(DurationModel(value: 90, label: '1hr 30 min'));
  durationList.add(DurationModel(value: 105, label: '1hr 45 min'));
  durationList.add(DurationModel(value: 120, label: '2hr'));
  durationList.add(DurationModel(value: 150, label: '2hr 30min'));

  return durationList;
}
