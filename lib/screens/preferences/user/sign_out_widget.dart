import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/components/app_snackbar.dart';
import '../../../core/dialogs/confirmation_dialog.dart';
import '../../../core/utils/app_localisations.dart';
import '../../../routes/app_router.dart';
import '../../../services/api/api_service.dart';
import '../../../services/auth/auth_providers.dart';

class SignOutWidget extends ConsumerStatefulWidget {
  const SignOutWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignOutWidgetState();
}

class _SignOutWidgetState extends ConsumerState<SignOutWidget> {
  late final _locale = AppLocalizations.of(context)!;
  bool _loading = false;

  void _signOut() async {
    if (_loading) {
      return;
    }
    final confirmed = await showConfirmationDialog(context: context);
    if (!confirmed) {
      return;
    }
    _setLoading(true);
    try {
      final signedOut = await ref
          .read(AuthProviders.service)
          .logout()
          .onError((e, _) => false);
      if (signedOut) {
        return _toLogin();
      }
      // If signed out is false, the server has responded to our request but it was not successful.
      // TODO: Do we know what the server would return if not a success message?
      _signOutFailed(_locale.serverErrorMessage);
    } on ApiException catch (e) {
      _signOutFailed(e.message);
    }
  }

  void _toLogin() {
    if (mounted) {
      return AppRouter.toLogin(context);
    }
  }

  void _signOutFailed(String e) {
    if (mounted) {
      AppSnackbar.warning(
        context: context,
        message: _locale.signOutFailed(e),
      );
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
    return ListTile(
      title: Text(_locale.signOut),
      trailing: IconButton(
        onPressed: _signOut,
        icon: _loading
            ? const SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.logout),
      ),
      onTap: _signOut,
    );
  }
}
