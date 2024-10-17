import 'package:flutter/material.dart';

class TransferIconLegend extends StatelessWidget {
  final String legendText;

  const TransferIconLegend({
    required this.legendText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            legendText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
