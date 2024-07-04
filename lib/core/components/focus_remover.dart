import 'package:flutter/material.dart';

void removeFocus(BuildContext context) {
  final currentFocus = Focus.maybeOf(context);

  if (currentFocus == null) {
    return;
  }

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

class FocusRemover extends StatelessWidget {
  /// Closes the keyboard when tapping outside of text fields.
  const FocusRemover(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => removeFocus(context),
      child: child,
    );
  }
}
