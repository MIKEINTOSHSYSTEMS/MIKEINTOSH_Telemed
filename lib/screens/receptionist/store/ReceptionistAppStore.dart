import 'package:mobx/mobx.dart';

part 'ReceptionistAppStore.g.dart';

class ReceptionistAppStore = ReceptionistAppStoreBase with _$ReceptionistAppStore;

abstract class ReceptionistAppStoreBase with Store {
  @observable
  int bottomNavIndex = 0;

  @action
  void setBottomNavIndex(int index) {
    bottomNavIndex = index;
  }
}
