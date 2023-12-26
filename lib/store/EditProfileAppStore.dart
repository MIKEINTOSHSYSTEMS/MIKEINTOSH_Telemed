import 'package:mobx/mobx.dart';

part 'EditProfileAppStore.g.dart';

class EditProfileAppStore = EditProfileAppStoreBase with _$EditProfileAppStore;

abstract class EditProfileAppStoreBase with Store {
  @observable
  ObservableMap<String, dynamic> editProfile = ObservableMap<String, dynamic>();

  @action
  void addData(Map<String, dynamic> data, {bool? isClear}) {
    if (isClear ?? false) {
      editProfile.clear();
    }
    editProfile.addAll(data);
  }

  @action
  void removeData() {
    editProfile.clear();
  }
}
