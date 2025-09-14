import 'dart:async' show FutureOr;

import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:bloc_test/bloc_test.dart' as bloc_test show blocTest;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:mocktail/mocktail.dart';

import 'counter_mvi.dart';

void main() {
  group('CounterMviCubit: 1. 기존 방식', () {
    late CounterMock mockEnvironment;

    setUp(() {
      mockEnvironment = CounterMock();
    });

    // 반복 작업을 줄이는 함수
    void blocTest(
      String description, {
      CounterMviCubit Function()? build,
      FutureOr<void> Function()? setUp,
      CounterState Function()? seed,
      dynamic Function(CounterMviCubit bloc)? act,
      Duration? wait,
      int skip = 0,
      dynamic Function()? expect,
      dynamic Function(CounterMviCubit bloc)? verify,
      dynamic Function()? errors,
      FutureOr<void> Function()? tearDown,
      dynamic tags,
    }) {
      bloc_test.blocTest<CounterMviCubit, CounterState>(
        description,
        build: build ?? () => CounterMviCubit(mockEnvironment),
        setUp: setUp,
        seed: seed,
        act: act,
        wait: wait,
        skip: skip,
        expect: expect,
        verify: verify,
        errors: errors,
        tearDown: tearDown,
        tags: tags,
      );
    }

    blocTest(
      '초기 상태는 0이다',
      expect: () => [],
      verify: (bloc) {
        expect(bloc.state, CounterState.initial());
      },
    );

    blocTest(
      'increment 액션에 따라 카운트가 1 증가한다',
      act: (bloc) => bloc.onIntent(const CounterIntent.increment()),
      expect: () => [const CounterState(count: 1)],
    );

    blocTest(
      'decrement 액션에 따라 카운트가 1 감소한다',
      act: (bloc) => bloc.onIntent(const CounterIntent.decrement()),
      expect: () => [const CounterState(count: -1)],
    );

    blocTest(
      'incrementAsync 성공 시 카운트가 증가하고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither를 반환하도록 수정
        when(
          () => mockEnvironment.performAsyncIncrement(currentCount: any(named: 'currentCount')),
        ).thenAnswer(
          (_) => TaskEither.right(1), // 성공 케이스를 시뮬레이션
        );
        return CounterMviCubit(mockEnvironment);
      },
      act: (bloc) => bloc.onIntent(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        const CounterState(isLoading: false, count: 1),
      ],
      verify: (bloc) {
        verify(() => mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    blocTest(
      'incrementAsync 실패 시 에러 메시지가 상태에 저장되고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither의 실패(Left) 케이스를 시뮬레이션
        final exception = Exception("Cannot increment beyond 5!");
        when(
          () => mockEnvironment.performAsyncIncrement(currentCount: any(named: 'currentCount')),
        ).thenAnswer((_) => TaskEither.left(exception));
        return CounterMviCubit(mockEnvironment);
      },
      act: (bloc) => bloc.onIntent(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        CounterState(isLoading: false, error: "Exception: Cannot increment beyond 5!"),
      ],
      verify: (bloc) {
        verify(() => mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    blocTest(
      'reset 액션에 따라 카운트가 초기화된다',
      seed: () => const CounterState(count: 10, isLoading: true, error: 'Error'),
      act: (bloc) => bloc.onIntent(const CounterIntent.reset()),
      expect: () => [const CounterState(count: 0, isLoading: false, error: null)],
    );
  });

  group('CounterMviCubit: 2. BlocTestSuite 사용', () {
    final CounterCubitTestSuite testSuite = CounterCubitTestSuite();

    testSuite.initTestSuite(); // setUp 및 tearDown 자동 실행

    testSuite.blocTest('초기 상태는 0이다', expect: () => []);

    testSuite.blocTest(
      'increment 액션에 따라 카운트가 1 증가한다',
      act: (bloc) => bloc.onIntent(const CounterIntent.increment()),
      expect: () => [const CounterState(count: 1)],
    );

    testSuite.blocTest(
      'decrement 액션에 따라 카운트가 1 감소한다',
      act: (bloc) => bloc.onIntent(const CounterIntent.decrement()),
      expect: () => [const CounterState(count: -1)],
    );

    testSuite.blocTest(
      'incrementAsync 성공 시 카운트가 증가하고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither를 반환하도록 수정
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer(
          (_) => TaskEither.right(1), // 성공 케이스를 시뮬레이션
        );
        return CounterMviCubit(testSuite.mockEnvironment);
      },
      act: (bloc) => bloc.onIntent(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        const CounterState(isLoading: false, count: 1),
      ],
      verify: (bloc) {
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    testSuite.blocTest(
      'incrementAsync 실패 시 에러 메시지가 상태에 저장되고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither의 실패(Left) 케이스를 시뮬레이션
        final Exception exception = Exception("Cannot increment beyond 5!");
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => TaskEither.left(exception));
        return CounterMviCubit(testSuite.mockEnvironment);
      },
      act: (bloc) => bloc.onIntent(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        CounterState(isLoading: false, error: "Exception: Cannot increment beyond 5!"),
      ],
      verify: (bloc) {
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    testSuite.blocTest(
      'reset 액션에 따라 카운트가 초기화된다',
      seed: () => const CounterState(count: 10, isLoading: true, error: 'Error'),
      act: (bloc) => bloc.onIntent(const CounterIntent.reset()),
      expect: () => [const CounterState(count: 0, isLoading: false, error: null)],
    );
  });

  group('CounterMviCubit: 3. CounterCubitTestSuite 사용', () {
    final CounterCubitTestSuite testSuite = CounterCubitTestSuite();
    testSuite.initTestSuite();

    // 1. 동기적인 상태 변경만 테스트
    testSuite.testState(
      'increment 인텐트 발생 시 카운트가 1 증가해야 한다',
      intent: const CounterIntent.increment(),
      expectedState: const CounterState(count: 1),
    );

    testSuite.testState(
      'increment 인텐트 발생 시 카운트가 1 감소해야 한다',
      intent: const CounterIntent.decrement(),
      expectedState: const CounterState(count: -1),
    );

    // 2. 부수 효과만 발생하는 비동기 테스트
    testSuite.testSideEffect(
      'incrementAsync 성공 시 토스트 효과가 발생해야 한다',
      intent: const CounterIntent.incrementAsync(),
      expectedEffect: const CounterEffect.showToast('Incremented successfully!'),
      setUp: () {
        // Mocking을 사용하여 performAsyncIncrement가 지연 없이 즉시 완료되도록 설정
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
          // ).thenAnswer((_) => TaskEither.right(1));
        ).thenAnswer((_) => testSuite.whenSuccessTask(1));
      },
    );

    testSuite.testSideEffect(
      'incrementAsync 실패 시 에러 토스트 효과가 발생해야 한다',
      intent: const CounterIntent.incrementAsync(),
      // expectedEffect의 메시지를 실제 emit되는 값과 동일하게 수정
      expectedEffect: const CounterEffect.showToast('Exception: Cannot increment beyond 5!'),
      setUp: () {
        // Mocking을 사용하여 비동기 작업이 즉시 실패하도록 설정
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => testSuite.whenFailureTask(Exception('Cannot increment beyond 5!')));
      },
    );

    // 상태 변경과 부수 효과를 모두 테스트
    testSuite.testCubitGroup(
      'incrementAsync 성공 시 로딩, 최종 상태 및 토스트 효과가 발생해야 한다',
      intent: const CounterIntent.incrementAsync(),
      loadingState: const CounterState(isLoading: true),
      finalState: const CounterState(count: 1, isLoading: false),
      expectedEffect: const CounterEffect.showToast('Incremented successfully!'),
      wait: const Duration(seconds: 1, milliseconds: 1),
      setUp: () {
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => testSuite.whenSuccessTask(1));
      },
    );

    // 비동기 실패 케이스 테스트
    testSuite.testCubitGroup(
      'incrementAsync 실패 시 에러 상태 및 에러 토스트 효과가 발생해야 한다',
      intent: const CounterIntent.incrementAsync(),
      loadingState: const CounterState(isLoading: true),
      finalState: const CounterState(
        isLoading: false,
        error: 'Exception: Cannot increment beyond 5!',
      ),
      wait: const Duration(seconds: 1, milliseconds: 50),
      expectedEffect: const CounterEffect.showToast('Exception: Cannot increment beyond 5!'),
      setUp: () {
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => testSuite.whenFailureTask(Exception('Cannot increment beyond 5!')));
      },
    );
  });
}

class CounterMock extends Mock implements CounterEnvironment {}

typedef CounterCubit =
    MviCubitTestSuite<
      CounterMviCubit,
      CounterIntent,
      CounterState,
      CounterEffect,
      CounterEnvironment
    >;

class CounterCubitTestSuite extends CounterCubit {
  @override
  CounterState buildInitialState() => CounterState.initial();

  @override
  CounterMviCubit buildMockBaseBloc() => CounterMviCubit(mockEnvironment);

  @override
  CounterEnvironment buildMockEnvironment() => CounterMock();
}