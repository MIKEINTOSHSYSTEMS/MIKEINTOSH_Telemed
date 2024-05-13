import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get lblContinue;
  String get lblShippingCost;
  String get lblNoPaymentMethods;
  String get lblAddOrderNotes;
  String get lblNotesAboutOrder;
  String get lblOptional;
  String get lblCouponRemoved;
  String get lblBuyThisOnWordpressStore;
  String get lblChooseFromCollection;
  String get lblViewCoupons;
  String get lblExperiencePractitioner;
  String get lblShopFromWordpress;
  String get lblShop;
  String get lblAddressSubTitle;

  String get lblOrders;

  String get lblOrdersSubtitle;

  String get lblCoupons;

  String get lblCouponsSubtitle;

  String get lblAny;

  String get lblProcessing;

  String get lblOnHold;

  String get lblRefunded;

  String get lblFailed;

  String get lblTrash;

  String get lblPermissionDenied;

  String get lblSetAddress;

  String get lblPickAddress;

  String get lblSwipeRightNote;

  String get lblCompany;

  String get lblSale;

  String get lblEnterValidCouponCode;

  String get lblNoProductsFound;

  String get lblCantFindProductYouSearchedFor;

  String get lblAverageRating;

  String get lblPopularity;

  String get lblPrice;

  String get lblReasonForCancellation;

  String get lblCancelOrder;

  String get lblCouponDiscount;

  String get lblReviewHint;

  String get lblViewProducts;

  String get lblPleaseSelectProduct;

  String get lblPleaseAddQuantity;

  String get lblPleaseSelectCountry;

  String get lblCopiedToClipboard;

  String get lblCartUpdated;

  String get lblOrderDeleted;

  String get lblEnterValidBllling;

  String get lblYourCarIsEmpty;

  String get ago;

  String get day;

  String get hour;

  String get minute;

  String get second;

  String get justNow;

  String get currentLocation;

  String get chooseFromMap;

  String get orderCancelledSuccessfully;

  String get cancelOrderConfirmation;

  String get orderStatus;

  String get orderNumber;

  String get paymentMethod;

  String get date;

  String get customerReview;

  String get chooseAnOption;

  String get sku;

  String get category;

  String get reviewAddedSuccessfully;

  String get pleaseAddReview;

  String get pleaseAddRating;

  String get reviews;

  String get editReview;

  String get addAReview;

  String get rating;

  String get writeReview;

  String get reviewUpdatedSuccessfully;

  String get reviewDeletedSuccessfully;

  String get deleteReviewConfirmation;

  String get yourCartIsCurrentlyEmpty;

  String get returnToShop;

  String get cartUpdated;

  String get itemRemovedSuccessfully;

  String get removeFromCartConfirmation;

  String get appliedCoupons;

  String get successfullyAddedToCart;

  String get addToCart;

  String get clickToRefresh;

  String get state;

  String get pleaseEnterDescription;

  String get replyTo;

  String get enterValidCouponCode;

  String get code;

  String get shippingAddress;

  String get billingAndShippingAddresses;

  String get copiedToClipboard;

  String get expiresOn;

  String get off;

  String get myWishlist;

  String get sortBy;

  String get selectCategory;

  String get shop;

  String get outOfStock;

  String get goToCart;

  String get relatedProducts;

  String get additionalInformation;

  String get discount;

  String get couponCode;

  String get applyCoupon;

  String get cartTotals;

  String get proceedToCheckout;

  String get checkout;

  String get products;

  String get qty;

  String get billingAddress;

  String get selectPaymentMethod;

  String get paymentGatewaysNotFound;

  String get placeOrder;

  String get placeOrderText;

  String get orderDetails;

  String get lblOrderCancelledSuccessfully;

  String get lblCancelOrderMessageSix;

  String get lblCancelOrderMessageFive;

  String get lblCancelOrderMessageFour;

  String get lblCancelOrderMessageThree;

  String get lblCancelOrderMessageTwo;

  String get lblCancelOrderMessageOne;

  String get lblBill;

  String get lblStripeTestCredential;

  String get lblTodayIsHoliday;

  String get lblTotalTax;

  String get lblStart;

  String get lblJoin;

  String get lblTotalDoctors;

  String get lblTax;

  String get lblTaxRate;

  String get lblSubTotal;

  String get lblThisServiceAlreadyExistInClinic;

  String get lblPleaseSelectPayment;

  String get lblChargesIsNegative;

  String get lblServiceCategoryIsRequired;

  String get lblServiceNameIsRequired;

  String get lblDurationIsRequired;

  String get lblChargesIsRequired;

  String get lblNoLatestAppointmentFound;

  String get lblNoPendingAppointmentFound;

  String get lblNoCompletedAppointmentFound;

  String get lblNoCancelledAppointmentFound;

  String get clinicIdRequired;

  String get roleIsRequired;

  String get confirmPasswordIsRequired;

  String get passwordIsRequired;

  String get contactNumberIsRequired;

  String get lblSwipeLeftToEdit;

  String get lblNoEncounterFoundAtYourClinic;

  String get lblAvailableAtClinics;

  String get lblClinicsSelected;

  String get lblClinicsAvailable;

  String get lblSelectRole;

  String get lblPwdDoesNotMatch;

  String get lblSelectPaymentMethod;

  String get lblAmount;

  String get lblPaymentId;

  String get lblPaymentMethod;

  String get lblVPA;

  String get lblCardId;

  String get lblTransactionId;

  String get lblReportUpdatedSuccessfully;

  String get lblNoPrescriptionFound;

  String get lblNoNotesFound;

  String get lblNoObservationsFound;

  String get lblNoProblemFound;

  String get lblBookAppointment;

  String get lblDoYouWantToUpdateEncounter;

  String get lblDoYouWantToAddEncounter;

  String get lblDoYouWantToUpdateYourDetails;

  String get lblNoBillsFound;

  String get lblDoYouWantToDeleteProblem;

  String get lblDoYouWantToDeleteObservation;

  String get lblDoYouWantToDeleteNote;

  String get lblDoYouWantToDeleteDoctor;

  String get lblLoginSuccessfullyAsAPatient;

  String get lblLoginSuccessfullyAsAReceptionist;

  String get lblLoginSuccessfullyAsADoctor;

  String get lblSelectEncounterDate;

  String get lblSelectReportDate;

  String get lblSelectBirthDate;

  String get lblDoYouWantToLogout;

  String get lblDoYouWantToDeleteAccountPermanently;

  String get lblDoYouWantToDeleteSession;

  String get lblDoYouWantToAddSession;

  String get lblDoYouWantToUpdateSession;

  String get lblDoYouWantToChangeThePassword;

  String get lblDoYouWantToDeleteReview;

  String get lblDoYouWantToDeleteHolidayOf;

  String get lblDoYouWantToDeleteService;

  String get lblDoYouWantToUpdateService;

  String get lblDoYouWantToAddNewService;

  String get lblDoYouWantToUpdateAppointmentOf;

  String get lblDoYouWantToAddNewAppointmentFor;

  String get lblDoYouWantToDeleteAppointmentOf;

  String get lblDoYouWantToDeleteReport;

  String get lblDoYouWantToUpdateReport;

  String get lblDoYouWantToAddReport;

  String get lblDoYouWantToDeletePrescription;

  String get lblDoYouWantToUpdatePrescription;

  String get lblDoYouWantToAddPrescription;

  String get lblDoYouWantToSwitchYourClinicTo;

  String get lblDoYouWantToUpdatePatientDetails;

  String get lblDoYouWantToSaveNewPatientDetails;

  String get lblDoYouWantToUpdateDoctorDetails;

  String get lblDoYouWantToSaveNewDoctorDetails;

  String get lblDoYouWantToDeleteEncounterDetailsOf;

  String get lblDoYouWantToCheckoutAppointment;

  String get lblMultipleSelectionIsNotAvailableForThisService;

  String get lblTermsConditionSubTitle;

  String get lblYears;

  String get lblDeleteAccountSubTitle;

  String get lblThemeSubTitle;

  String get lblHelpAndSupportSubTitle;

  String get lblRateUsSubTitle;

  String get lblChangePasswordSubtitle;

  String get lblNoArticlesFound;

  String get lblNoSessionAvailable;

  String get lblTelemedServiceAvailable;

  String get lblAvailableDoctor;

  String get lblAvailableDoctors;

  String get lblWeekDaysDataNotFound;

  String get lblPleaseUploadReport;

  String get lblIncorrectPwd;

  String get lblPleaseChoose;

  String get lblPatientList;

  String get lblBillSwipe;

  String get lblViewDoctorMsg;

  String get lblMyAppointments;

  String get lblIsOnLeave;

  String get lblEditHolidayRestriction;

  String get lblNoAppointmentForThisDay;

  String get lblDoctorsSelected;

  String get lblDoctorAvailable;

  String get lblPending;

  String get lblPleaseTryAgainAfterSometimes;

  String get lblTapToSelect;

  String get lblDoctorTapMsg;

  String get lblCantFindClinicYouSearchedFor;

  String get lblCantFindDoctorYouSearchedFor;

  String get lblCantFindPatientYouSearchedFor;

  String get lblCantFindServiceYouSearchedFor;

  String get lblNoActiveClinicAvailable;

  String get lblRecheckPassword;

  String get lblDoctorsAvailable;

  String get lblSessionTapMsg;

  String get lblHolidayTapMsg;

  String get lblYourRating;

  String get lblSearchPatient;

  String get lblStayNotified;

  String get lblNotifications;

  String get lblNotificationSubTitle;

  String get lblGoodAfternoon;

  String get lblGoodEvening;

  String get lblGoodMorning;

  String get lblDr;

  String get lblNoActivePatientAvailable;

  String get lblNoActiveServicesAvailable;

  String get lblNoActiveDoctorAvailable;

  String get lblSearchServices;

  String get lblSearchDoctor;

  String get lblSearchClinic;

  String get lblTapMsg;

  String get lblTryIt;

  String get appName;

  String get lblRevenue;

  String get lblBuyIt;

  String get lblYouAreJustOneStepAwayFromHavingAHandsOnBackendDemo;

  String get lblChooseYourRole;

  String get lblEnterYourEmailAddressAsWellAsTheTemporaryLink;

  String get lblYouWillSeeAQRForAppOptionOnTheRightHandCorner;

  String get lblClickOnThatAndScanItFromTheApp;

  String get lblEnjoyTheFlawlessKivicareSystemWithEase;

  String get lblRemoveImage;

  String get lblCamera;

  String get lblGallery;

  String get lblCanNotBeEmpty;

  String get lblNoConnection;

  String get lblYourInternetConnectionWasInterrupted;

  String get lblPlease;

  String get lblRetry;

  String get lblGood;

  String get lblAfternoon;

  String get lblNight;

  String get lblNoSlotAvailable;

  String get lblPleaseChooseAnotherDay;

  String? get lblPleaseCloseTheEncounterToCheckoutPatient;

  String get lblRemove;

  String get lblAResetPasswordLinkWillBeSentToTheAboveEnteredEmailAddress;

  String get lblEnterYourEmailAddress;

  String get lblHowToGenerateQRCode;

  String get lblStepsToGenerateQRCode;

  String get lblOpenTheDemoUrlInWeb;

  String get lblMore;

  String get lblRatingsAndReviews;

  String get lblViewFile;

  String get lblLoading;

  String get lblAnErrorOccurredWhileCheckingInternetConnectivity;

  String get lblConnecting;

  String get lblYourReviews;

  String get lblNoReviewsFound;

  String get lblMyReports;

  String get lblMyClinic;

  String get lblBloodGroup;

  String get lblPleaseCheckYourNumber;

  String get lblChooseAction;

  String get lblConnected;

  String get lblNetworkStatus;

  String get lblOffline;

  String get lblUnknown;

  String get lblSelectAppointmentDate;

  String get lblScanToTest;

  String get lblAddNewAppointment;

  String get lblPleaseSelectPaymentStatus;

  String get lblWhatYourCustomersSaysAboutYou;

  String get lblPleaseSelectDoctor;

  String get lblChange;

  String get lblChangingStatusFrom;

  String get lblClose;

  String get lblAllTheAppointmentOnSelectedDateWillBeCancelled;

  String get lblToday;

  String get lblTomorrow;

  String get lblYesterday;

  String get lblJan;

  String get lblFeb;

  String get lblMar;

  String get lblApr;

  String get lblMay;

  String get lblJun;

  String get lblJul;

  String get lblAug;

  String get lblSep;

  String get lblOct;

  String get lblNov;

  String get lblDec;

  String get lblEnglish;

  String get lblAmharic;

  String get lblArabic;

  String get lblHindi;

  String get lblGerman;

  String get lblFrench;

  String get lblNoQualificationsFound;

  String get lblPaid;

  String get lblUnPaid;

  String get lblOpen;

  String get lblActive;

  String get lblInActive;

  String get lblScheduledHolidays;

  String get lblNotSelected;

  String get lblStatus;

  String get lblMultipleSelection;

  String get lblReport;

  String get lblAddedSuccessfully;

  String get lblMedicalHistoryHasBeen;

  String get lblAdded;

  String get lblSuccessfully;

  String get lblInvalidURL;

  String get lblInvalidDayOfMonth;

  String get lblConnectionReEstablished;

  String get lblToWifi;

  String get lblToMobileData;

  String get lblNote;

  String get lblMultipleSelectionIsAvailableForThisService;

  String get lblToCloseTheEncounterInvoicePaymentIsMandatory;

  String get lblUpdate;

  String get lblBillDetails;

  String get lblChooseImage;

  String get lblMonthly;

  String get lblWeekly;

  String get lblYearly;

  String get lblJanuary;

  String get lblFebruary;

  String get lblMarch;

  String get lblApril;

  String get lblJune;

  String get lblJuly;

  String get lblAugust;

  String get lblSeptember;

  String get lblOctober;

  String get lblNovember;

  String get lblDecember;

  String get lblChangeSignature;

  String get lblClear;

  String get lblUndo;

  String get lblSignature;

  String get lblAdd;

  String get lblSelectYearOfGraduation;

  String get lblSelect;

  String get lblPayBill;

  String get lblPleaseCheckYourEmailInboxToSetNewPassword;

  String get lblReview;

  String get lblBillingRecords;

  String get lblAppointmentCount;

  String get lblNoRecordsFound;

  String get lblNoAppointmentsFound;

  String get lblClosed;

  String get lblSelectPatient;

  String get lblNoReportsFound;

  String get lblSpecialities;

  String get lblKnowWhatYourPatientsSaysAboutYou;

  String get lblSchedule;

  String get lblNo;

  String get lblAllowMultiSelectionWhileBooking;

  String get lblSetStatus;

  String get lblFound;

  String get lblDeletedSuccessfully;

  String get lblDUpdatedSuccessfully;

  String? get lblPleaseGiveYourRating;

  String get lblEnterYourReviews;

  String get lblUnAuthorized;

  String get lblIsThisATelemedService;

  String get lblTelemedService;

  String get lblStayConnected;

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

  String get lblBasicDetails;

  String get lblOtherDetails;

  String get lblSubmit;

  String get lblFirstName;

  String get lblLastName;

  String get lblContactNumber;

  String get lblDOB;

  String get lblSelectBloodGroup;

  String get lblAddress;

  String get lblCity;

  String get lblCountry;

  String get lblPostalCode;

  String get lblSettings;

  String get lblChangePassword;

  String get lblTermsAndCondition;

  String get lblLanguage;

  String get lblAboutUs;

  String get lblRateUs;

  String get lblSave;

  String get lblDegree;

  String get lblUniversity;

  String get lblYear;

  String get lblSearch;

  String get lblCancel;

  String get lblDoctor;

  String get lblDescription;

  String get lblPrescription;

  String get lblFrequency;

  String get lblDuration;

  String get lblInstruction;

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

  String get lblWeeklyAppointments;

  String get lblTodaySAppointments;

  String get lblAppointmentDeleted;

  String get lblDate;

  String get lblConfirmAppointment;

  String get lblSelectDateTime;

  String get lblSelectServices;

  String get lblBook;

  String get lblNoAppointmentForToday;

  String get lblCheckIn;

  String get lblCheckOut;

  String get lblAreDeleteAppointment;

  String get lblYouCannotStart;

  String get lblPrescriptionAdded;

  String get lblUpdatedSuccessfully;

  String get lblPrescriptionDeleted;

  String get lblAddPrescription;

  String get lblName;

  String get lblPrescriptionDurationIsRequired;

  String get lblDurationInDays;

  String get lblAddNewPrescription;

  String get lblEditPrescriptionDetail;

  String get lblDays;

  String get lblAppointmentIsConfirmed;

  String get lblThanksForBooking;

  String get lblAppointmentConfirmation;

  String get lblNoPatientFound;

  String get lblDeleteRecordConfirmation;

  String get lblAllRecordsFor;

  String get lblAreDeleted;

  String get lblEncounters;

  String get lblDelete;

  String get lblMale;

  String get lblFemale;

  String get lblOther;

  String get lblMinimumAgeRequired;

  String get lblCurrentAgeIs;

  String get lblGender1;

  String get lblSpecialization;

  String get lblExperience;

  String get lblAPIKeyCannotBeEmpty;

  String get lblAPIKey;

  String get lblAPISecret;

  String get lblAPISecretCannotBeEmpty;

  String get lblSignUpOrSignIn;

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

  String get lblEncounterWillBeClosed;

  String get lblEncounterDate;

  String get lblClinicName;

  String get lblDoctorName;

  String get lblDesc;

  String get lblAddNewQualification;

  String get lblAddBillItem;

  String get lblServiceIsRequired;

  String get lblOne;

  String get lblQuantity;

  String get lblTotal;

  String get lblEncounterUpdated;

  String get lblAddNewEncounter;

  String get lblEditEncounterDetail;

  String get lblHolidayOf;

  String get lblModuleIsRequired;

  String get lblScheduleDate;

  String get lblLeaveFor;

  String get lblAddHoliday;

  String get lblEditHolidays;

  String get lblNewPatientAddedSuccessfully;

  String get lblPatientDetailUpdatedSuccessfully;

  String get lblBasicInformation;

  String get lblAddressDetail;

  String get lblFirstNameIsRequired;

  String get lblLastNameIsRequired;

  String get lblEmailIsRequired;

  String get lblAddNewPatient;

  String get lblEditPatientDetail;

  String get lblCategory;

  String get lblCharges;

  String get lblSelectDoctor;

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

  String get lblPatientNameIsRequired;

  String get lblDoctorSessions;

  String get lblEditProfile;

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

  String get lblHolidays;

  String get lblClinic;

  String get lblAfter;

  String get lblWasOffFor;

  String get lblYourHolidays;

  String get lblNoServicesFound;

  String get lblNoDataFound;

  String get lblOn;

  String get lblOff;

  String get lblNoAppointments;

  String get lblSelectClinic;

  String get lblEnter;

  String get lblFieldIsRequired;

  String get lblHoliday;

  String get lblClinicHoliday;

  String get lblSessions;

  String get lblClinicSessions;

  String get lblClinicServices;

  String get lblVideoConsulting;

  String get lblYourEncounters;

  String get lblYourReports;

  String get lblYourBills;

  String get lblMyBills;

  String get lblBillRecords;

  String get lblChangeYourClinic;

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

  String get lblGeneralSetting;

  String get lblAppSettings;

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

  String get lblComplete;

  String get lblCancelled;

  String get lblYes;

  String get lblPayment;

  String get lblError;

  String get lblRegisteredSuccessfully;

  String get lblBirthDateIsRequired;

  String get lblBloodGroupIsRequired;

  String get lblAppointmentBookedSuccessfully;

  String get lblSelectedSlots;

  String get lblSession;

  String get lblTimeSlotIsBooked;

  String get lblAppointmentDate;

  String get lblViewDetails;

  String get lblDoctorDetails;

  String get lblAreYouWantToDeleteDoctor;

  String get lblDoctorDeleted;

  String get lblYearsExperience;

  String get lblYearsOfExperience;

  String get lblAvailableOn;

  String get lblHealth;

  String get lblReadMore;

  String get lblReadLess;

  String get lblBy;

  String get lblNews;

  String get lblUpcomingAppointments;

  String get lblViewAll;

  String get lblTopDoctors;

  String get lblExpertsHealthTipsAndAdvice;

  String get lblArticlesByHighlyQualifiedDoctors;

  String get lblChooseYourDoctor;

  String get lblSelectOneDoctor;

  String get lblClinicDoctor;

  String get lblPatientDashboard;

  String get lblFeedsAndArticles;

  String get lblPatientsEncounter;

  String get lblNoEncounterFound;

  String get lblSelectSpecialization;

  String get lblAddDoctorProfile;

  String get lblMedicalReport;

  String get lblNewMedicalReport;

  String get lblRememberMe;

  String get lblChooseYourClinic;

  String get lblChooseYourFavouriteClinic;

  String get lblServicesYouProvide;

  String get lblGetYourAllBillsHere;

  String get lblYourAllEncounters;

  String get lblAvailableSession;

  String get lblAll;

  String get lblLatest;

  String get lblMon;

  String get lblTue;

  String get lblWed;

  String get lblThu;

  String get lblFri;

  String get lblSat;

  String get lblSun;

  String get lblNoReportWasSelected;

  String get lblAddReportScreen;

  String get lblDateCantBeNull;

  String get lblUploadReport;

  String get lblLight;

  String get lblDark;

  String get lblSystemDefault;

  String get lblNA;

  String get lblAddedNewEncounter;

  String get lblCantEditDate;

  String get lblNoTitle;

  String get lblSelectOneClinic;

  String get lblPast;

  String get lblSunday;

  String get lblMonday;

  String get lblTuesday;

  String get lblWednesday;

  String get lblThursday;

  String get lblFriday;

  String get lblSaturday;

  String get lblAddMedicalReport;

  String get lblSendPrescriptionOnMail;

  String get lblFilesSelected;

  String get lblService;

  String get lblTime;

  String get lblAppointmentSummary;

  String get lblEncounter;

  String get lblMedicalReports;

  String get lblConnectedWith;

  String get lblContact;

  String get lblQrScanner;

  String get lblLoginSuccessfully;

  String get lblWrongUser;

  String get lblMorning;

  String get lblEvening;

  String get lblShare;

  String get lblNoMatch;

  String get lblNoDataSubTitle;

  String get lblEdit;

  String get lblSwipeMassage;

  String get lblReachUsMore;

  String get lblDeleteAccount;

  String get lblNoInternetMsg;

  String get lblConnectedToInternet;

  String get lblDeleteAccountNote;

  String get lblSomethingWentWrong;
}
