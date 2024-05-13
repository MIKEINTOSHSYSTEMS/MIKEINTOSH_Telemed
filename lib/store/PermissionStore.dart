import 'package:kivicare_flutter/model/user_permission.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'PermissionStore.g.dart';

class PermissionStore = PermissionStoreBase with _$PermissionStore;

abstract class PermissionStoreBase with Store {
  @observable
  bool isPermissionSettings = false;
  @observable
  UserPermission? userPermission;

  @observable
  AppointmentModule appointmentPermission = AppointmentModule(
    kiviCareAppointmentAdd: true,
    kiviCareAppointmentDelete: true,
    kiviCareAppointmentEdit: true,
    kiviCareAppointmentList: true,
    kiviCareAppointmentView: true,
    kiviCarePatientAppointmentStatusChange: isPatient() ? false : true,
    kiviCareAppointmentExport: true,
  );

  @observable
  BillingModule billingPermission = BillingModule(
      kiviCarePatientBillAdd: isPatient() ? false : true,
      kiviCarePatientBillDelete: isPatient() ? false : true,
      kiviCarePatientBillEdit: isPatient() ? false : true,
      kiviCarePatientBillList: true,
      kiviCarePatientBillExport: true,
      kiviCarePatientBillView: true);

  @observable
  ClinicModule clinicPermission = ClinicModule(
    kiviCareClinicAdd: isDoctor() ? true : false,
    kiviCareClinicDelete: true,
    kiviCareClinicEdit: true,
    kiviCareClinicList: true,
    kiviCareClinicProfile: true,
    kiviCareClinicView: true,
  );

  @observable
  ClinicalDetailModule clinicDetailPermission = ClinicalDetailModule(
    kiviCareMedicalRecordsAdd: isPatient() ? false : true,
    kiviCareMedicalRecordsDelete: isPatient() ? false : true,
    kiviCareMedicalRecordsEdit: isPatient() ? false : true,
    kiviCareMedicalRecordsList: true,
    kiviCareMedicalRecordsView: true,
  );

  @observable
  DashboardModule dashboardPermission = DashboardModule(
    kiviCareDashboardTotalAppointment: true,
    kiviCareDashboardTotalDoctor: true,
    kiviCareDashboardTotalPatient: true,
    kiviCareDashboardTotalRevenue: true,
    kiviCareDashboardTotalTodayAppointment: true,
    kiviCareDashboardTotalService: true,
  );

  @observable
  DoctorModule doctorPermission = DoctorModule(
    kiviCareDoctorAdd: isReceptionist() ? true : false,
    kiviCareDoctorDelete: isReceptionist() ? true : false,
    kiviCareDoctorEdit: isPatient() ? false : true,
    kiviCareDoctorDashboard: true,
    kiviCareDoctorList: true,
    kiviCareDoctorView: true,
    kiviCareDoctorExport: true,
  );

  @observable
  EncounterPermissionModule encounterPermission = EncounterPermissionModule(
    kiviCarePatientEncounterAdd: isPatient() ? false : true,
    kiviCarePatientEncounterDelete: isPatient() ? false : true,
    kiviCarePatientEncounterEdit: isPatient() ? false : true,
    kiviCarePatientEncounterExport: true,
    kiviCarePatientEncounterList: true,
    kiviCarePatientEncounters: true,
    kiviCarePatientEncounterView: true,
  );

  @observable
  EncountersTemplateModule encountersTemplatePermission = EncountersTemplateModule(
    kiviCareEncountersTemplateAdd: true,
    kiviCareEncountersTemplateDelete: true,
    kiviCareEncountersTemplateEdit: true,
    kiviCareEncountersTemplateList: true,
    kiviCareEncountersTemplateView: true,
  );

  @observable
  HolidayModule holidayPermission = HolidayModule(
    kiviCareClinicSchedule: true,
    kiviCareClinicScheduleAdd: true,
    kiviCareClinicScheduleDelete: true,
    kiviCareClinicScheduleEdit: true,
    kiviCareClinicScheduleExport: true,
  );

  SessionModule sessionPermission = SessionModule(
    kiviCareDoctorSessionAdd: isPatient() ? false : true,
    kiviCareDoctorSessionEdit: isPatient() ? false : true,
    kiviCareDoctorSessionList: isPatient() ? false : true,
    kiviCareDoctorSessionDelete: isDoctor() ? true : false,
    kiviCareDoctorSessionExport: true,
  );
  @observable
  OtherModule otherPermission = OtherModule(
    kiviCareChangePassword: true,
    kiviCarePatientReviewAdd: isPatient() ? true : false,
    kiviCarePatientReviewDelete: isPatient() ? true : false,
    kiviCarePatientReviewEdit: isPatient() ? true : false,
    kiviCarePatientReviewGet: true,
    kiviCareDashboard: true,
  );

  @observable
  PatientModule patientPermission = PatientModule(
    kiviCarePatientAdd: isPatient() ? false : true,
    kiviCarePatientDelete: isPatient() ? false : true,
    kiviCarePatientClinic: isPatient() ? true : false,
    kiviCarePatientProfile: true,
    kiviCarePatientEdit: true,
    kiviCarePatientList: true,
    kiviCarePatientExport: true,
    kiviCarePatientView: true,
  );

  ReceptionistModule receptionistPermission = ReceptionistModule(kiviCareReceptionistProfile: true);
  @observable
  ReportModule reportPermission = ReportModule(
    kiviCarePatientReport: true,
    kiviCarePatientReportAdd: true,
    kiviCarePatientReportEdit: true,
    kiviCarePatientReportView: true,
    kiviCarePatientReportDelete: isPatient() ? false : true,
  );

  @observable
  PrescriptionPermissionModule prescriptionPermission = PrescriptionPermissionModule(
    kiviCarePrescriptionAdd: isPatient() ? false : true,
    kiviCarePrescriptionDelete: isPatient() ? false : true,
    kiviCarePrescriptionEdit: isPatient() ? false : true,
    kiviCarePrescriptionView: true,
    kiviCarePrescriptionList: true,
    kiviCarePrescriptionExport: true,
  );

  @observable
  ServiceModule servicePermission = ServiceModule(
    kiviCareServiceAdd: isPatient() ? false : true,
    kiviCareServiceDelete: isPatient() ? false : true,
    kiviCareServiceEdit: isPatient() ? false : true,
    kiviCareServiceExport: true,
    kiviCareServiceList: true,
    kiviCareServiceView: true,
  );

  @observable
  StaticDataModule staticDataPermission = StaticDataModule(
    kiviCareStaticDataAdd: isPatient() ? false : true,
    kiviCareStaticDataDelete: isPatient() ? false : true,
    kiviCareStaticDataEdit: isPatient() ? false : true,
    kiviCareStaticDataExport: true,
    kiviCareStaticDataList: true,
    kiviCareStaticDataView: true,
  );

  void setPermissionSettings(bool isAllowed) {
    isPermissionSettings = isAllowed;
  }

  void setUserPermission(UserPermission? permission) {
    if (permission != null)
      userPermission = permission;
    else
      userPermission = UserPermission(
        appointmentModule: appointmentPermission,
        billingModule: billingPermission,
        clinicModule: clinicPermission,
        clinicalDetailModule: clinicDetailPermission,
        dashboardModule: dashboardPermission,
        doctorModule: doctorPermission,
        encounterModule: encounterPermission,
        encountersTemplateModule: encountersTemplatePermission,
        holidayModule: holidayPermission,
        otherModule: otherPermission,
        patientModule: patientPermission,
        patientReportModule: reportPermission,
        prescriptionModule: prescriptionPermission,
        receptionistModule: receptionistPermission,
        serviceModule: servicePermission,
        sessionModule: sessionPermission,
        staticDataModule: staticDataPermission,
      );
    setValue(USER_PERMISSION, permission?.toJson());
  }

  void setAppointmentModulePermission(AppointmentModule? appointmentModulePermission) {
    if (appointmentModulePermission != null) {
      appointmentPermission = appointmentModulePermission;
    }
    setValue(SharedPreferenceKey.kiviCareAppointmentAddKey, appointmentPermission.kiviCareAppointmentAdd);
    setValue(SharedPreferenceKey.kiviCareAppointmentDeleteKey, appointmentPermission.kiviCareAppointmentDelete);
    setValue(SharedPreferenceKey.kiviCareAppointmentEditKey, appointmentPermission.kiviCareAppointmentEdit);
    setValue(SharedPreferenceKey.kiviCareAppointmentListKey, appointmentPermission.kiviCareAppointmentList);
    setValue(SharedPreferenceKey.kiviCareAppointmentViewKey, appointmentPermission.kiviCareAppointmentView);
    setValue(SharedPreferenceKey.kiviCarePatientAppointmentStatusChangeKey, appointmentPermission.kiviCarePatientAppointmentStatusChange);
    setValue(SharedPreferenceKey.kiviCareAppointmentExportKey, appointmentPermission.kiviCareAppointmentExport);
  }

  void setBillingModulePermission(BillingModule? billingModulePermission) {
    if (billingModulePermission != null) {
      billingPermission = billingModulePermission;
    }
    setValue(SharedPreferenceKey.kiviCarePatientBillAddKey, billingPermission.kiviCarePatientBillAdd);
    setValue(SharedPreferenceKey.kiviCarePatientBillDeleteKey, billingPermission.kiviCarePatientBillDelete);
    setValue(SharedPreferenceKey.kiviCarePatientBillEditKey, billingPermission.kiviCarePatientBillEdit);
    setValue(SharedPreferenceKey.kiviCarePatientBillListKey, billingPermission.kiviCarePatientBillList);
    setValue(SharedPreferenceKey.kiviCarePatientBillExportKey, billingPermission.kiviCarePatientBillExport);
    setValue(SharedPreferenceKey.kiviCarePatientBillViewKey, billingPermission.kiviCarePatientBillView);
  }

  void setClinicModulePermission(ClinicModule? clinicModulePermission) {
    if (clinicModulePermission != null) clinicPermission = clinicModulePermission;

    setValue(SharedPreferenceKey.kiviCareClinicAddKey, clinicPermission.kiviCareClinicAdd);
    setValue(SharedPreferenceKey.kiviCareClinicDeleteKey, clinicPermission.kiviCareClinicDelete);
    setValue(SharedPreferenceKey.kiviCareClinicEditKey, clinicPermission.kiviCareClinicEdit);
    setValue(SharedPreferenceKey.kiviCareClinicListKey, clinicPermission.kiviCareClinicList);
    setValue(SharedPreferenceKey.kiviCareClinicProfileKey, clinicPermission.kiviCareClinicProfile);
    setValue(SharedPreferenceKey.kiviCareClinicViewKey, clinicPermission.kiviCareClinicView);
  }

  void setClinicDetailModulePermission(ClinicalDetailModule? clinicalDetailModulePermission) {
    if (clinicalDetailModulePermission != null) clinicDetailPermission = clinicalDetailModulePermission;

    setValue(SharedPreferenceKey.kiviCareMedicalRecordsAddKey, clinicDetailPermission.kiviCareMedicalRecordsAdd);
    setValue(SharedPreferenceKey.kiviCareMedicalRecordsDeleteKey, clinicDetailPermission.kiviCareMedicalRecordsDelete);
    setValue(SharedPreferenceKey.kiviCareMedicalRecordsEditKey, clinicDetailPermission.kiviCareMedicalRecordsEdit);
    setValue(SharedPreferenceKey.kiviCareMedicalRecordsListKey, clinicDetailPermission.kiviCareMedicalRecordsList);
    setValue(SharedPreferenceKey.kiviCareMedicalRecordsViewKey, clinicDetailPermission.kiviCareMedicalRecordsView);
  }

  void setDoctorDashboardPermission(DashboardModule? dashboardModulePermission) {
    if (dashboardModulePermission != null) dashboardPermission = dashboardModulePermission;
    setValue(SharedPreferenceKey.kiviCareDashboardTotalAppointmentKey, dashboardPermission.kiviCareDashboardTotalAppointment);
    setValue(SharedPreferenceKey.kiviCareDashboardTotalDoctorKey, dashboardPermission.kiviCareDashboardTotalDoctor);
    setValue(SharedPreferenceKey.kiviCareDashboardTotalPatientKey, dashboardPermission.kiviCareDashboardTotalPatient);
    setValue(SharedPreferenceKey.kiviCareDashboardTotalRevenueKey, dashboardPermission.kiviCareDashboardTotalRevenue);
    setValue(SharedPreferenceKey.kiviCareDashboardTotalTodayAppointmentKey, dashboardPermission.kiviCareDashboardTotalTodayAppointment);
    setValue(SharedPreferenceKey.kiviCareDashboardTotalServiceKey, dashboardPermission.kiviCareDashboardTotalService);
  }

  void setDoctorModulePermission(DoctorModule? doctorModulePermission) {
    if (doctorModulePermission != null) doctorPermission = doctorModulePermission;
    setValue(SharedPreferenceKey.kiviCareDoctorAddKey, doctorPermission.kiviCareDoctorAdd);
    setValue(SharedPreferenceKey.kiviCareDoctorDeleteKey, doctorPermission.kiviCareDoctorDelete);
    setValue(SharedPreferenceKey.kiviCareDoctorEditKey, doctorPermission.kiviCareDoctorEdit);
    setValue(SharedPreferenceKey.kiviCareDoctorDashboardKey, doctorPermission.kiviCareDoctorDashboard);
    setValue(SharedPreferenceKey.kiviCareDoctorListKey, doctorPermission.kiviCareDoctorList);
    setValue(SharedPreferenceKey.kiviCareDoctorViewKey, doctorPermission.kiviCareDoctorView);
    setValue(SharedPreferenceKey.kiviCareDoctorExportKey, doctorPermission.kiviCareDoctorExport);
  }

  void setEncounterModulePermission(EncounterPermissionModule? encounterPermissionModule) {
    if (encounterPermissionModule != null) encounterPermission = encounterPermissionModule;
    setValue(SharedPreferenceKey.kiviCarePatientEncounterAddKey, encounterPermission.kiviCarePatientEncounterAdd);
    setValue(SharedPreferenceKey.kiviCarePatientEncounterDeleteKey, encounterPermission.kiviCarePatientEncounterDelete);
    setValue(SharedPreferenceKey.kiviCarePatientEncounterEditKey, encounterPermission.kiviCarePatientEncounterEdit);
    setValue(SharedPreferenceKey.kiviCarePatientEncounterExportKey, encounterPermission.kiviCarePatientEncounterExport);
    setValue(SharedPreferenceKey.kiviCarePatientEncounterListKey, encounterPermission.kiviCarePatientEncounterList);
    setValue(SharedPreferenceKey.kiviCarePatientEncountersKey, encounterPermission.kiviCarePatientEncounters);
    setValue(SharedPreferenceKey.kiviCarePatientEncounterViewKey, encounterPermission.kiviCarePatientEncounterView);
  }

  void setEncounterTemplateModulePermission(EncountersTemplateModule? encounterTemplateModulePermission) {
    if (encounterTemplateModulePermission != null) encountersTemplatePermission = encounterTemplateModulePermission;
    setValue(SharedPreferenceKey.kiviCareEncountersTemplateAddKey, encountersTemplatePermission.kiviCareEncountersTemplateAdd);
    setValue(SharedPreferenceKey.kiviCareEncountersTemplateDeleteKey, encountersTemplatePermission.kiviCareEncountersTemplateDelete);
    setValue(SharedPreferenceKey.kiviCareEncountersTemplateEditKey, encountersTemplatePermission.kiviCareEncountersTemplateEdit);
    setValue(SharedPreferenceKey.kiviCareEncountersTemplateListKey, encountersTemplatePermission.kiviCareEncountersTemplateList);
    setValue(SharedPreferenceKey.kiviCareEncountersTemplateViewKey, encountersTemplatePermission.kiviCareEncountersTemplateView);
  }

  void setHolidayModulePermission(HolidayModule? holidayModulePermission) {
    if (holidayModulePermission != null) holidayPermission = holidayModulePermission;
    setValue(SharedPreferenceKey.kiviCareClinicScheduleKey, holidayPermission.kiviCareClinicSchedule);
    setValue(SharedPreferenceKey.kiviCareClinicScheduleAddKey, holidayPermission.kiviCareClinicScheduleAdd);
    setValue(SharedPreferenceKey.kiviCareClinicScheduleDeleteKey, holidayPermission.kiviCareClinicScheduleDelete);
    setValue(SharedPreferenceKey.kiviCareClinicScheduleEditKey, holidayPermission.kiviCareClinicScheduleEdit);
    setValue(SharedPreferenceKey.kiviCareClinicScheduleExportKey, holidayPermission.kiviCareClinicScheduleExport);
  }

  void setSessionPermission(SessionModule? sessionModulePermission) {
    if (sessionModulePermission != null) sessionPermission = sessionModulePermission;
    setValue(SharedPreferenceKey.kiviCareDoctorSessionAddKey, sessionPermission.kiviCareDoctorSessionAdd);
    setValue(SharedPreferenceKey.kiviCareDoctorSessionEditKey, sessionPermission.kiviCareDoctorSessionEdit);
    setValue(SharedPreferenceKey.kiviCareDoctorSessionListKey, sessionPermission.kiviCareDoctorSessionList);
    setValue(SharedPreferenceKey.kiviCareDoctorSessionDeleteKey, sessionPermission.kiviCareDoctorSessionDelete);
    setValue(SharedPreferenceKey.kiviCareDoctorSessionExportKey, sessionPermission.kiviCareDoctorSessionExport);
  }

  void setOtherModulePermission(OtherModule? otherModulePermission) {
    if (otherModulePermission != null) otherPermission = otherModulePermission;
    setValue(SharedPreferenceKey.kiviCareChangePasswordKey, otherPermission.kiviCareChangePassword);
    setValue(SharedPreferenceKey.kiviCarePatientReviewAddKey, otherPermission.kiviCarePatientReviewAdd);
    setValue(SharedPreferenceKey.kiviCarePatientReviewDeleteKey, otherPermission.kiviCarePatientReviewDelete);
    setValue(SharedPreferenceKey.kiviCarePatientReviewEditKey, otherPermission.kiviCarePatientReviewEdit);
    setValue(SharedPreferenceKey.kiviCarePatientReviewGetKey, otherPermission.kiviCarePatientReviewGet);
    setValue(SharedPreferenceKey.kiviCareDashboardKey, otherPermission.kiviCareDashboard);
  }

  void setPatientModulePermission(PatientModule? patientModulePermission) {
    if (patientModulePermission != null) patientPermission = patientModulePermission;
    setValue(SharedPreferenceKey.kiviCarePatientAddKey, patientPermission.kiviCarePatientAdd);
    setValue(SharedPreferenceKey.kiviCarePatientDeleteKey, patientPermission.kiviCarePatientDelete);
    setValue(SharedPreferenceKey.kiviCarePatientClinicKey, patientPermission.kiviCarePatientClinic);
    setValue(SharedPreferenceKey.kiviCarePatientProfileKey, patientPermission.kiviCarePatientProfile);
    setValue(SharedPreferenceKey.kiviCarePatientEditKey, patientPermission.kiviCarePatientEdit);
    setValue(SharedPreferenceKey.kiviCarePatientListKey, patientPermission.kiviCarePatientList);
    setValue(SharedPreferenceKey.kiviCarePatientExportKey, patientPermission.kiviCarePatientExport);
    setValue(SharedPreferenceKey.kiviCarePatientViewKey, patientPermission.kiviCarePatientView);
  }

  void setReceptionistModule(ReceptionistModule? receptionistModulePermission) {
    if (receptionistModulePermission != null) receptionistPermission = receptionistModulePermission;
    setValue(SharedPreferenceKey.kiviCareReceptionistProfileKey, receptionistPermission);
  }

  void setPatientReportModulePermission(ReportModule? reportModulePermission) {
    if (reportModulePermission != null) {
      reportPermission = reportModulePermission;
    }
    setValue(SharedPreferenceKey.kiviCarePatientReportKey, reportPermission.kiviCarePatientReport);
    setValue(SharedPreferenceKey.kiviCarePatientReportAddKey, reportPermission.kiviCarePatientReportAdd);
    setValue(SharedPreferenceKey.kiviCarePatientReportEditKey, reportPermission.kiviCarePatientReportEdit);
    setValue(SharedPreferenceKey.kiviCarePatientReportViewKey, reportPermission.kiviCarePatientReportView);
    setValue(SharedPreferenceKey.kiviCarePatientReportDeleteKey, reportPermission.kiviCarePatientReportDelete);
  }

  void setPrescriptionModulePermission(PrescriptionPermissionModule? prescriptionModulePermission) {
    if (prescriptionModulePermission != null) prescriptionPermission = prescriptionModulePermission;
    setValue(SharedPreferenceKey.kiviCarePrescriptionAddKey, prescriptionPermission.kiviCarePrescriptionAdd);
    setValue(SharedPreferenceKey.kiviCarePrescriptionDeleteKey, prescriptionPermission.kiviCarePrescriptionDelete);
    setValue(SharedPreferenceKey.kiviCarePrescriptionEditKey, prescriptionPermission.kiviCarePrescriptionEdit);
    setValue(SharedPreferenceKey.kiviCarePrescriptionViewKey, prescriptionPermission.kiviCarePrescriptionView);
    setValue(SharedPreferenceKey.kiviCarePrescriptionListKey, prescriptionPermission.kiviCarePrescriptionList);
    setValue(SharedPreferenceKey.kiviCarePrescriptionExportKey, prescriptionPermission.kiviCarePrescriptionExport);
  }

  void setServiceModulePermission(ServiceModule? serviceModulePermission) {
    if (serviceModulePermission != null) servicePermission = serviceModulePermission;
    setValue(SharedPreferenceKey.kiviCareServiceAddKey, servicePermission.kiviCareServiceAdd);
    setValue(SharedPreferenceKey.kiviCareServiceDeleteKey, servicePermission.kiviCareServiceDelete);
    setValue(SharedPreferenceKey.kiviCareServiceEditKey, servicePermission.kiviCareServiceEdit);
    setValue(SharedPreferenceKey.kiviCareServiceExportKey, servicePermission.kiviCareServiceExport);
    setValue(SharedPreferenceKey.kiviCareServiceListKey, servicePermission.kiviCareServiceList);
    setValue(SharedPreferenceKey.kiviCareServiceViewKey, servicePermission.kiviCareServiceView);
  }

  void setStaticDataModulePermission(StaticDataModule? staticDataModulePermission) {
    if (staticDataModulePermission != null) {
      staticDataPermission = staticDataModulePermission;
    }
    setValue(SharedPreferenceKey.kiviCareStaticDataAddKey, staticDataPermission.kiviCareStaticDataAdd);
    setValue(SharedPreferenceKey.kiviCareStaticDataDeleteKey, staticDataPermission.kiviCareStaticDataDelete);
    setValue(SharedPreferenceKey.kiviCareStaticDataEditKey, staticDataPermission.kiviCareStaticDataEdit);
    setValue(SharedPreferenceKey.kiviCareStaticDataExportKey, staticDataPermission.kiviCareStaticDataExport);
    setValue(SharedPreferenceKey.kiviCareStaticDataListKey, staticDataPermission.kiviCareStaticDataList);
    setValue(SharedPreferenceKey.kiviCareStaticDataViewKey, staticDataPermission.kiviCareStaticDataView);
  }
}
