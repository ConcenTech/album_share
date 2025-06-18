import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application name.
  ///
  /// In en, this message translates to:
  /// **'Album share'**
  String get appTitle;

  /// A short description of the application
  ///
  /// In en, this message translates to:
  /// **'An unofficial Immich client.'**
  String get appTagLine;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @groupBy.
  ///
  /// In en, this message translates to:
  /// **'Group by'**
  String get groupBy;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get automatic;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Confirmation question
  ///
  /// In en, this message translates to:
  /// **'Are you sure'**
  String get areYouSure;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// The user passed an invalid value into an integer text field so it could not be parsed
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get invalidValueError;

  /// The user entered a password that was less than 8 digits long
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPasswordLengthError;

  /// The user entered two passwords that were not the same
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get invalidPasswordMatchError;

  /// The user tried to use the same password on the change password form
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as the old password'**
  String get passwordSameAsOldError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmailError;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server url'**
  String get serverUrl;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get login;

  /// No description provided for @buildingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Please wait. Building library'**
  String get buildingLibrary;

  /// No description provided for @dynamicLayout.
  ///
  /// In en, this message translates to:
  /// **'Dynamic layout'**
  String get dynamicLayout;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @loopVideos.
  ///
  /// In en, this message translates to:
  /// **'Loop videos'**
  String get loopVideos;

  /// No description provided for @thumbnailWidth.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail width'**
  String get thumbnailWidth;

  /// No description provided for @loadOriginalImage.
  ///
  /// In en, this message translates to:
  /// **'Load original image'**
  String get loadOriginalImage;

  /// No description provided for @loadOriginalImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable to load the original full-resolution image (large!).\nDisable to reduce data usage (both network and on device cache).'**
  String get loadOriginalImageDescription;

  /// No description provided for @loadPreviewImage.
  ///
  /// In en, this message translates to:
  /// **'Load preview image'**
  String get loadPreviewImage;

  /// No description provided for @loadPreviewImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable to load a medium-resolution image.\nDisable to either directly load the original or only use the thumbnail.'**
  String get loadPreviewImageDescription;

  /// No description provided for @enableHaptics.
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback'**
  String get enableHaptics;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred'**
  String get serverErrorMessage;

  /// No description provided for @signOutFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign out, {error}'**
  String signOutFailed(String error);

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @assetsThumbnails.
  ///
  /// In en, this message translates to:
  /// **'Assets & thumbnails'**
  String get assetsThumbnails;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @appInitError.
  ///
  /// In en, this message translates to:
  /// **'Error initialising application'**
  String get appInitError;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @clipboardSave.
  ///
  /// In en, this message translates to:
  /// **'Saved to clipboard'**
  String get clipboardSave;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @syncFrequency.
  ///
  /// In en, this message translates to:
  /// **'Sync Frequency'**
  String get syncFrequency;

  /// No description provided for @syncFrequencyDescription.
  ///
  /// In en, this message translates to:
  /// **'How often to check for new assets and activity when the app is open.'**
  String get syncFrequencyDescription;

  /// No description provided for @fiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'5 Minutes'**
  String get fiveMinutes;

  /// No description provided for @fifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'15 Minutes'**
  String get fifteenMinutes;

  /// No description provided for @thirtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'30 Minutes'**
  String get thirtyMinutes;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// No description provided for @twoHours.
  ///
  /// In en, this message translates to:
  /// **'2 Hours'**
  String get twoHours;

  /// No description provided for @fourHours.
  ///
  /// In en, this message translates to:
  /// **'4 Hours'**
  String get fourHours;

  /// No description provided for @eightHours.
  ///
  /// In en, this message translates to:
  /// **'8 Hours'**
  String get eightHours;

  /// No description provided for @twelveHours.
  ///
  /// In en, this message translates to:
  /// **'12 Hours'**
  String get twelveHours;

  /// No description provided for @backgroundSync.
  ///
  /// In en, this message translates to:
  /// **'Background Sync'**
  String get backgroundSync;

  /// No description provided for @backgroundSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow checking for new assets and activity when the app is closed.'**
  String get backgroundSyncDescription;

  /// No description provided for @batteryOptimisations.
  ///
  /// In en, this message translates to:
  /// **'Battery optimisations'**
  String get batteryOptimisations;

  /// A message to warn the users about restrictions some Android manufacturers apply to background processes
  ///
  /// In en, this message translates to:
  /// **'Some Android manufacturers prefer battery life over proper app functionality. \n\nIt is recommended you disable battery optimisations for Album Share to ensure background sync can be performed and notifications are delivered as expected. \n\nFor more information, please visit:'**
  String get batteryOptimisationsMessage;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @userUploadedOther.
  ///
  /// In en, this message translates to:
  /// **'{user} uploaded {count} new items.'**
  String userUploadedOther(int count, String user);

  /// No description provided for @userUploadedImages.
  ///
  /// In en, this message translates to:
  /// **'{user} uploaded {count} new images.'**
  String userUploadedImages(int count, String user);

  /// No description provided for @userUploadedVideos.
  ///
  /// In en, this message translates to:
  /// **'{user} uploaded {count} new videos.'**
  String userUploadedVideos(int count, String user);

  /// Title for notifications about new activity
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get newActivityNotification;

  /// Title for notifications about newly assets uploaded
  ///
  /// In en, this message translates to:
  /// **'New content'**
  String get newAssetsNotification;

  /// Notify the user that somebody liked a number images. (Specifically A image not THEIR image)
  ///
  /// In en, this message translates to:
  /// **'{user} liked {count, plural, =1{an image} other{{count} images}}.'**
  String userLikedImages(int count, String user);

  /// Notify the user that somebody liked a number of videos. (Specifically A video not THEIR video)
  ///
  /// In en, this message translates to:
  /// **'{user} liked {count, plural, =1{a video} other{{count} videos}}.'**
  String userLikedVideos(int count, String user);

  /// Notify the user that somebody liked a number of assets of any type.
  ///
  /// In en, this message translates to:
  /// **'{user} liked {count, plural, =1{an item} other{{count} items}}.'**
  String userLikedOther(int count, String user);

  /// Notify the user that somebody commented on number of images.
  ///
  /// In en, this message translates to:
  /// **'{user} commented on {count, plural, =1{an image} other{{count} images}}.'**
  String userCommentedImages(int count, String user);

  /// Notify the user that somebody commented on number of videos.
  ///
  /// In en, this message translates to:
  /// **'{user} commented on {count, plural, =1{a video} other{{count} videos}}.'**
  String userCommentedVideos(int count, String user);

  /// Notify the user that somebody commented on a number of assets of any type.
  ///
  /// In en, this message translates to:
  /// **'{user} commented on {count, plural, =1{an item} other{{count} items}}.'**
  String userCommentedOther(int count, String user);

  /// A message when the activity list is empty
  ///
  /// In en, this message translates to:
  /// **'No activity yet.'**
  String get noActivity;

  /// Label for the message text field
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
