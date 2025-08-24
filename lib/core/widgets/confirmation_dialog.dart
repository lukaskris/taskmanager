import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskmanager/core/widgets/button.dart';
import 'package:taskmanager/utils/context_extension.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String okButtonTitle;
  final VoidCallback onConfirmation;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.okButtonTitle,
    required this.onConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () => Navigator.of(context).pop(),
                isOuterButton: true,
                margin: const EdgeInsets.only(left: 8),
                text: context.loc!.cancel,
                fontSize: 14,
              ),
            ),
            Gap(8),
            Expanded(
              child: CustomButton(
                margin: const EdgeInsets.only(right: 8),
                onPressed: () {
                  onConfirmation();
                  Navigator.of(context).pop();
                },
                text: okButtonTitle,
                fontSize: 14,
              ),
            ),
          ],
        )
      ],
    );
  }
}
