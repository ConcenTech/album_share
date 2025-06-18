// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Album share';

  @override
  String get appTagLine => 'An unofficial Immich client.';

  @override
  String get theme => 'Theme';

  @override
  String get groupBy => 'Group by';

  @override
  String get automatic => 'Auto';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get required => 'Required';

  @override
  String get success => 'Success';

  @override
  String get areYouSure => 'Are you sure';

  @override
  String get signOut => 'Sign out';

  @override
  String get confirm => 'Okay';

  @override
  String get cancel => 'Cancel';

  @override
  String get invalidValueError => 'Invalid value';

  @override
  String get invalidPasswordLengthError => 'Invalid password';

  @override
  String get invalidPasswordMatchError => 'Passwords must match';

  @override
  String get passwordSameAsOldError =>
      'New password cannot be the same as the old password';

  @override
  String get invalidEmailError => 'Please enter a valid email';

  @override
  String get serverUrl => 'Server url';

  @override
  String get next => 'Next';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get newPassword => 'New password';

  @override
  String get back => 'Back';

  @override
  String get login => 'login';

  @override
  String get buildingLibrary => 'Please wait. Building library';

  @override
  String get dynamicLayout => 'Dynamic layout';

  @override
  String get day => 'Day';

  @override
  String get month => 'Month';

  @override
  String get none => 'None';

  @override
  String get loopVideos => 'Loop videos';

  @override
  String get thumbnailWidth => 'Thumbnail width';

  @override
  String get loadOriginalImage => 'Load original image';

  @override
  String get loadOriginalImageDescription =>
      'Enable to load the original full-resolution image (large!).\nDisable to reduce data usage (both network and on device cache).';

  @override
  String get loadPreviewImage => 'Load preview image';

  @override
  String get loadPreviewImageDescription =>
      'Enable to load a medium-resolution image.\nDisable to either directly load the original or only use the thumbnail.';

  @override
  String get enableHaptics => 'Enable haptic feedback';

  @override
  String get changePassword => 'Change password';

  @override
  String get serverErrorMessage => 'A server error occurred';

  @override
  String signOutFailed(String error) {
    return 'Failed to sign out, $error';
  }

  @override
  String get preferences => 'Preferences';

  @override
  String get assetsThumbnails => 'Assets & thumbnails';

  @override
  String get user => 'User';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get appInitError => 'Error initialising application';

  @override
  String get logs => 'Logs';

  @override
  String get close => 'Close';

  @override
  String get clipboardSave => 'Saved to clipboard';

  @override
  String get support => 'Support';

  @override
  String get syncFrequency => 'Sync Frequency';

  @override
  String get syncFrequencyDescription =>
      'How often to check for new assets and activity when the app is open.';

  @override
  String get fiveMinutes => '5 Minutes';

  @override
  String get fifteenMinutes => '15 Minutes';

  @override
  String get thirtyMinutes => '30 Minutes';

  @override
  String get oneHour => '1 Hour';

  @override
  String get twoHours => '2 Hours';

  @override
  String get fourHours => '4 Hours';

  @override
  String get eightHours => '8 Hours';

  @override
  String get twelveHours => '12 Hours';

  @override
  String get backgroundSync => 'Background Sync';

  @override
  String get backgroundSyncDescription =>
      'Allow checking for new assets and activity when the app is closed.';

  @override
  String get batteryOptimisations => 'Battery optimisations';

  @override
  String get batteryOptimisationsMessage =>
      'Some Android manufacturers prefer battery life over proper app functionality. \n\nIt is recommended you disable battery optimisations for Album Share to ensure background sync can be performed and notifications are delivered as expected. \n\nFor more information, please visit:';

  @override
  String get save => 'Save';

  @override
  String userUploadedOther(int count, String user) {
    return '$user uploaded $count new items.';
  }

  @override
  String userUploadedImages(int count, String user) {
    return '$user uploaded $count new images.';
  }

  @override
  String userUploadedVideos(int count, String user) {
    return '$user uploaded $count new videos.';
  }

  @override
  String get newActivityNotification => 'New activity';

  @override
  String get newAssetsNotification => 'New content';

  @override
  String userLikedImages(int count, String user) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images',
      one: 'an image',
    );
    return '$user liked $_temp0.';
  }

  @override
  String userLikedVideos(int count, String user) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos',
      one: 'a video',
    );
    return '$user liked $_temp0.';
  }

  @override
  String userLikedOther(int count, String user) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: 'an item',
    );
    return '$user liked $_temp0.';
  }

  @override
  String userCommentedImages(int count, String user) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images',
      one: 'an image',
    );
    return '$user commented on $_temp0.';
  }

  @override
  String userCommentedVideos(int count, String user) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos',
      one: 'a video',
    );
    return '$user commented on $_temp0.';
  }

  @override
  String userCommentedOther(int count, String user) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: 'an item',
    );
    return '$user commented on $_temp0.';
  }

  @override
  String get noActivity => 'No activity yet.';

  @override
  String get message => 'Message';
}
