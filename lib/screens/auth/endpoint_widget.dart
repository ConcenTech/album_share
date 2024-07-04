import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_snackbar.dart';
import '../../core/utils/extension_methods.dart';
import '../../core/utils/validators.dart';
import '../../services/api/api_service.dart';
import '../../services/auth/auth_providers.dart';

class EndpointWidget extends ConsumerStatefulWidget {
  const EndpointWidget({
    required this.onEndpointSaved,
    super.key,
  });

  final void Function(bool useOAuth) onEndpointSaved;

  @override
  ConsumerState<EndpointWidget> createState() => _EndpointWidgetState();
}

class _EndpointWidgetState extends ConsumerState<EndpointWidget> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  String _endpoint = '';

  void _saveEndpoint(WidgetRef ref) async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      return;
    }

    _setLoading(true);

    await Future.delayed(2.seconds);

    form.save();

    await ref
        .read(AuthProviders.service)
        .setEndpoint(_endpoint)
        .then((useOAuth) => widget.onEndpointSaved(useOAuth))
        .onError((ApiException e, s) => _onError(e.message));
  }

  void _onError(String message) {
    if (mounted){
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
    final provider = ref.watch(AuthProviders.endpoint);

    return provider.maybeWhen(
      data: (data) {
        if (_endpoint.isEmpty) {
          _endpoint = data?.serverUrl ?? 'https://';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                initialValue: _endpoint,
                validator: Validators.required,
                onEditingComplete: () => _saveEndpoint(ref),
                onSaved: (v) => _endpoint = v!,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'https://demo.immich.app',
                  labelText: 'Server url',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 10),
            FilledButton.icon(
              label: const Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              icon: const Icon(Icons.arrow_right_alt),
              iconAlignment: IconAlignment.end,
              onPressed: _loading ? null : () => _saveEndpoint(ref),
            ),
          ],
        );
      },
      orElse: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
