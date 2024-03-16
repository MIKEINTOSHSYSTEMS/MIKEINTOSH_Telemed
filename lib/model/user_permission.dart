class UserPermission {
  AppointmentModule? appointmentModule;
  BillingModule? billingModule;
  ClinicModule? clinicModule;
  ClinicalDetailModule? clinicalDetailModule;
  DashboardModule? dashboardModule;
  DoctorModule? doctorModule;
  EncounterPermissionModule? encounterModule;
  EncountersTemplateModule? encountersTemplateModule;
  HolidayModule? holidayModule;
  OtherModule? otherModule;
  PatientModule? patientModule;
  ReportModule? patientReportModule;
  PrescriptionPermissionModule? prescriptionModule;
  ReceptionistModule? receptionistModule;
  ServiceModule? serviceModule;
  SessionModule? sessionModule;
  StaticDataModule? staticDataModule;

  UserPermission({
    this.appointmentModule,
    this.billingModule,
    this.clinicModule,
    this.clinicalDetailModule,
    this.dashboardModule,
    this.doctorModule,
    this.encounterModule,
    this.encountersTemplateModule,
    this.holidayModule,
    this.otherModule,
    this.patientModule,
    this.patientReportModule,
    this.prescriptionModule,
    this.receptionistModule,
    this.serviceModule,
    this.sessionModule,
    this.staticDataModule,
  });

  factory UserPermission.fromJson(Map<String, dynamic> json) => UserPermission(
        appointmentModule: json["appointment_module"] == null ? null : AppointmentModule.fromJson(json["appointment_module"]),
        billingModule: json["billing_module"] == null ? null : BillingModule.fromJson(json["billing_module"]),
        clinicModule: json["clinic_module"] == null ? null : ClinicModule.fromJson(json["clinic_module"]),
        clinicalDetailModule: json["clinical_detail_module"] == null ? null : ClinicalDetailModule.fromJson(json["clinical_detail_module"]),
        dashboardModule: json["dashboard_module"] == null ? null : DashboardModule.fromJson(json["dashboard_module"]),
        doctorModule: json["doctor_module"] == null ? null : DoctorModule.fromJson(json["doctor_module"]),
        encounterModule: json["encounter_module"] == null ? null : EncounterPermissionModule.fromJson(json["encounter_module"]),
        encountersTemplateModule: json["encounters_template_module"] == null ? null : EncountersTemplateModule.fromJson(json["encounters_template_module"]),
        holidayModule: json["holiday_module"] == null ? null : HolidayModule.fromJson(json["holiday_module"]),
        otherModule: json["other_module"] == null ? null : OtherModule.fromJson(json["other_module"]),
        patientModule: json["patient_module"] == null ? null : PatientModule.fromJson(json["patient_module"]),
        patientReportModule: json["patient_report_module"] == null ? null : ReportModule.fromJson(json["patient_report_module"]),
        prescriptionModule: json["prescription_module"] == null ? null : PrescriptionPermissionModule.fromJson(json["prescription_module"]),
        receptionistModule: json["receptionist_module"] == null ? null : ReceptionistModule.fromJson(json["receptionist_module"]),
        serviceModule: json["service_module"] == null ? null : ServiceModule.fromJson(json["service_module"]),
        sessionModule: json["session_module"] == null ? null : SessionModule.fromJson(json["session_module"]),
        staticDataModule: json["static_data_module"] == null ? null : StaticDataModule.fromJson(json["static_data_module"]),
      );

  Map<String, dynamic> toJson() => {
        "appointment_module": appointmentModule?.toJson(),
        "billing_module": billingModule?.toJson(),
        "clinic_module": clinicModule?.toJson(),
        "clinical_detail_module": clinicalDetailModule?.toJson(),
        "dashboard_module": dashboardModule?.toJson(),
        "doctor_module": doctorModule?.toJson(),
        "encounter_module": encounterModule?.toJson(),
        "encounters_template_module": encountersTemplateModule?.toJson(),
        "holiday_module": holidayModule?.toJson(),
        "other_module": otherModule?.toJson(),
        "patient_module": patientModule?.toJson(),
        "patient_report_module": patientReportModule?.toJson(),
        "prescription_module": prescriptionModule?.toJson(),
        "receptionist_module": receptionistModule?.toJson(),
        "service_module": serviceModule?.toJson(),
        "session_module": sessionModule?.toJson(),
        "static_data_module": staticDataModule?.toJson(),
      };
}

class AppointmentModule {
  bool? kiviCareAppointmentList;
  bool? kiviCareAppointmentAdd;
  bool? kiviCareAppointmentEdit;
  bool? kiviCareAppointmentView;
  bool? kiviCareAppointmentDelete;
  bool? kiviCarePatientAppointmentStatusChange;
  bool? kiviCareAppointmentExport;

  AppointmentModule({
    this.kiviCareAppointmentList,
    this.kiviCareAppointmentAdd,
    this.kiviCareAppointmentEdit,
    this.kiviCareAppointmentView,
    this.kiviCareAppointmentDelete,
    this.kiviCarePatientAppointmentStatusChange,
    this.kiviCareAppointmentExport,
  });

  factory AppointmentModule.fromJson(Map<String, dynamic> json) => AppointmentModule(
        kiviCareAppointmentList: json["kiviCare_appointment_list"],
        kiviCareAppointmentAdd: json["kiviCare_appointment_add"],
        kiviCareAppointmentEdit: json["kiviCare_appointment_edit"],
        kiviCareAppointmentView: json["kiviCare_appointment_view"],
        kiviCareAppointmentDelete: json["kiviCare_appointment_delete"],
        kiviCarePatientAppointmentStatusChange: json["kiviCare_patient_appointment_status_change"],
        kiviCareAppointmentExport: json["kiviCare_appointment_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_appointment_list": kiviCareAppointmentList,
        "kiviCare_appointment_add": kiviCareAppointmentAdd,
        "kiviCare_appointment_edit": kiviCareAppointmentEdit,
        "kiviCare_appointment_view": kiviCareAppointmentView,
        "kiviCare_appointment_delete": kiviCareAppointmentDelete,
        "kiviCare_patient_appointment_status_change": kiviCarePatientAppointmentStatusChange,
        "kiviCare_appointment_export": kiviCareAppointmentExport,
      };
}

class BillingModule {
  bool? kiviCarePatientBillList;
  bool? kiviCarePatientBillAdd;
  bool? kiviCarePatientBillEdit;
  bool? kiviCarePatientBillView;
  bool? kiviCarePatientBillDelete;
  bool? kiviCarePatientBillExport;

  BillingModule({
    this.kiviCarePatientBillList,
    this.kiviCarePatientBillAdd,
    this.kiviCarePatientBillEdit,
    this.kiviCarePatientBillView,
    this.kiviCarePatientBillDelete,
    this.kiviCarePatientBillExport,
  });

  factory BillingModule.fromJson(Map<String, dynamic> json) => BillingModule(
        kiviCarePatientBillList: json["kiviCare_patient_bill_list"],
        kiviCarePatientBillAdd: json["kiviCare_patient_bill_add"],
        kiviCarePatientBillEdit: json["kiviCare_patient_bill_edit"],
        kiviCarePatientBillView: json["kiviCare_patient_bill_view"],
        kiviCarePatientBillDelete: json["kiviCare_patient_bill_delete"],
        kiviCarePatientBillExport: json["kiviCare_patient_bill_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_patient_bill_list": kiviCarePatientBillList,
        "kiviCare_patient_bill_add": kiviCarePatientBillAdd,
        "kiviCare_patient_bill_edit": kiviCarePatientBillEdit,
        "kiviCare_patient_bill_view": kiviCarePatientBillView,
        "kiviCare_patient_bill_delete": kiviCarePatientBillDelete,
        "kiviCare_patient_bill_export": kiviCarePatientBillExport,
      };
}

class ClinicModule {
  bool? kiviCareClinicList;
  bool? kiviCareClinicAdd;
  bool? kiviCareClinicEdit;
  bool? kiviCareClinicView;
  bool? kiviCareClinicDelete;
  bool? kiviCareClinicProfile;

  ClinicModule({
    this.kiviCareClinicList,
    this.kiviCareClinicAdd,
    this.kiviCareClinicEdit,
    this.kiviCareClinicView,
    this.kiviCareClinicDelete,
    this.kiviCareClinicProfile,
  });

  factory ClinicModule.fromJson(Map<String, dynamic> json) => ClinicModule(
        kiviCareClinicList: json["kiviCare_clinic_list"],
        kiviCareClinicAdd: json["kiviCare_clinic_add"],
        kiviCareClinicEdit: json["kiviCare_clinic_edit"],
        kiviCareClinicView: json["kiviCare_clinic_view"],
        kiviCareClinicDelete: json["kiviCare_clinic_delete"],
        kiviCareClinicProfile: json["kiviCare_clinic_profile"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_clinic_list": kiviCareClinicList,
        "kiviCare_clinic_add": kiviCareClinicAdd,
        "kiviCare_clinic_edit": kiviCareClinicEdit,
        "kiviCare_clinic_view": kiviCareClinicView,
        "kiviCare_clinic_delete": kiviCareClinicDelete,
        "kiviCare_clinic_profile": kiviCareClinicProfile,
      };
}

class ClinicalDetailModule {
  bool? kiviCareMedicalRecordsList;
  bool? kiviCareMedicalRecordsAdd;
  bool? kiviCareMedicalRecordsEdit;
  bool? kiviCareMedicalRecordsView;
  bool? kiviCareMedicalRecordsDelete;

  ClinicalDetailModule({
    this.kiviCareMedicalRecordsList,
    this.kiviCareMedicalRecordsAdd,
    this.kiviCareMedicalRecordsEdit,
    this.kiviCareMedicalRecordsView,
    this.kiviCareMedicalRecordsDelete,
  });

  factory ClinicalDetailModule.fromJson(Map<String, dynamic> json) => ClinicalDetailModule(
        kiviCareMedicalRecordsList: json["kiviCare_medical_records_list"],
        kiviCareMedicalRecordsAdd: json["kiviCare_medical_records_add"],
        kiviCareMedicalRecordsEdit: json["kiviCare_medical_records_edit"],
        kiviCareMedicalRecordsView: json["kiviCare_medical_records_view"],
        kiviCareMedicalRecordsDelete: json["kiviCare_medical_records_delete"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_medical_records_list": kiviCareMedicalRecordsList,
        "kiviCare_medical_records_add": kiviCareMedicalRecordsAdd,
        "kiviCare_medical_records_edit": kiviCareMedicalRecordsEdit,
        "kiviCare_medical_records_view": kiviCareMedicalRecordsView,
        "kiviCare_medical_records_delete": kiviCareMedicalRecordsDelete,
      };
}

class DashboardModule {
  bool? kiviCareDashboardTotalPatient;
  bool? kiviCareDashboardTotalDoctor;
  bool? kiviCareDashboardTotalAppointment;
  bool? kiviCareDashboardTotalRevenue;

  bool? kiviCareDashboardTotalTodayAppointment;

  bool? kiviCareDashboardTotalService;

  DashboardModule({
    this.kiviCareDashboardTotalPatient,
    this.kiviCareDashboardTotalDoctor,
    this.kiviCareDashboardTotalAppointment,
    this.kiviCareDashboardTotalRevenue,
    this.kiviCareDashboardTotalService,
    this.kiviCareDashboardTotalTodayAppointment,
  });

  factory DashboardModule.fromJson(Map<String, dynamic> json) => DashboardModule(
        kiviCareDashboardTotalPatient: json["kiviCare_dashboard_total_patient"],
        kiviCareDashboardTotalDoctor: json["kiviCare_dashboard_total_doctor"],
        kiviCareDashboardTotalAppointment: json["kiviCare_dashboard_total_appointment"],
        kiviCareDashboardTotalRevenue: json["kiviCare_dashboard_total_revenue"],
        kiviCareDashboardTotalService: json['kiviCare_dashboard_total_service'],
        kiviCareDashboardTotalTodayAppointment: json['kiviCare_dashboard_total_today_appointment'],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_dashboard_total_patient": kiviCareDashboardTotalPatient,
        "kiviCare_dashboard_total_doctor": kiviCareDashboardTotalDoctor,
        "kiviCare_dashboard_total_appointment": kiviCareDashboardTotalAppointment,
        "kiviCare_dashboard_total_revenue": kiviCareDashboardTotalRevenue,
      };
}

class DoctorModule {
  bool? kiviCareDoctorDashboard;
  bool? kiviCareDoctorList;
  bool? kiviCareDoctorAdd;
  bool? kiviCareDoctorEdit;
  bool? kiviCareDoctorView;
  bool? kiviCareDoctorDelete;
  bool? kiviCareDoctorExport;

  DoctorModule({
    this.kiviCareDoctorDashboard,
    this.kiviCareDoctorList,
    this.kiviCareDoctorAdd,
    this.kiviCareDoctorEdit,
    this.kiviCareDoctorView,
    this.kiviCareDoctorDelete,
    this.kiviCareDoctorExport,
  });

  factory DoctorModule.fromJson(Map<String, dynamic> json) => DoctorModule(
        kiviCareDoctorDashboard: json["kiviCare_doctor_dashboard"],
        kiviCareDoctorList: json["kiviCare_doctor_list"],
        kiviCareDoctorAdd: json["kiviCare_doctor_add"],
        kiviCareDoctorEdit: json["kiviCare_doctor_edit"],
        kiviCareDoctorView: json["kiviCare_doctor_view"],
        kiviCareDoctorDelete: json["kiviCare_doctor_delete"],
        kiviCareDoctorExport: json["kiviCare_doctor_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_doctor_dashboard": kiviCareDoctorDashboard,
        "kiviCare_doctor_list": kiviCareDoctorList,
        "kiviCare_doctor_add": kiviCareDoctorAdd,
        "kiviCare_doctor_edit": kiviCareDoctorEdit,
        "kiviCare_doctor_view": kiviCareDoctorView,
        "kiviCare_doctor_delete": kiviCareDoctorDelete,
        "kiviCare_doctor_export": kiviCareDoctorExport,
      };
}

class EncounterPermissionModule {
  bool? kiviCarePatientEncounters;
  bool? kiviCarePatientEncounterList;
  bool? kiviCarePatientEncounterAdd;
  bool? kiviCarePatientEncounterEdit;
  bool? kiviCarePatientEncounterView;
  bool? kiviCarePatientEncounterDelete;
  bool? kiviCarePatientEncounterExport;

  EncounterPermissionModule({
    this.kiviCarePatientEncounters,
    this.kiviCarePatientEncounterList,
    this.kiviCarePatientEncounterAdd,
    this.kiviCarePatientEncounterEdit,
    this.kiviCarePatientEncounterView,
    this.kiviCarePatientEncounterDelete,
    this.kiviCarePatientEncounterExport,
  });

  factory EncounterPermissionModule.fromJson(Map<String, dynamic> json) => EncounterPermissionModule(
        kiviCarePatientEncounters: json["kiviCare_patient_encounters"],
        kiviCarePatientEncounterList: json["kiviCare_patient_encounter_list"],
        kiviCarePatientEncounterAdd: json["kiviCare_patient_encounter_add"],
        kiviCarePatientEncounterEdit: json["kiviCare_patient_encounter_edit"],
        kiviCarePatientEncounterView: json["kiviCare_patient_encounter_view"],
        kiviCarePatientEncounterDelete: json["kiviCare_patient_encounter_delete"],
        kiviCarePatientEncounterExport: json["kiviCare_patient_encounter_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_patient_encounters": kiviCarePatientEncounters,
        "kiviCare_patient_encounter_list": kiviCarePatientEncounterList,
        "kiviCare_patient_encounter_add": kiviCarePatientEncounterAdd,
        "kiviCare_patient_encounter_edit": kiviCarePatientEncounterEdit,
        "kiviCare_patient_encounter_view": kiviCarePatientEncounterView,
        "kiviCare_patient_encounter_delete": kiviCarePatientEncounterDelete,
        "kiviCare_patient_encounter_export": kiviCarePatientEncounterExport,
      };
}

class EncountersTemplateModule {
  bool? kiviCareEncountersTemplateList;
  bool? kiviCareEncountersTemplateAdd;
  bool? kiviCareEncountersTemplateEdit;
  bool? kiviCareEncountersTemplateView;
  bool? kiviCareEncountersTemplateDelete;

  EncountersTemplateModule({
    this.kiviCareEncountersTemplateList,
    this.kiviCareEncountersTemplateAdd,
    this.kiviCareEncountersTemplateEdit,
    this.kiviCareEncountersTemplateView,
    this.kiviCareEncountersTemplateDelete,
  });

  factory EncountersTemplateModule.fromJson(Map<String, dynamic> json) => EncountersTemplateModule(
        kiviCareEncountersTemplateList: json["kiviCare_encounters_template_list"],
        kiviCareEncountersTemplateAdd: json["kiviCare_encounters_template_add"],
        kiviCareEncountersTemplateEdit: json["kiviCare_encounters_template_edit"],
        kiviCareEncountersTemplateView: json["kiviCare_encounters_template_view"],
        kiviCareEncountersTemplateDelete: json["kiviCare_encounters_template_delete"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_encounters_template_list": kiviCareEncountersTemplateList,
        "kiviCare_encounters_template_add": kiviCareEncountersTemplateAdd,
        "kiviCare_encounters_template_edit": kiviCareEncountersTemplateEdit,
        "kiviCare_encounters_template_view": kiviCareEncountersTemplateView,
        "kiviCare_encounters_template_delete": kiviCareEncountersTemplateDelete,
      };
}

class HolidayModule {
  bool? kiviCareClinicSchedule;
  bool? kiviCareClinicScheduleAdd;
  bool? kiviCareClinicScheduleEdit;
  bool? kiviCareClinicScheduleDelete;
  bool? kiviCareClinicScheduleExport;

  HolidayModule({
    this.kiviCareClinicSchedule,
    this.kiviCareClinicScheduleAdd,
    this.kiviCareClinicScheduleEdit,
    this.kiviCareClinicScheduleDelete,
    this.kiviCareClinicScheduleExport,
  });

  factory HolidayModule.fromJson(Map<String, dynamic> json) => HolidayModule(
        kiviCareClinicSchedule: json["kiviCare_clinic_schedule"],
        kiviCareClinicScheduleAdd: json["kiviCare_clinic_schedule_add"],
        kiviCareClinicScheduleEdit: json["kiviCare_clinic_schedule_edit"],
        kiviCareClinicScheduleDelete: json["kiviCare_clinic_schedule_delete"],
        kiviCareClinicScheduleExport: json["kiviCare_clinic_schedule_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_clinic_schedule": kiviCareClinicSchedule,
        "kiviCare_clinic_schedule_add": kiviCareClinicScheduleAdd,
        "kiviCare_clinic_schedule_edit": kiviCareClinicScheduleEdit,
        "kiviCare_clinic_schedule_delete": kiviCareClinicScheduleDelete,
        "kiviCare_clinic_schedule_export": kiviCareClinicScheduleExport,
      };
}

class OtherModule {
  bool? kiviCareSettings;
  bool? kiviCareDashboard;
  bool? kiviCareChangePassword;
  bool? kiviCareHomePage;
  bool? kiviCarePatientReviewAdd;
  bool? kiviCarePatientReviewEdit;
  bool? kiviCarePatientReviewDelete;
  bool? kiviCarePatientReviewGet;

  OtherModule({
    this.kiviCareSettings,
    this.kiviCareDashboard,
    this.kiviCareChangePassword,
    this.kiviCareHomePage,
    this.kiviCarePatientReviewAdd,
    this.kiviCarePatientReviewEdit,
    this.kiviCarePatientReviewDelete,
    this.kiviCarePatientReviewGet,
  });

  factory OtherModule.fromJson(Map<String, dynamic> json) => OtherModule(
        kiviCareSettings: json["kiviCare_settings"],
        kiviCareDashboard: json["kiviCare_dashboard"],
        kiviCareChangePassword: json["kiviCare_change_password"],
        kiviCareHomePage: json["kiviCare_home_page"],
        kiviCarePatientReviewAdd: json["kiviCare_patient_review_add"],
        kiviCarePatientReviewEdit: json["kiviCare_patient_review_edit"],
        kiviCarePatientReviewDelete: json["kiviCare_patient_review_delete"],
        kiviCarePatientReviewGet: json["kiviCare_patient_review_get"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_settings": kiviCareSettings,
        "kiviCare_dashboard": kiviCareDashboard,
        "kiviCare_change_password": kiviCareChangePassword,
        "kiviCare_home_page": kiviCareHomePage,
        "kiviCare_patient_review_add": kiviCarePatientReviewAdd,
        "kiviCare_patient_review_edit": kiviCarePatientReviewEdit,
        "kiviCare_patient_review_delete": kiviCarePatientReviewDelete,
        "kiviCare_patient_review_get": kiviCarePatientReviewGet,
      };
}

class PatientModule {
  bool? kiviCarePatientList;
  bool? kiviCarePatientAdd;
  bool? kiviCarePatientEdit;
  bool? kiviCarePatientView;
  bool? kiviCarePatientDelete;
  bool? kiviCarePatientClinic;
  bool? kiviCarePatientExport;

  bool? kiviCarePatientProfile;

  PatientModule({
    this.kiviCarePatientList,
    this.kiviCarePatientAdd,
    this.kiviCarePatientEdit,
    this.kiviCarePatientView,
    this.kiviCarePatientDelete,
    this.kiviCarePatientClinic,
    this.kiviCarePatientExport,
    this.kiviCarePatientProfile,
  });

  factory PatientModule.fromJson(Map<String, dynamic> json) => PatientModule(
      kiviCarePatientList: json["kiviCare_patient_list"],
      kiviCarePatientAdd: json["kiviCare_patient_add"],
      kiviCarePatientEdit: json["kiviCare_patient_edit"],
      kiviCarePatientView: json["kiviCare_patient_view"],
      kiviCarePatientDelete: json["kiviCare_patient_delete"],
      kiviCarePatientClinic: json["kiviCare_patient_clinic"],
      kiviCarePatientExport: json["kiviCare_patient_export"],
      kiviCarePatientProfile: json['kiviCare_patient_profile']);

  Map<String, dynamic> toJson() => {
        "kiviCare_patient_list": kiviCarePatientList,
        "kiviCare_patient_add": kiviCarePatientAdd,
        "kiviCare_patient_edit": kiviCarePatientEdit,
        "kiviCare_patient_view": kiviCarePatientView,
        "kiviCare_patient_delete": kiviCarePatientDelete,
        "kiviCare_patient_clinic": kiviCarePatientClinic,
        "kiviCare_patient_export": kiviCarePatientExport,
      };
}

class ReportModule {
  bool? kiviCarePatientReport;
  bool? kiviCarePatientReportAdd;
  bool? kiviCarePatientReportView;
  bool? kiviCarePatientReportDelete;
  bool? kiviCarePatientReportEdit;

  ReportModule({
    this.kiviCarePatientReport,
    this.kiviCarePatientReportAdd,
    this.kiviCarePatientReportView,
    this.kiviCarePatientReportDelete,
    this.kiviCarePatientReportEdit,
  });

  factory ReportModule.fromJson(Map<String, dynamic> json) => ReportModule(
        kiviCarePatientReport: json["kiviCare_patient_report"],
        kiviCarePatientReportAdd: json["kiviCare_patient_report_add"],
        kiviCarePatientReportView: json["kiviCare_patient_report_view"],
        kiviCarePatientReportDelete: json["kiviCare_patient_report_delete"],
        kiviCarePatientReportEdit: json["kiviCare_patient_report_edit"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_patient_report": kiviCarePatientReport,
        "kiviCare_patient_report_add": kiviCarePatientReportAdd,
        "kiviCare_patient_report_view": kiviCarePatientReportView,
        "kiviCare_patient_report_delete": kiviCarePatientReportDelete,
        "kiviCare_patient_report_edit": kiviCarePatientReportEdit,
      };
}

class PrescriptionPermissionModule {
  bool? kiviCarePrescriptionList;
  bool? kiviCarePrescriptionAdd;
  bool? kiviCarePrescriptionEdit;
  bool? kiviCarePrescriptionView;
  bool? kiviCarePrescriptionDelete;
  bool? kiviCarePrescriptionExport;

  PrescriptionPermissionModule({
    this.kiviCarePrescriptionList,
    this.kiviCarePrescriptionAdd,
    this.kiviCarePrescriptionEdit,
    this.kiviCarePrescriptionView,
    this.kiviCarePrescriptionDelete,
    this.kiviCarePrescriptionExport,
  });

  factory PrescriptionPermissionModule.fromJson(Map<String, dynamic> json) => PrescriptionPermissionModule(
        kiviCarePrescriptionList: json["kiviCare_prescription_list"],
        kiviCarePrescriptionAdd: json["kiviCare_prescription_add"],
        kiviCarePrescriptionEdit: json["kiviCare_prescription_edit"],
        kiviCarePrescriptionView: json["kiviCare_prescription_view"],
        kiviCarePrescriptionDelete: json["kiviCare_prescription_delete"],
        kiviCarePrescriptionExport: json["kiviCare_prescription_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_prescription_list": kiviCarePrescriptionList,
        "kiviCare_prescription_add": kiviCarePrescriptionAdd,
        "kiviCare_prescription_edit": kiviCarePrescriptionEdit,
        "kiviCare_prescription_view": kiviCarePrescriptionView,
        "kiviCare_prescription_delete": kiviCarePrescriptionDelete,
        "kiviCare_prescription_export": kiviCarePrescriptionExport,
      };
}

class ReceptionistModule {
  bool? kiviCareReceptionistProfile;

  ReceptionistModule({
    this.kiviCareReceptionistProfile,
  });

  factory ReceptionistModule.fromJson(Map<String, dynamic> json) => ReceptionistModule(
        kiviCareReceptionistProfile: json["kiviCare_receptionist_profile"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_receptionist_profile": kiviCareReceptionistProfile,
      };
}

class ServiceModule {
  bool? kiviCareServiceList;
  bool? kiviCareServiceAdd;
  bool? kiviCareServiceEdit;
  bool? kiviCareServiceView;
  bool? kiviCareServiceDelete;
  bool? kiviCareServiceExport;

  ServiceModule({
    this.kiviCareServiceList,
    this.kiviCareServiceAdd,
    this.kiviCareServiceEdit,
    this.kiviCareServiceView,
    this.kiviCareServiceDelete,
    this.kiviCareServiceExport,
  });

  factory ServiceModule.fromJson(Map<String, dynamic> json) => ServiceModule(
        kiviCareServiceList: json["kiviCare_service_list"],
        kiviCareServiceAdd: json["kiviCare_service_add"],
        kiviCareServiceEdit: json["kiviCare_service_edit"],
        kiviCareServiceView: json["kiviCare_service_view"],
        kiviCareServiceDelete: json["kiviCare_service_delete"],
        kiviCareServiceExport: json["kiviCare_service_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_service_list": kiviCareServiceList,
        "kiviCare_service_add": kiviCareServiceAdd,
        "kiviCare_service_edit": kiviCareServiceEdit,
        "kiviCare_service_view": kiviCareServiceView,
        "kiviCare_service_delete": kiviCareServiceDelete,
        "kiviCare_service_export": kiviCareServiceExport,
      };
}

class SessionModule {
  bool? kiviCareDoctorSessionList;
  bool? kiviCareDoctorSessionAdd;
  bool? kiviCareDoctorSessionEdit;
  bool? kiviCareDoctorSessionDelete;
  bool? kiviCareDoctorSessionExport;

  SessionModule({
    this.kiviCareDoctorSessionList,
    this.kiviCareDoctorSessionAdd,
    this.kiviCareDoctorSessionEdit,
    this.kiviCareDoctorSessionDelete,
    this.kiviCareDoctorSessionExport,
  });

  factory SessionModule.fromJson(Map<String, dynamic> json) => SessionModule(
        kiviCareDoctorSessionList: json["kiviCare_doctor_session_list"],
        kiviCareDoctorSessionAdd: json["kiviCare_doctor_session_add"],
        kiviCareDoctorSessionEdit: json["kiviCare_doctor_session_edit"],
        kiviCareDoctorSessionDelete: json["kiviCare_doctor_session_delete"],
        kiviCareDoctorSessionExport: json["kiviCare_doctor_session_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_doctor_session_list": kiviCareDoctorSessionList,
        "kiviCare_doctor_session_add": kiviCareDoctorSessionAdd,
        "kiviCare_doctor_session_edit": kiviCareDoctorSessionEdit,
        "kiviCare_doctor_session_delete": kiviCareDoctorSessionDelete,
        "kiviCare_doctor_session_export": kiviCareDoctorSessionExport,
      };
}

class StaticDataModule {
  bool? kiviCareStaticDataList;
  bool? kiviCareStaticDataAdd;
  bool? kiviCareStaticDataEdit;
  bool? kiviCareStaticDataView;
  bool? kiviCareStaticDataDelete;
  bool? kiviCareStaticDataExport;

  StaticDataModule({
    this.kiviCareStaticDataList,
    this.kiviCareStaticDataAdd,
    this.kiviCareStaticDataEdit,
    this.kiviCareStaticDataView,
    this.kiviCareStaticDataDelete,
    this.kiviCareStaticDataExport,
  });

  factory StaticDataModule.fromJson(Map<String, dynamic> json) => StaticDataModule(
        kiviCareStaticDataList: json["kiviCare_static_data_list"],
        kiviCareStaticDataAdd: json["kiviCare_static_data_add"],
        kiviCareStaticDataEdit: json["kiviCare_static_data_edit"],
        kiviCareStaticDataView: json["kiviCare_static_data_view"],
        kiviCareStaticDataDelete: json["kiviCare_static_data_delete"],
        kiviCareStaticDataExport: json["kiviCare_static_data_export"],
      );

  Map<String, dynamic> toJson() => {
        "kiviCare_static_data_list": kiviCareStaticDataList,
        "kiviCare_static_data_add": kiviCareStaticDataAdd,
        "kiviCare_static_data_edit": kiviCareStaticDataEdit,
        "kiviCare_static_data_view": kiviCareStaticDataView,
        "kiviCare_static_data_delete": kiviCareStaticDataDelete,
        "kiviCare_static_data_export": kiviCareStaticDataExport,
      };
}
