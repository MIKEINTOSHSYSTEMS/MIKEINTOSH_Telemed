import 'package:mobx/mobx.dart';

part 'patient_store.g.dart';

class PatientStore = PatientStoreBase with _$PatientStore;

abstract class PatientStoreBase with Store {
  @observable
  int bottomNavIndex = 0;

  @action
  void setBottomNavIndex(int index) {
    bottomNavIndex = index;
  }
}
