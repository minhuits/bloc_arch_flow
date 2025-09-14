import 'dart:async' show FutureOr;

import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:bloc_test/bloc_test.dart' as bloc_test show blocTest;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:mocktail/mocktail.dart';

import 'counter_tca.dart';

class MockCounter extends Mock implements CounterEnvironment {}

typedef CounterBloc =
    TcaBlocTestSuite<CounterTcaBloc, CounterActions, CounterState, CounterEnvironment>;

class CounterBlocTestSuite extends CounterBloc {
  @override
  CounterState buildInitialState() => const CounterState();

  @override
  CounterTcaBloc buildMockBaseBloc() => CounterTcaBloc(mockEnvironment);

  @override
  CounterEnvironment buildMockEnvironment() => MockCounter();

  @override
  TcaReducer<CounterActions, CounterState> reduceTest(
    CounterActions action,
    CounterState currentState,
    CounterEnvironment environment,
  ) {
    return mockBaseBloc.reduce(action, currentState, environment);
  }
}

void main() {
  group('CounterBloc: 1. 기존 방식', () {
    late MockCounter mockEnvironment;

    setUp(() {
      mockEnvironment = MockCounter();
    });

    // 반복 작업을 줄이는 함수
    void blocTest(
      String description, {
      CounterTcaBloc Function()? build,
      FutureOr<void> Function()? setUp,
      CounterState Function()? seed,
      dynamic Function(CounterTcaBloc bloc)? act,
      Duration? wait,
      int skip = 0,
      dynamic Function()? expect,
      dynamic Function(CounterTcaBloc bloc)? verify,
      dynamic Function()? errors,
      FutureOr<void> Function()? tearDown,
      dynamic tags,
    }) {
      bloc_test.blocTest<CounterTcaBloc, CounterState>(
        description,
        build: build ?? () => CounterTcaBloc(mockEnvironment),
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

    // 초기 상태 테스트
    blocTest(
      '블록이 초기 상태로 시작하는지 확인',
      expect: () => [], // 초기 상태는 build 시점에 이미 설정되므로 추가적인 emit 없음
      verify: (bloc) {
        expect(bloc.state, CounterState.initial());
      },
    );

    // IncrementTCA 테스트
    blocTest(
      'IncrementTCA 액션 시 count가 1 증가하는지 확인',
      act: (bloc) => bloc.add(CounterActions.increment()),
      expect: () => [CounterState(count: 1, isLoading: false, error: null)],
    );

    // DecrementTCA 테스트
    blocTest(
      'DecrementTCA 액션 시 count가 1 감소하는지 확인',
      act: (bloc) => bloc.add(CounterActions.decrement()),
      expect: () => [CounterState(count: -1, isLoading: false, error: null)],
    );

    // ResetTCA 테스트
    blocTest(
      'ResetTCA 액션 시 상태가 초기화되는지 확인',
      seed: () => CounterState(count: 10, isLoading: true, error: 'some error'),
      act: (bloc) => bloc.add(CounterActions.reset()),
      expect: () => [CounterState.initial()],
    );

    // incrementAsync 액션 성공 시 count가 업데이트되고 isLoading이 false가 되는지 확인
    blocTest(
      'incrementAsync 성공 시 count가 업데이트되고 isLoading이 false가 된다',
      setUp: () {
        // 비동기 증가 성공 시 TaskEither.right(5)를 반환하도록 Mocking
        when(
          () => mockEnvironment.performAsyncIncrement(currentCount: any(named: 'currentCount')),
        ).thenAnswer((_) => TaskEither.right(5));
      },
      act: (bloc) => bloc.add(const CounterActions.incrementAsync()),
      expect: () => [
        // 1. 비동기 작업 시작: isLoading = true
        const CounterState(count: 0, isLoading: true, error: null),
        // 2. 비동기 작업 성공: isLoading = false, count 업데이트
        const CounterState(count: 5, isLoading: false, error: null),
      ],
      verify: (bloc) {
        verify(() => mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    // incrementAsync 액션 실패 시 error가 설정되고 isLoading이 false가 되는지 확인
    blocTest(
      'incrementAsync 실패 시 error가 설정되고 isLoading이 false가 된다',
      setUp: () {
        // 비동기 증가 실패 시 TaskEither.left(exception)을 반환하도록 Mocking
        final exception = Exception("Cannot increment beyond 5!");
        when(
          () => mockEnvironment.performAsyncIncrement(currentCount: any(named: 'currentCount')),
        ).thenAnswer((_) => TaskEither.left(exception));
      },
      act: (bloc) => bloc.add(const CounterActions.incrementAsync()),
      expect: () => [
        // 1. 비동기 작업 시작: isLoading = true
        const CounterState(isLoading: true),
        // 2. 비동기 작업 실패: isLoading = false, error 설정
        const CounterState(isLoading: false, error: "Exception: Cannot increment beyond 5!"),
      ],
      verify: (bloc) {
        verify(() => mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    // AsyncIncrementSuccess 테스트 (내부적으로 호출되지만, 명시적 테스트)
    blocTest(
      'AsyncIncrementSuccess 액션 시 상태가 올바르게 업데이트되는지 확인',
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.success(10)),
      expect: () => [CounterState(count: 10, isLoading: false, error: null)],
    );

    // AsyncIncrementFailed 테스트 (내부적으로 호출되지만, 명시적 테스트)
    blocTest(
      'AsyncIncrementFailed 액션 시 에러가 설정되는지 확인',
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.failed('API 호출 실패')),
      expect: () => [CounterState(count: 5, isLoading: false, error: 'API 호출 실패')],
    );
  });

  group('CounterBloc: 2. BlocTestSuite 사용', () {
    final CounterBlocTestSuite testSuite = CounterBlocTestSuite();
    testSuite.initTestSuite(); // setUp 및 tearDown 자동 실행

    // 초기 상태 테스트
    testSuite.blocTest(
      '블록이 초기 상태로 시작하는지 확인',
      build: () => testSuite.buildMockBaseBloc(),
      expect: () => [], // 초기 상태는 build 시점에 이미 설정되므로 추가적인 emit 없음
      verify: (bloc) {
        expect(bloc.state, CounterState.initial());
      },
    );

    // IncrementTCA 테스트
    testSuite.blocTest(
      'IncrementTCA 액션 시 count가 1 증가하는지 확인',
      build: () => testSuite.buildMockBaseBloc(),
      act: (bloc) => bloc.add(CounterActions.increment()),
      expect: () => [CounterState(count: 1, isLoading: false, error: null)],
    );

    // DecrementTCA 테스트
    testSuite.blocTest(
      'DecrementTCA 액션 시 count가 1 감소하는지 확인',
      build: () => testSuite.buildMockBaseBloc(),
      act: (bloc) => bloc.add(CounterActions.decrement()),
      expect: () => [CounterState(count: -1, isLoading: false, error: null)],
    );

    // ResetTCA 테스트
    testSuite.blocTest(
      'ResetTCA 액션 시 상태가 초기화되는지 확인',
      build: () => testSuite.buildMockBaseBloc(),
      seed: () => CounterState(count: 10, isLoading: true, error: 'some error'),
      act: (bloc) => bloc.add(CounterActions.reset()),
      expect: () => [CounterState.initial()],
    );

    testSuite.blocTest(
      'incrementAsync 성공 시 count가 업데이트되고 isLoading이 false가 된다',
      build: () => testSuite.buildMockBaseBloc(),
      setUp: () {
        // 비동기 증가 성공 시 TaskEither.right(5)를 반환하도록 Mocking
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => testSuite.whenSuccessTask(5));
      },
      act: (bloc) => bloc.add(const CounterActions.incrementAsync()),
      expect: () => [
        // 1. 비동기 작업 시작: isLoading = true
        const CounterState(count: 0, isLoading: true, error: null),
        // 2. 비동기 작업 성공: isLoading = false, count 업데이트
        const CounterState(count: 5, isLoading: false, error: null),
      ],
      verify: (bloc) {
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    // incrementAsync 액션 실패 시 error가 설정되고 isLoading이 false가 되는지 확인
    testSuite.blocTest(
      'incrementAsync 실패 시 error가 설정되고 isLoading이 false가 된다',
      build: () => testSuite.buildMockBaseBloc(),
      setUp: () {
        // 비동기 증가 실패 시 TaskEither.left(exception)을 반환하도록 Mocking
        final exception = Exception("Cannot increment beyond 5!");
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => testSuite.whenFailureTask(exception));
      },
      act: (bloc) => bloc.add(const CounterActions.incrementAsync()),
      expect: () => [
        // 1. 비동기 작업 시작: isLoading = true
        const CounterState(isLoading: true),
        // 2. 비동기 작업 실패: isLoading = false, error 설정
        const CounterState(isLoading: false, error: "Exception: Cannot increment beyond 5!"),
      ],
      verify: (bloc) {
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    // Success 테스트 (내부적으로 호출되지만, 명시적 테스트)
    testSuite.blocTest(
      'Success 액션 시 상태가 올바르게 업데이트되는지 확인',
      build: () => testSuite.buildMockBaseBloc(),
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.success(10)),
      expect: () => [CounterState(count: 10, isLoading: false, error: null)],
    );

    // Failed 테스트 (내부적으로 호출되지만, 명시적 테스트)
    testSuite.blocTest(
      'Failed 액션 시 에러가 설정되는지 확인',
      build: () => testSuite.buildMockBaseBloc(),
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.failed('API 호출 실패')),
      expect: () => [CounterState(count: 5, isLoading: false, error: 'API 호출 실패')],
    );
  });

  group('CounterBloc: 3. TcaBlocTestSuite 사용', () {
    final CounterBlocTestSuite testSuite = CounterBlocTestSuite();
    testSuite.initTestSuite(); // setUp 및 tearDown 자동 실행

    group('testSequence', () {
      testSuite.testSequence(
        'Increment -> Decrement -> Reset 순서대로 상태가 올바르게 변화해야 함',
        initialState: const CounterState(count: 1),
        steps: [
          testSuite.step(
            'Increment 액션으로 count가 6 증가',
            stepAction: ReducerStepAction.pure(action: const CounterActions.increment()),
            state: const CounterState(count: 6),
            effect: isA<TcaEffect>(),
          ),
          testSuite.step(
            'Decrement 액션으로 count가 5로 감소',
            stepAction: ReducerStepAction.pure(action: const CounterActions.decrement()),
            state: const CounterState(count: 5),
            effect: isA<TcaEffect>(),
          ),
          testSuite.step(
            'Reset 액션으로 초기 상태인 count: 0으로 돌아감',
            stepAction: ReducerStepAction.pure(action: const CounterActions.reset()),
            state: CounterState.initial(),
            effect: isA<TcaEffect>(),
          ),
        ],
        wait: const Duration(milliseconds: 100),
      );
    });

    group('testEffect', () {
      testSuite.testEffect(
        'incrementAsync 성공 시 count가 업데이트되고 isLoading이 false가 된다',
        setUp: () {
          when(
            () => testSuite.mockEnvironment.performAsyncIncrement(
              currentCount: any(named: 'currentCount'),
            ),
          ).thenAnswer((_) => testSuite.whenSuccessTask(5));
        },
        stepAction: ReducerStepAction.success(
          action: const CounterActions.incrementAsync(),
          expected: const CounterActions.success(5),
        ),
        wait: const Duration(milliseconds: 10),
      );

      testSuite.testEffect(
        'incrementAsync 실패 시 error가 설정되고 isLoading이 false가 된다',
        setUp: () {
          final exception = Exception("Cannot increment beyond 5!");
          when(
            () => testSuite.mockEnvironment.performAsyncIncrement(
              currentCount: any(named: 'currentCount'),
            ),
          ).thenAnswer((_) => testSuite.whenFailureTask(exception));
        },
        stepAction: ReducerStepAction.failure(
          action: const CounterActions.incrementAsync(),
          expected: const CounterActions.failed("Exception: Cannot increment beyond 5!"),
        ),
        wait: const Duration(milliseconds: 10),
      );
    });

    group('testReducer', () {
      // 상태 변화만 확인하는 단순 액션들을 테스트하는 데 최적화되어 있습니다.
      testSuite.testReducer(
        'Increment 액션 시 count가 1 증가해야 함',
        action: const CounterActions.increment(),
        initialState: const CounterState(count: 0),
        expectedState: const CounterState(count: 1),
        expectedEffect: isA<TcaEffect>(),
      );

      testSuite.testReducer(
        'Decrement 액션 시 count가 1 감소해야 함',
        action: const CounterActions.decrement(),
        initialState: const CounterState(count: 0),
        expectedState: const CounterState(count: -1),
        expectedEffect: isA<TcaEffect>(),
      );

      testSuite.testReducer(
        'Reset 액션 시 상태가 초기화되어야 함',
        action: const CounterActions.reset(),
        initialState: const CounterState(count: 10, isLoading: true, error: 'some error'),
        expectedState: CounterState.initial(),
        expectedEffect: isA<TcaEffect>(),
      );
    });
  });
}