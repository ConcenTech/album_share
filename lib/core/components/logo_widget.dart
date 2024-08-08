import 'package:album_share/core/utils/app_localisations.dart';
import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'LogoImageWidget',
      child: Image.asset('assets/logo.png'),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({this.tagLine = true, super.key});

  final bool tagLine;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context)!;
    return Hero(
      tag: 'LogoTextWidget',
      child: RichText(
        text: TextSpan(
          text: locale.appTitle,
          style: tagLine ? textTheme.headlineMedium : textTheme.titleMedium,
          children: [
            if (tagLine)
              TextSpan(
                text: '\n${locale.appTagLine}',
                style: textTheme.labelMedium,
              ),
          ],
        ),
      ),
    );
  }
}

class LogoImageText extends StatelessWidget {
  const LogoImageText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 45,
          child: LogoImage(),
        ),
        LogoText(),
      ],
    );
  }
}
