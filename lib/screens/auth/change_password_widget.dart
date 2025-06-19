import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_snackbar.dart';
import '../../core/utils/app_localisations.dart';
import '../../core/utils/validators.dart';
import '../../routes/app_router.dart';
import '../../services/api/api_service.dart';
import '../../services/auth/auth_providers.dart';

class ChangePasswordWidget extends ConsumerStatefulWidget {
  const ChangePasswordWidget({
    required this.onLogout,
    required this.onComplete,
    super.key,
  });

  /// Called if the user cannot reset password (different user?)
  ///
  /// When this is called, the user has already been logged out.
  final VoidCallback onLogout;
  final VoidCallback onComplete;

  @override
  ConsumerState<ChangePasswordWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<ChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();

  late final bool _mustChangePassword;

  bool _loading = false;

  String _password = '';
  String _newPassword = '';

  @override
  void initState() {
    super.initState();
    _mustChangePassword =
        ref.read(AuthProviders.userStream).value?.shouldChangePassword ?? false;
  }

  void _onBack() {
    if (_mustChangePassword) {
      _logout();
    } else {
      AppRouter.back(context);
    }
  }

  void _logout() async {
    _setLoading(true);

    await ref
        .read(AuthProviders.service) //
        .logout()
        .then<void>((bool loggedOut) => //
            loggedOut //
                ? widget.onLogout()
                : _onError('Failed to logout'))
        .onError((ApiException e, _) => //
            _onError(e.message));
  }

  void _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      return;
    }

    _setLoading(true);

    form.save();

    await ref
        .read(AuthProviders.service)
        .changePassword(_password, _newPassword)
        .then((_) => widget.onComplete())
        .onError((ApiException e, _) => _onError(e.message));
  }

  void _onError(String message) {
    if (mounted) {
      setState(() {
        _loading = false;
      });
      AppSnackbar.warning(context: context, message: message);
    }
  }

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _loading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.changePassword),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              validator: Validators.password,
              onSaved: (v) => _password = v!,
              onChanged: (v) => _password = v,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: locale.password,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              validator: (v) => Validators.newPassword(_password, v),
              onChanged: (v) => _newPassword = v,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: locale.newPassword,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              validator: (value) => Validators.passwordMatch(
                value1: value,
                value2: _newPassword,
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: locale.newPassword,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _onBack,
                  child:
                      Text(_mustChangePassword ? locale.signOut : locale.back),
                ),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(
                    locale.save,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
