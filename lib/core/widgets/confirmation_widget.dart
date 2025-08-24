import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmanager/core/widgets/button.dart';
import 'package:taskmanager/core/widgets/typography.dart';

class ConfirmationWidget extends StatelessWidget {
  const ConfirmationWidget({
    super.key,
    required this.title,
    required this.okButtonTitle,
    required this.description,
    required this.onConfirmation,
  });

  final String title;
  final String description;
  final String okButtonTitle;
  final Function() onConfirmation;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          top: 30,
          left: 16,
          right: 16,
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTypography(
              text: title,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            AppTypography(text: description),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      context.pop();
                    },
                    text: AppLocalizations.of(context).cancel,
                    isOuterButton: true,
                    fontSize: 14,
                    margin: const EdgeInsets.only(
                      right: 8,
                      top: 8,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      onConfirmation();
                    },
                    fontSize: 14,
                    text: okButtonTitle,
                    margin: const EdgeInsets.only(
                      left: 8,
                      top: 8,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
