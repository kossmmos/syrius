import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:zenon_syrius_wallet_flutter/rearchitecture/dashboard/balance/balance.dart';
import 'package:zenon_syrius_wallet_flutter/utils/utils.dart';
import 'package:znn_sdk_dart/znn_sdk_dart.dart';

/// A `BalancePopulated` widget that displays balance data once it has been
/// successfully fetched and populated.
///
/// This widget is displayed when the `BalanceCubit` is in the `success` state,
/// and the balance data is available for rendering.
class BalancePopulated extends StatefulWidget {
  /// The balance data that has been successfully fetched.
  ///
  /// The data is a map where the key is a string (representing the account address),
  /// and the value is an `AccountInfo` object containing the balance details.
  final AccountInfo accountInfo;

  /// The address for which the [accountInfo] was retrieved.
  final String address;

  const BalancePopulated({
    required this.address,
    required this.accountInfo,
    super.key,
  });

  @override
  State<BalancePopulated> createState() => _BalancePopulatedState();
}

class _BalancePopulatedState extends State<BalancePopulated> {
  final ValueNotifier<String?> _touchedSectionId = ValueNotifier(null);
  late final ValueNotifier<Color> _addressEdgesColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addressEdgesColor = ValueNotifier(Theme.of(context).hintColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kVerticalSpacing,
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  BalanceChart(
                    accountInfo: widget.accountInfo,
                    touchedSectionId: _touchedSectionId,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _touchedSectionId,
                    builder: (_, String? id, __) {
                      final Widget center = id != null
                          ? _getBalance(
                              accountInfo: widget.accountInfo,
                              constraints: constraints,
                              tokenStandard:
                                  TokenStandard.parse(_touchedSectionId.value!),
                            )
                          : SizedBox.shrink();

                      return center;
                    },
                  ),
                ],
              );
            }),
          ),
        ),
        BalanceAddress(
          address: widget.address,
          edgesColorNotifier: _addressEdgesColor,
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BalanceChartLegend(accountInfo: widget.accountInfo),
        ),
      ],
    );
  }

  Widget _getBalance({
    required AccountInfo accountInfo,
    required BoxConstraints constraints,
    required TokenStandard tokenStandard,
  }) {
    final String amount = accountInfo
        .getBalance(
          tokenStandard,
        )
        .addDecimals(coinDecimals);

    final String symbol = tokenStandard == kZnnCoin.tokenStandard
        ? kZnnCoin.symbol
        : kQsrCoin.symbol;

    final double margin = constraints.maxWidth * 0.3;

    final double width = constraints.maxWidth - margin;

    return SizedBox(
      width: width,
      child: AutoSizeText(
        '$amount $symbol',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: ColorUtils.getTokenColor(tokenStandard),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
