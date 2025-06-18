import 'package:album_share/l10n/app_localizations.dart' as al;

/// Convenience typedef.
///
/// AppLocalizations package is not imported by autocomplete.
typedef AppLocalizations = al.AppLocalizations;

class AppLocale {
  static AppLocale? _instance;

  AppLocale._();

  static AppLocale get instance {
    return _instance ??= AppLocale._();
  }

  AppLocalizations? _current;
  AppLocalizations get current {
    assert(
      _current != null,
      'Current locale has not been set. '
      'Call the set method before attempting to access the current locale.',
    );
    return _current!;
  }

  void set(AppLocalizations locale) {
    _current = locale;
  }
}
