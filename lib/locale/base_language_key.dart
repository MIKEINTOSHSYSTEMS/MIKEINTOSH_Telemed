import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get app_name;

  String get lblWalkThroughTitle1;

  String get lblWalkThroughTitle2;

  String get lblWalkThroughTitle3;

  String get lblWalkThroughTitle4;

  String get lblWalkThroughSubTitle1;

  String get lblWalkThroughSubTitle2;

  String get lblWalkThroughSubTitle3;

  String get lblWalkThroughSubTitle4;

  String get lblWalkThroughSkipButton;

  String get lblWalkThroughNextButton;

  String get lblWalkThroughGetStartedButton;

  String get lblSignIn;

  String get lblLogOut;

  String get lblEmail;

  String get lblPassword;

  String get lblOldPassword;

  String get lblNewPassword;

  String get lblConfirmPassword;

  String get lblForgotPassword;

  String get lblSignUp;

  String get lblBasic_Details;

  String get lblOtherDetails;

  String get lblSubmit;

  String get lblFirstName;

  String get lblLastName;

  String get lblContactNumber;

  String get lblDOB;

  String get lblGender;

  String get lblBloodGroup;

  String get lblAddress;

  String get lblCity;

  String get lblState;

  String get lblCountry;

  String get lblPostalCode;

  String get lblSettings;

  String get lblChangePassword;

  String get lblCopyRight;

  String get lblTermsAndCondition;

  String get lblPrivacyPolicy;

  String get lblLanguage;

  String get lblDarkMode;

  String get lblFAQ;

  String get lblAboutUs;

  String get lblRateUs;

  String get lblToPrice;

  String get lblFromPrice;

  String get lblFixedPrice;

  String get lblPrevious;

  String get lblNext;

  String get lblSave;

  String get lblDegree;

  String get lblUniversity;

  String get lblYear;

  String get lblSearch;

  String get lblCancel;

  String get lblEncounterDetail;

  String get lblDoctor;

  String get lblStatus;

  String get lblDescription;

  String get lblNoData;

  String get lblPrescription;

  String get lblFrequency;

  String get lblDuration;

  String get lblInstruction;

  String get change_avatar;

  String get lblSignInToContinue;

  String get lblNewMember;

  String get lblDone;

  String get lblSignUpAsPatient;

  String get lblAlreadyAMember;

  String get lblLogin;

  String get lblDashboard;

  String get lblAppointments;

  String get lblPatients;

  String get lblTotalPatient;

  String get lblTotalVisitedPatients;

  String get lblTotalAppointment;

  String get lblTotalVisitedAppointment;

  String get lblTodayAppointments;

  String get lblTotalTodayAppointments;

  String get lblTotalServices;

  String get lblWeeklyAppointments;

  String get lblWeeklyTotalAppointments;

  String get lblTodaySAppointments;

  String get lblAppointmentDeleted;

  String get lblDate;

  String get lblStart;

  String get lblJoin;

  String get lblConfirmAppointment;

  String get lblStep2Of2;

  String get lblSelectDateTime;

  String get lblSelectServices;

  String get lblBook;

  String get lblNoAppointmentForToday;

  String get lblCheckIn;

  String get lblCheckOut;

  String get lblUpdateAppointmentStatus;

  String get lblAreDeleteAppointment;

  String get lblYouCannotStart;

  String get lblPrescriptionAdded;

  String get lblUpdatedSuccessfully;

  String get lblPrescriptionDeleted;

  String get lblAddPrescription;

  String get lblName;

  String get lblPrescriptionFrequencyIsRequired;

  String get lblPrescriptionDurationIsRequired;

  String get lblDurationInDays;

  String get lblAddNewPrescription;

  String get lblEditPrescriptionDetail;

  String get lblAreYouSure;

  String get lblDays;

  String get lblAppointmentIsConfirmed;

  String get lblThanksForBooking;

  String get lblTotalVisitedPatient;

  String get lblAppointmentConfirmation;

  String get lblArticles;

  String get lblAddQualification;

  String get lblEditQualification;

  String get lblNotAppointmentForThisDay;

  String get lblNoPatientFound;

  String get lblDeleteRecordConfirmation;

  String get lblAllRecordsFor;

  String get lblAreDeleted;

  String get lblEditPatient;

  String get lblEncounters;

  String get lblDelete;

  String get lblInformationSaved;

  String get lblMale;

  String get lblFemale;

  String get lblOther;

  String get lblMinimumAgeRequired;

  String get lblCurrentAgeIs;

  String get lblDemoEmailCannotBeChanged;

  String get lblContactNumberIsRequired;

  String get lblGender1;

  String get lblSpecialization;

  String get lblExperience;

  String get lblSaveAndContinue;

  String get lblRange;

  String get lblFixed;

  String get lblZoomConfiguration;

  String get lblTelemed;

  String get lblVideoPrice;

  String get lblAPIKeyCannotBeEmpty;

  String get lblAPIKey;

  String get lblAPISecret;

  String get lblAPISecretCannotBeEmpty;

  String get lblZoomConfigurationGuide;

  String get lblSignUpOrSignIn;

  String get lblZoomMarketPlacePortal;

  String get lbl1;

  String get lbl2;

  String get lblClickOnDevelopButton;

  String get lblCreateApp;

  String get lb13;

  String get lblChooseAppTypeToJWT;

  String get lbl4;

  String get lblMandatoryMessage;

  String get lbl5;

  String get lblCopyAndPasteAPIKey;

  String get lblEncounterClosed;

  String get lblChangedTo;

  String get lblEncounterClose;

  String get lblEncounterWillBeClosed;

  String get lblBillDetails;

  String get lblEncounterDate;

  String get lblClinicName;

  String get lblDoctorName;

  String get lblDesc;

  String get lblDataSaved;

  String get lblAddNewQualification;

  String get lblAddBillItem;

  String get lblServiceIsRequired;

  String get lblOne;

  String get lblPrice;

  String get lblQuantity;

  String get lblTotal;

  String get lblEncounterUpdated;

  String get lblAddNewEncounter;

  String get lblEditEncounterDetail;

  String get lblHolidayOf;

  String get lblModuleIsRequired;

  String get lblScheduleDate;

  String get lblDateIsRequired;

  String get lblLeaveFor;

  String get lblAddHoliday;

  String get lblEditHolidays;

  String get lblAreYouSureToDelete;

  String get lblNewPatientAddedSuccessfully;

  String get lblPatientDetailUpdatedSuccessfully;

  String get lblBasicInformation;

  String get lblFirstNameIsRequired;

  String get lblLastNameIsRequired;

  String get lblEmailIsRequired;

  String get lblGenderIsRequired;

  String get lblOtherInformation;

  String get lblAddNewPatient;

  String get lblEditPatientDetail;

  String get lblCategory;

  String get lblServiceCategoryIsRequired;

  String get lblServiceNameIsRequired;

  String get lblServiceChargesIsRequired;

  String get lblCharges;

  String get lblSelectDoctor;

  String get lblStatusIsRequired;

  String get lblInActive;

  String get lblActive;

  String get lblAddService;

  String get lblEditService;

  String get lblSelectWeekdays;

  String get lblSessionAddedSuccessfully;

  String get lblSessionUpdatedSuccessfully;

  String get lblSessionDeleted;

  String get lblPleaseSelectTime;

  String get lblStartAndEndTimeNotSame;

  String get lblTimeNotBeforeMorningStartTime;

  String get lblTimeNotBeforeEveningStartTime;

  String get lblTimeShouldBeInMultiplyOf5;

  String get lblTimeSlotInMinute;

  String get lblTimeSlotRequired;

  String get lblWeekDays;

  String get lblMorningSession;

  String get lblStartTime;

  String get lblEndTime;

  String get lblSelectStartTimeFirst;

  String get lblEveningSession;

  String get lblAddSession;

  String get lblEditSession;

  String get lblInvoiceDetail;

  String get lblClinicDetails;

  String get lblPatientDetails;

  String get lblServices;

  String get lblDiscount;

  String get lblAmountDue;

  String get lblInvoiceId;

  String get lblCreatedAt;

  String get lblPaymentStatus;

  String get lblPatientName;

  String get lblGender2;

  String get lblSRNo;

  String get lblItemName;

  String get lblPRICE;

  String get lblQUANTITY;

  String get lblTOTAL;

  String get lblServicesSelected;

  String get lblStep1;

  String get lblPleaseSelectDoctor;

  String get lblAppointmentUpdated;

  String get lblStep2;

  String get lblPatientNameIsRequired;

  String get lblDoctorSessions;

  String get lblEditProfile;

  String get lblBasicInfo;

  String get lblBasicSettings;

  String get lblQualification;

  String get lblEncounterDashboard;

  String get lblEncounterDetails;

  String get lblProblems;

  String get lblObservation;

  String get lblNotes;

  String get lblBillAddedSuccessfully;

  String get lblAtLeastSelectOneBillItem;

  String get lblGenerateInvoice;

  String get lblSERVICES;

  String get lblPayableAmount;

  String get lblSaveAndCloseEncounter;

  String get lblHolidayDeleted;

  String get lblHolidays;

  String get lblClinic;

  String get lblAfter;

  String get lblWasOffFor;

  String get lblYourHolidays;

  String get lblNoServicesFound;

  String get lblNoDataFound;

  String get lblTelemedServicesUpdated;

  String get lblOn;

  String get lblOff;

  String get lblNameIsMissing;

  String get lblNoRecordsData;

  String get lblNoAppointments;

  String get lblSelectClinic;

  String get lblClinicIsRequired;

  String get lblAdded;

  String get lblEnter;

  String get lblFieldIsRequired;

  String get lblAreYouSureYouWantToDelete;

  String get lblAllRecords;

  String get lblAllRecordsDeleted;

  String get lblHoliday;

  String get lblClinicHoliday;

  String get lblSessions;

  String get lblClinicSessions;

  String get lblClinicServices;

  String get lblVideoConsulting;

  String get lblYourEncounters;

  String get lblSelectTheme;

  String get lblChooseYourAppTheme;

  String get lblClinicTAndC;

  String get lblAboutKiviCare;

  String get lblYourReviewCounts;

  String get lblAppVersion;

  String get lblHelpAndSupport;

  String get lblSubmitYourQueriesHere;

  String get lblShareKiviCare;

  String get lblLogout;

  String get lblThanksForVisiting;

  String get lblAreYouSureToLogout;

  String get lblNoImage;

  String get lblGeneralSetting;

  String get lblAppSettings;

  String get lblHi;

  String get lblKV;

  String get lblVersion;

  String get lblContactUs;

  String get lblAboutUsDes;

  String get lblPurchase;

  String get lblDemoUserPasswordNotChanged;

  String get lblPasswordLengthMessage;

  String get lblBothPasswordMatched;

  String get lblVisited;

  String get lblBooked;

  String get lblCompleted;

  String get lblCancelled;

  String get lblWhatIsAirbnbPlus;

  String get lblHosting;

  String get lblLoremText;

  String get lblWasAnswerHelpful;

  String get lblYes;

  String get lblNo;

  String get lblPayment;

  String get lblCoupons;

  String get lblReservation;

  String get lblWaiting;

  String get lblHowCanWeHelp;

  String get lblTopQuestions;

  String get lblError;

  String get lblRegisteredSuccessfully;

  String get lblBirthDateIsRequired;

  String get lblBloodGroupIsRequired;

  String get lblAppointmentBookedSuccessfully;

  String get lblAvailableSlots;

  String get lblSelectedSlots;

  String get lblTimeSlotIsRequired;

  String get lblSession;

  String get lblTimeSlotIsBooked;

  String get lblAppointmentDate;

  String get lblSelectedDate;

  String get lblComments;

  String get lblComment;

  String get lblBookNow;

  String get lblViewDetails;

  String get lblDoctorDetails;

  String get lblAreYouWantToDeleteDoctor;

  String get lblDoctorDeleted;

  String get lblYearsExperience;

  String get lblAvailableOn;

  String get lblNoServicesForThisDoctor;

  String get lblHealth;

  String get lblReadMore;

  String get lblReadLess;

  String get lblBy;

  String get lblNews;

  String get lblUpcomingAppointments;

  String get lblTotalUpcoming;

  String get lblTotalUpcomingPatients;

  String get lblViewAll;

  String get lblNoUpcomingAppointments;

  String get lblFindOurBestServices;

  String get lblTopDoctors;

  String get lblFindTheBestDoctors;

  String get lblExpertsHealthTipsAndAdvice;

  String get lblArticlesByHighlyQualifiedDoctors;

  String get lblStep1Of1;

  String get lblChooseYourDoctor;

  String get lblAddNewAppointment;

  String get lblSelectOneDoctor;

  String get lblServicesIsRequired;

  String get lblClinicDoctor;

  String get lblRupee;

  String get lblPatientDashboard;

  String get lblFeedsAndArticles;

  String get lblPatientsEncounter;

  String get lblNoEncounterFound;

  String get lblDoctorIsRequired;

  String get lblApply;

  String get lblSelectSpecialization;

  String get lblSelectedIndex;

  String get lblAddDoctorProfile;

  String get lblMoreItems;

  String get lblHello;

  String get lblDoctorAddedSuccessfully;

  String get lblDoctorUpdatedSuccessfully;

  String get lblMedicalReport;

  String get lblNewMedicalReport;

  String get lblPatientReport;

  String get lblClinicAppointments;

  String get lblClinicDoctors;

  String get lblClinicPatient;

  String get lblStep1Of3;

  String get lblStep2Of3;

  String get lblStep3Of3;

  String get lblStep1Of2;

  String get lblGoogleCalendarConfiguration;

  String get lblRememberMe;

  String get lblChooseYourClinic;

  String get lblAll;

  String get lblLatest;

  String get lblMon;

  String get lblTue;

  String get lblWed;

  String get lblThu;

  String get lblFri;

  String get lblSat;

  String get lblSun;

  String get lblToday;

  String get lblDatePassed;

  String get lblNoReportWasSelected;

  String get lblAddReportScreen;

  String get lblDatecantBeNull;

  String get lblUploadReport;

  String get lblConnectWithGoogle;

  String get lblDisconnect;

  String get lblAreYouSureYouWantToDisconnect;

  String get lblLight;

  String get lblDark;

  String get lblSystemDefault;

  String get lblViewAllReports;

  String get lblNA;

  String get lblOk;

  String get lblPrescriptionRequired;

  String get lblAddedNewEncounter;

  String get lblCantEditDate;

  String get lblNoTitle;

  String get lblSelectOneClinic;

  String get lblPast;

  String get lblAddMedicalReport;

  String get lblSend_prescription_on_mail;

  String get lblYouAreConnectedWithTheGoogleCalender;

  String get lblPleaseConnectWithYourGoogleAccountToGetAppointmentsInGoogleCalendarAutomatically;

  String get lblGoogleMeet;

  String get lblYouCanUseOneMeetingServiceAtTheTimeWeAreDisablingZoomService;

  String get lblYouCanUseOneMeetingServiceAtTheTimeWeAreDisablingGoogleMeetService;

  String get lblYourNumber;

  String get lblFilesSelected;

  String get lblService;

  String get lblTime;

  String get lblAppointmentSummary;

  String get lblEncounter;

  String get lblMedicalReports;

  String get lblSearchDoctor;

  String get lblConnectedWith;

  String get lblFor;

  String get lblContact;

  String get lblQrScanner;

  String get lblLoginSuccessfully;

  String get lblWrongUser;

  String get lblTryDemoWithBackendURL;

  String get lblPatientSelected;

  String get lblSpeciality;

  String get lblOpen;

  String get lblMorning;

  String get lblEvening;

  String get lblShare;

  String get lblNoMatch;

  String get lblNoDataSubTitle;

  String get lblEdit;

  String get lblSwipeMassage;
}
