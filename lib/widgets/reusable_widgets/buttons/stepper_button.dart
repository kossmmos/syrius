import 'package:flutter/material.dart';
import 'package:zenon_syrius_wallet_flutter/widgets/widgets.dart';

class StepperButton extends MyOutlinedButton {
  const StepperButton({
    required super.onPressed,
    super.text,
    super.outlineColor,
    super.child,
    super.key,
  }) : super(
          minimumSize: const Size(120.0, 40.0),
        );

  factory StepperButton.icon({
    required String label,
    required IconData iconData,
    required context,
    required VoidCallback onPressed,
    Color? outlineColor,
  }) =>
      _MyStepperButtonWithIcon(
        context: context,
        onPressed: onPressed,
        label: label,
        iconData: iconData,
      );
}

class _MyStepperButtonWithIcon extends StepperButton {
  _MyStepperButtonWithIcon({
    required String label,
    required IconData iconData,
    required VoidCallback super.onPressed,
    required BuildContext context,
  }) : super(
          child: _MyStepperButtonWithIconChild(
            label: label,
            iconData: iconData,
          ),
        );
}

class _MyStepperButtonWithIconChild extends StatelessWidget {
  final String label;
  final IconData iconData;

  const _MyStepperButtonWithIconChild({
    required this.label,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(
          width: 10.0,
        ),
        Icon(
          iconData,
          size: 17.0,
          color: Theme.of(context).textTheme.headlineSmall!.color,
        ),
      ],
    );
  }
}
