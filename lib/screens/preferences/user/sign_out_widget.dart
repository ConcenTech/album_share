import 'package:album_share/core/components/app_snackbar.dart';
import 'package:album_share/core/dialogs/confirmation_dialog.dart';
import 'package:album_share/core/utils/extension_methods.dart';
import 'package:album_share/routes/app_router.dart';
import 'package:album_share/services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignOutWidget extends ConsumerStatefulWidget {
  const SignOutWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignOutWidgetState();
}

class _SignOutWidgetState extends ConsumerState<SignOutWidget> {
  bool _loading = false;

  void _signOut() async {
    if (_loading){
      return;
    }
    final confirmed = await showConfirmationDialog(context: context);
    if (!confirmed) {
      return;
    }
    _setLoading(true);
    final signedOut = await ref.read(AuthProviders.service).logout();
    if (signedOut) {
      return _toLogin();
    }
    _signOutFailed();
    _setLoading(false);
  }

  void _toLogin() {
    if (mounted) {
      return AppRouter.toLogin(context);
    }
  }

  void _signOutFailed() {
    if (mounted) {
      AppSnackbar.warning(
          context: context,
          message: 'Failed to sign out, an unknown error occurred.');
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
      title: const Text('Sign out'),
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
