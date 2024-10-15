import 'package:flutter/material.dart';

import '../../core/components/logo_widget.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../routes/app_router.dart';
import 'endpoint_widget.dart';
import 'login_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const id = 'auth_screen';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      id: id,
      showTitleBar: false,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: const Card(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoImageText(),
                  SizedBox(height: 10),
                  AuthScreenContent(),
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
  const AuthScreenContent({super.key});

  @override
  State<AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  _State _state = _State.endpoint;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      child: switch (_state) {
        _State.endpoint => EndpointWidget(
            onEndpointSaved: (isOAuth) {
              setState(() {
                _state = isOAuth ? _State.oauth : _State.login;
              });
            },
          ),
        _State _ => LoginWidget(
            onBack: () {
              setState(() {
                _state = _State.endpoint;
              });
            },
            onLoginComplete: () {
              AppRouter.toLibrary(context);
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
}
