import 'package:momona_healthcare/model/user_model.dart';
import 'package:mobx/mobx.dart';

part 'ListAppStore.g.dart';

class ListAppStore = ListAppStoreBase with _$ListAppStore;

abstract class ListAppStoreBase with Store {
  var doctorList = ObservableList<UserModel?>();

  @action
  void addDoctor(List<UserModel> data, {bool isClear = true}) {
    if (isClear) {
      doctorList.clear();
    }
    doctorList.addAll(data);
  }
}
