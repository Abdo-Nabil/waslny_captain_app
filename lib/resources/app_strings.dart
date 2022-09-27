class AppStrings {
  //---------------Shared preferences keys
  static const String storedLocale = 'storedLocale';
  static const String storedRoute = 'storedRoute';
  static const String isLightTheme = 'isLightTheme';
  static const String storedToken = 'storedToken';

  //---------------On boarding
  static const String done = 'done';
  static const String skip = 'skip';

  //---------------Authentication
  static const String loginAsAUser = 'loginAsAUser';
  static const String phoneNumber = 'phoneNumber';
  static const String login = 'login';
  static const String dontHaveAccount = 'dontHaveAccount';
  static const String registerNow = 'registerNow';
  static const String registerANewUser = 'registerANewUser';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';
  static const String loginNow = 'loginNow';
  static const String register = 'register';
  static const String username = 'username';
  static const String enterYourName = 'enterYourName';
  static const String enterYourPhone = 'enterYourPhone';
  static const String enterValidPhone = 'enterValidPhone';
  static const String loading = 'loading';
  static const String verify = 'verify';
  static const String phoneNumberVerification = 'phoneNumberVerification';
  static const String enterTheCodeSent = 'enterTheCodeSent';
  static const String didntRecieveTheCode = 'didntRecieveTheCode';
  static const String resend = 'resend';
  static const String countryCode = '+20';
  static const String plus20English = '+20';
  static const String plus20Arabic = '20+';
  static const String stars = '*********';
  static const String invalidSMS = 'invalidSMS';
  static const String alert = 'alert';
  static const String internetConnectionError = 'internetConnectionError';
  static const String someThingWentWrong = 'someThingWentWrong';
  static const String ok = 'ok';
  static const String emptyValue = 'emptyValue';
  static const String enterAllDigits = 'enterAllDigits';
  static const String savingTokenError = 'savingTokenError';

  //--------------- FireStore
  static const String usersCollection = 'users';

  //--------------- home screen
  static const String requestCar = 'requestCar';
  static const String from = 'from';
  static const String to = 'to';
  static const String whereToGo = 'whereToGo';
  static const String pickUpLocation = 'pickUpLocation';
  static const String dropOffLocation = 'dropOffLocation';
  static const String givePermission = 'givePermission';
  static const String locationServicesDisabled = 'locationServicesDisabled';
  static const String locationPermissionsDenied = 'locationPermissionsDenied';
  static const String locationPermissionsDeniedForEver =
      'locationPermissionsDeniedForEver';
  static const String notFoundLocation = 'notFoundLocation';
  static const String searchForLocation = 'searchForLocation';
  static const String startPosition = 'startPosition';
  static const String endPosition = 'endPosition';
  static const String myCurrentLocation = 'myCurrentLocation';
  static const String myLocation = 'myLocation';

  //
  //

  //
  //
  static const notFoundPage = "notFoundPage";
  static const appName = "appName";
  static const appName_for_recent_app = "Waslny User";

  static const onBoardingTitle1 = "on_boarding_title1";
  static const onBoardingTitle2 = "on_boarding_title2";
  static const onBoardingTitle3 = "on_boarding_title3";
  static const onBoardingTitle4 = "on_boarding_title4";

  static const onBoardingSubTitle1 = "on_boarding_desc1";
  static const onBoardingSubTitle2 = "on_boarding_desc2";
  static const onBoardingSubTitle3 = "on_boarding_desc3";
  static const onBoardingSubTitle4 = "on_boarding_desc4";
  static const password = "password_hint";
  static const usernameError = "username_error";
  static const passwordError = "password_error";
  static const forgetPassword = "forgot_password_text";
  static const registerText = "register_text";
  static const retryAgain = "retry_again";
  static const String emailHint = 'email_hint';
  static const String invalidEmail = "email_error";
  static const String resetPassword = "reset_password";
  static const String success = "success";
  static const String userNameInvalid = "username_hint_message";
  static const String mobileNumberInvalid = "mobile_number_hint_message";
  static const String passwordInvalid = "password_hint_message";
  static const mobileNumber = "mobile_number_hint";
  static const profilePicture = "upload_profile_picture";
  static const photoGallery = "photo_from_galley";
  static const photoCamera = "photo_from_camera";
  static const home = "home";
  static const notifications = "notification";
  static const search = "search";
  static const settings = "settings";
  static const services = "services";
  static const stores = "stores";
  static const String details = "details";
  static const String about = "about";
  static const String storeDetails = "store_details";
  static const String changeLanguage = "change_language";
  static const String contactUs = "contact_us";
  static const String inviteYourFriends = "invite_your_friends";
  static const String logout = "logout";

  // error handler
  static const String SERVER_FAILURE_MESSAGE = 'Please try again later .';
  static const String EMPTY_CACHE_FAILURE_MESSAGE = 'No Data';
  static const String OFFLINE_FAILURE_MESSAGE =
      'Please Check your Internet Connection';
  static const ADD_SUCCESS_MESSAGE = "Post Added Successfully";
  static const DELETE_SUCCESS_MESSAGE = "Post Deleted Successfully";
  static const UPDATE_SUCCESS_MESSAGE = "Post Updated Successfully";

  static const String wordTranslationNotFound =
      '**** Exception **** Word Translation Not Found ****';
  static const String badRequestError = "bad_request_error";
  static const String noContent = "no_content";
  static const String forbiddenError = "forbidden_error";
  static const String unauthorizedError = "unauthorized_error";
  static const String notFoundError = "not_found_error";
  static const String conflictError = "conflict_error";
  static const String internalServerError = "internal_server_error";
  static const String unknownError = "unknown_error";
  static const String timeoutError = "timeout_error";
  static const String defaultError = "default_error";
  static const String cacheError = "cache_error";
  static const String noInternetError = "no_internet_error";
}
