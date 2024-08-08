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
      return AppLocale.instance.current.invalidValueError;
    }

    return null;
  }

  static final password = MultiValidator(
    [
      RequiredValidator(errorText: AppLocale.instance.current.required),
      MinLengthValidator(
        6,
        errorText: AppLocale.instance.current.invalidPasswordLengthError,
      ),
      PatternValidator(r'(?=.*?[#?!@$%^&*-=])',
          errorText: AppLocale.instance.current.invalidPasswordError),
    ],
  ).call;

  static final email = MultiValidator([
    RequiredValidator(errorText: AppLocale.instance.current.required),
    optionalEmail,
  ]).call;

  static final optionalEmail =
      EmailValidator(errorText: AppLocale.instance.current.invalidEmailError);

  static String? passwordMatch(
      {required String? value1, required String? value2}) {
    if (value1 != value2) {
      return AppLocale.instance.current.invalidPasswordMatchError;
    }
    return null;
  }
}
