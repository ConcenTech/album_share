import 'package:flutter/material.dart';

import '../../core/components/logo_widget.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../routes/app_router.dart';
import 'change_password_widget.dart';
import 'endpoint_widget.dart';
import 'login_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    this.passwordChange = false,
    super.key,
  });

  static const id = 'auth_screen';

  final bool passwordChange;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      id: id,
      showTitleBar: false,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LogoImageText(),
                  const SizedBox(height: 10),
                  AuthScreenContent(passwordChange: passwordChange),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthScreenContent extends StatefulWidget {
  const AuthScreenContent({
    required this.passwordChange,
    super.key,
  });

  final bool passwordChange;

  @override
  State<AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  late _State _state =
      widget.passwordChange ? _State.changePassword : _State.endpoint;

  void _updateState(_State newState) {
    if (mounted) {
      setState(() {
        _state = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      child: switch (_state) {
        _State.endpoint => EndpointWidget(
            onEndpointSaved: (isOAuth) {
              _updateState(_state = isOAuth ? _State.oauth : _State.login);
            },
          ),
        _State.changePassword => ChangePasswordWidget(
            onLogout: () {
              _updateState(_State.endpoint);
            },
            onComplete: () {
              AppRouter.toLibrary(context);
            },
          ),
        _State _ => LoginWidget(
            onBack: () {
              _updateState(_State.endpoint);
            },
            onLoginComplete: (user) {
              if (user.shouldChangePassword) {
                _updateState(_State.changePassword);
              } else {
                AppRouter.toLibrary(context);
              }
            },
          ),
      },
    );
  }
}

enum _State {
  endpoint,
  login,
  oauth,
  changePassword,
}
