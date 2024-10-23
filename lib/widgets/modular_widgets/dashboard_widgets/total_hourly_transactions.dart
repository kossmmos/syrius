import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:zenon_syrius_wallet_flutter/blocs/blocs.dart';
import 'package:zenon_syrius_wallet_flutter/utils/constants.dart';
import 'package:zenon_syrius_wallet_flutter/widgets/widgets.dart';

const String _kWidgetTitle = 'Transactions';
const String _kWidgetDescription = 'This card displays the total number of '
    'transactions settled in the last hour across the network';

class TotalHourlyTransactions extends StatefulWidget {
  const TotalHourlyTransactions({super.key});

  @override
  State<TotalHourlyTransactions> createState() =>
      _TotalHourlyTransactionsState();
}

class _TotalHourlyTransactionsState extends State<TotalHourlyTransactions> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TotalHourlyTransactionsBloc>.reactive(
      viewModelBuilder: TotalHourlyTransactionsBloc.new,
      onViewModelReady: (model) {
        model.getDataPeriodically();
      },
      builder: (_, model, __) => CardScaffold<Map<String, dynamic>>(
        childStream: model.stream,
        onCompletedStatusCallback: _getWidgetBody,
        title: _kWidgetTitle,
        description: _kWidgetDescription,
      ),
    );
  }

  Widget _getWidgetBody(Map<String, dynamic> widgetData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberAnimation(
          end: widgetData['numAccountBlocks'],
          isInt: true,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontSize: 30,
              ),
        ),
        kVerticalSpacing,
        const Text('transactions in the last hour'),
      ],
    );
  }
}
