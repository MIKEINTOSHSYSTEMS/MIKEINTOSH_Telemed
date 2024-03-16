import 'package:mobx/mobx.dart';

part 'DoctorAppStore.g.dart';

class DoctorAppStore = DoctorAppStoreBase with _$DoctorAppStore;

abstract class DoctorAppStoreBase with Store {
  @observable
  int bottomNavIndex = 0;

  @action
  void setBottomNavIndex(int index) {
    bottomNavIndex = index;
  }
}
