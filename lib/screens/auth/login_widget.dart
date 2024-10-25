import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_snackbar.dart';
import '../../core/utils/app_localisations.dart';
import '../../core/utils/validators.dart';
import '../../models/user.dart';
import '../../services/api/api_service.dart';
import '../../services/auth/auth_providers.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({
    required this.onBack,
    required this.onLoginComplete,
    super.key,
  });

  final VoidCallback onBack;
  final void Function(User user) onLoginComplete;

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  String _email = '';
  String _password = '';

  void _login() async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      return;
    }

    _setLoading(true);

    form.save();

    await ref
        .read(AuthProviders.service)
        .login(_email, _password)
        .then(widget.onLoginComplete)
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              initialValue: _email,
              validator: Validators.email,
              onSaved: (v) => _email = v!,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: locale.email,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _password,
              obscureText: true,
              validator: Validators.required,
              onSaved: (v) => _password = v!,
              textInputAction: TextInputAction.done,
              onEditingComplete: _login,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: locale.password,
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
                  onPressed: widget.onBack,
                  child: Text(locale.back),
                ),
                FilledButton.icon(
                  label: Text(
                    locale.login,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  icon: const Icon(Icons.arrow_right_alt),
                  iconAlignment: IconAlignment.end,
                  onPressed: _loading ? null : _login,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
