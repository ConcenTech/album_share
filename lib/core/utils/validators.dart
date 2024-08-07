import 'package:form_field_validator/form_field_validator.dart';

import 'app_localisations.dart';

class Validators {
  // static final required = RequiredValidator(errorText: kRequired);
  static const required = _requiredValidator;

  static String? _requiredValidator(Object? value) {
    final locale = AppLocale.instance.current;
    if (value is String) {
      return value.isEmpty ? locale.required : null;
    }
    return value == null ? locale.required : null;
  }

  static String? requiredInt(String? value) {
    if (value == null) {
      return AppLocale.instance.current.required;
    }

    if (int.tryParse(value) == null) {
      return 'Invalid value';
    }

    return null;
  }

  static final password = MultiValidator(
    [
      RequiredValidator(errorText: AppLocale.instance.current.required),
      MinLengthValidator(
        6,
        errorText: 'Password must be at least 6 digits long',
      ),
      PatternValidator(
        r'(?=.*?[#?!@$%^&*-=])',
        errorText: 'Passwords must have at least one special character',
      ),
    ],
  ).call;

  static final postcode = MultiValidator([
    RequiredValidator(errorText: AppLocale.instance.current.required),
    PatternValidator(
      r'^([A-Z]{1,2}\d{1,2}[A-Z]?)\s*(\d[A-Z]{2})$',
      errorText: 'Not a valid postcode',
    ),
  ]);

  static final email = MultiValidator([
    RequiredValidator(errorText: AppLocale.instance.current.required),
    optionalEmail,
  ]).call;

  static final optionalEmail =
      EmailValidator(errorText: 'Please enter a valid email');

  static String? passwordMatch(
      {required String? value1, required String? value2}) {
    if ((value1 ?? '1') != (value2 ?? '2')) {
      return 'Passwords must match';
    }
    return null;
  }

  static String? numberMaxLength(
      {required String? value, required double max}) {
    if (value == null) {
      return AppLocale.instance.current.required;
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Error';
    }
    if (number > max) {
      return 'Value too high';
    }
    return null;
  }
}
