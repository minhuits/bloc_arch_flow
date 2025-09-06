import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:example/src/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:mocktail/mocktail.dart';

class MockCounter extends Mock implements CounterEnvironment {}

// --- MVI Bloc 테스트 ---
class CounterBlocTestSuite
    extends BlocTestSuite<CounterMviBloc, CounterState, CounterIntent, MockCounter> {
  @override
  MockCounter createMockEnvironment() => MockCounter();

  @override
  CounterState getInitialState() => const CounterState();

  @override
  CounterMviBloc buildBloc() => CounterMviBloc(mockEnvironment);
}

void main() {
  group('CounterBloc: 수동 테스트', () {
    late MockCounter mockEnvironment;

    setUp(() {
      mockEnvironment = MockCounter();
    });

    blocTest<CounterMviBloc, CounterState>(
      '초기 상태는 0이다',
      build: () => CounterMviBloc(mockEnvironment),
      expect: () => [],
      verify: (bloc) {
        expect(bloc.state, CounterState.initial());
      },
    );

    blocTest<CounterMviBloc, CounterState>(
      'increment 액션에 따라 카운트가 1 증가한다',
      build: () => CounterMviBloc(mockEnvironment),
      act: (bloc) => bloc.add(const CounterIntent.increment()),
      expect: () => [const CounterState(count: 1)],
    );

    blocTest<CounterMviBloc, CounterState>(
      'decrement 액션에 따라 카운트가 1 감소한다',
      build: () => CounterMviBloc(mockEnvironment),
      act: (bloc) => bloc.add(const CounterIntent.decrement()),
      expect: () => [const CounterState(count: -1)],
    );

    blocTest<CounterMviBloc, CounterState>(
      'incrementAsync 성공 시 카운트가 증가하고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither를 반환하도록 수정
        when(
          () => mockEnvironment.performAsyncIncrement(currentCount: any(named: 'currentCount')),
        ).thenAnswer(
          (_) => TaskEither.right(1), // 성공 케이스를 시뮬레이션
        );
        return CounterMviBloc(mockEnvironment);
      },
      act: (bloc) => bloc.add(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        const CounterState(isLoading: false, count: 1),
      ],
      verify: (bloc) {
        verify(() => mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    blocTest<CounterMviBloc, CounterState>(
      'incrementAsync 실패 시 에러 메시지가 상태에 저장되고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither의 실패(Left) 케이스를 시뮬레이션
        final exception = Exception("Cannot increment beyond 5!");
        when(
          () => mockEnvironment.performAsyncIncrement(currentCount: any(named: 'currentCount')),
        ).thenAnswer((_) => TaskEither.left(exception));
        return CounterMviBloc(mockEnvironment);
      },
      act: (bloc) => bloc.add(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        CounterState(isLoading: false, error: "Exception: Cannot increment beyond 5!"),
      ],
      verify: (bloc) {
        verify(() => mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    blocTest<CounterMviBloc, CounterState>(
      'reset 액션에 따라 카운트가 초기화된다',
      build: () => CounterMviBloc(mockEnvironment),
      seed: () => const CounterState(count: 10, isLoading: true, error: 'Error'),
      act: (bloc) => bloc.add(const CounterIntent.reset()),
      expect: () => [const CounterState(count: 0, isLoading: false, error: null)],
    );
  });

  group('CounterBloc: BlocTestSuite 테스트', () {
    final CounterBlocTestSuite testSuite = CounterBlocTestSuite();

    testSuite.initTestSuite(); // setUp 및 tearDown 자동 실행

    blocTest<CounterMviBloc, CounterState>(
      '초기 상태는 0이다',
      build: () => testSuite.buildBloc(),
      expect: () => [],
    );

    blocTest<CounterMviBloc, CounterState>(
      'increment 액션에 따라 카운트가 1 증가한다',
      build: () => testSuite.buildBloc(),
      act: (bloc) => bloc.add(const CounterIntent.increment()),
      expect: () => [const CounterState(count: 1)],
    );

    blocTest<CounterMviBloc, CounterState>(
      'decrement 액션에 따라 카운트가 1 감소한다',
      build: () => testSuite.buildBloc(),
      act: (bloc) => bloc.add(const CounterIntent.decrement()),
      expect: () => [const CounterState(count: -1)],
    );

    blocTest<CounterMviBloc, CounterState>(
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
        return CounterMviBloc(testSuite.mockEnvironment);
      },
      act: (bloc) => bloc.add(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        const CounterState(isLoading: false, count: 1),
      ],
      verify: (bloc) {
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    blocTest<CounterMviBloc, CounterState>(
      'incrementAsync 실패 시 에러 메시지가 상태에 저장되고 isLoading이 false가 된다',
      build: () {
        // Mocking: TaskEither의 실패(Left) 케이스를 시뮬레이션
        final Exception exception = Exception("Cannot increment beyond 5!");
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
        ).thenAnswer((_) => TaskEither.left(exception));
        return CounterMviBloc(testSuite.mockEnvironment);
      },
      act: (bloc) => bloc.add(const CounterIntent.incrementAsync()),
      expect: () => [
        const CounterState(isLoading: true),
        CounterState(isLoading: false, error: "Exception: Cannot increment beyond 5!"),
      ],
      verify: (bloc) {
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    blocTest<CounterMviBloc, CounterState>(
      'reset 액션에 따라 카운트가 초기화된다',
      build: () => testSuite.buildBloc(),
      seed: () => const CounterState(count: 10, isLoading: true, error: 'Error'),
      act: (bloc) => bloc.add(const CounterIntent.reset()),
      expect: () => [const CounterState(count: 0, isLoading: false, error: null)],
    );
  });
}