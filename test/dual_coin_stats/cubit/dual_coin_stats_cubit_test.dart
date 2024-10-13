import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zenon_syrius_wallet_flutter/rearchitecture/dashboard/dashboard.dart';
import 'package:znn_sdk_dart/znn_sdk_dart.dart';

class MockZenon extends Mock implements Zenon {}

class MockWsClient extends Mock implements WsClient {}

class MockEmbedded extends Mock implements EmbeddedApi {}

class MockTokenApi extends Mock implements TokenApi {}

class MockToken extends Mock implements Token {}

class FakeTokenStandard extends Fake implements TokenStandard {}

void main() {

  setUpAll(() {
    registerFallbackValue(FakeTokenStandard());
  });

  group('DualCoinStatsCubit', () {
    late MockZenon mockZenon;
    late MockEmbedded mockEmbedded;
    late MockWsClient mockWsClient;
    late MockTokenApi mockTokenApi;
    late DualCoinStatsCubit dualCoinStatsCubit;
    late Exception dualCoinStatsException;
    late MockToken mockTokenZnn;
    late MockToken mockTokenQsr;

    setUp(() async {
      mockZenon = MockZenon();
      mockEmbedded = MockEmbedded();
      mockTokenApi = MockTokenApi();
      mockWsClient = MockWsClient();
      dualCoinStatsException = Exception();
      mockTokenZnn = MockToken();
      mockTokenQsr = MockToken();
      dualCoinStatsCubit = DualCoinStatsCubit(mockZenon, DualCoinStatsState());

      when(() => mockZenon.wsClient).thenReturn(mockWsClient);
      when(() => mockWsClient.isClosed()).thenReturn(false);
      when(() => mockZenon.embedded).thenReturn(mockEmbedded);
      when(() => mockEmbedded.token).thenReturn(mockTokenApi);


      when(() => mockTokenApi.getByZts(znnZts)).thenAnswer((_) async => mockTokenZnn);
      when(() => mockTokenApi.getByZts(qsrZts)).thenAnswer((_) async => mockTokenQsr);
    });

    test('initial status is correct', () {
      final DualCoinStatsCubit dualCoinStatsCubit = DualCoinStatsCubit(
        mockZenon,
        DualCoinStatsState(),
      );
      expect(dualCoinStatsCubit.state.status, CubitStatus.initial);
    });

      blocTest<DualCoinStatsCubit, DashboardState>(
        'calls getByZts for each address in token once',
        build: () => dualCoinStatsCubit,
        setUp: () {

        },
        act: (cubit) => cubit.fetch(),
        verify: (_) {
          verify(() => mockTokenApi.getByZts(znnZts)).called(1);
          verify(() => mockTokenApi.getByZts(qsrZts)).called(1);
        },
      );

    blocTest<DualCoinStatsCubit, DashboardState>(
      'emits [loading, failure] when getByZts throws',
      setUp: () {
        when(
                () => mockTokenApi.getByZts(any())
        ).thenThrow(dualCoinStatsException);
      },
      build: () => dualCoinStatsCubit,
      act: (cubit) => cubit.fetchDataPeriodically(),
      expect: () => <DualCoinStatsState>[
        DualCoinStatsState(status: CubitStatus.loading),
        DualCoinStatsState(
          status: CubitStatus.failure,
          error: dualCoinStatsException,
        ),
      ],
    );

    blocTest<DualCoinStatsCubit, DashboardState>(
        'emits [loading, success] when getByZts returns',
        build: () => dualCoinStatsCubit,
        act: (cubit) => cubit.fetchDataPeriodically(),
        expect: () => <DualCoinStatsState>[
          DualCoinStatsState(status: CubitStatus.loading),
          DualCoinStatsState(
            status: CubitStatus.success,
            data: [mockTokenZnn, mockTokenQsr]
          ),
        ]
    );
  });
}