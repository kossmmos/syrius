import 'package:flutter/material.dart';

class AmountInfoColumn extends Column {
  final String amount;
  final String tokenSymbol;
  final BuildContext context;

  AmountInfoColumn({
    super.key,
    required this.context,
    required this.amount,
    required this.tokenSymbol,
  }) : super(
          children: [
            Text(
              tokenSymbol,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        );
}
