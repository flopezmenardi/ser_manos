import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../molecules/inputs/inputs.dart';
import '../../tokens/typography.dart';

class ContactDataFormSermanos extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController telephoneController;

  const ContactDataFormSermanos({super.key, required this.emailController, required this.telephoneController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(AppLocalizations.of(context)!.contactData, style: AppTypography.headline1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),

          // Description
          Text(
            AppLocalizations.of(context)!.contactDataDescription,
            style: AppTypography.subtitle1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),

          // Phone Input
          AppInput(
            label: AppLocalizations.of(context)!.telephone,
            placeholder: AppLocalizations.of(context)!.telephonePlaceholder,
            controller: telephoneController,
            // keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Email Input
          AppInput(
            label: AppLocalizations.of(context)!.mail,
            placeholder: AppLocalizations.of(context)!.mailPlaceholder,
            controller: emailController,
            // keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
