// lib/widgets/intl_text_widget.dart
import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class IntlTextWidget extends StatelessWidget {
  final String localizationKey;
  final TextStyle? style;
  final TextAlign? textAlign;

  const IntlTextWidget(
      this.localizationKey, {
        super.key,
        this.style,
        this.textAlign,
      });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // Mapeamento manual de chaves conhecidas
    final map = <String, String>{
      'welcome': loc.welcome,
      'onboard1': loc.onboard1,
      'onboard2': loc.onboard2,
      'onboard3': loc.onboard3,
    };

    return Text(
      map[localizationKey] ?? localizationKey,
      style: style,
      textAlign: textAlign,
    );
  }
}
