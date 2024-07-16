import 'package:flutter/material.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Change password'),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.chevron_right),
      ),
      onTap: () {},
    );
  }
}
