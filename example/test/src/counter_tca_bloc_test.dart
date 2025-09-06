import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:example/src/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:mocktail/mocktail.dart';

// Mock 클래스 정의
class MockCounter extends Mock implements CounterEnvironment {}

// --- TCA Bloc 테스트 스위트 ---
class CounterBlocTestSuite
    extends BlocTestSuite<CounterTcaBloc, CounterState, CounterActions, MockCounter> {
  @override
  MockCounter createMockEnvironment() => MockCounter();

  @override
  CounterState getInitialState() => const CounterState(); // CounterState.initial()과 동일

  @override
  CounterTcaBloc buildBloc() => CounterTcaBloc(mockEnvironment);
}

void main() {
  group('CounterBloc: 수동테스트', () {
    late MockCounter mockEnvironment;

    setUp(() {
      mockEnvironment = MockCounter();
    });

    // Initial 테스트
    blocTest<CounterTcaBloc, CounterState>(
      '블록이 초기 상태로 시작하는지 확인',
      build: () => CounterTcaBloc(mockEnvironment),
      expect: () => [], // 초기 상태는 build 시점에 이미 설정되므로 추가적인 emit 없음
      verify: (bloc) {
        expect(bloc.state, CounterState.initial());
      },
    );

    // Increment 테스트
    blocTest<CounterTcaBloc, CounterState>(
      'Increment 액션 시 count가 1 증가하는지 확인',
      build: () => CounterTcaBloc(mockEnvironment),
      act: (bloc) => bloc.add(CounterActions.increment()),
      expect: () => [CounterState(count: 1, isLoading: false, error: null)],
    );

    // Decrement 테스트
    blocTest<CounterTcaBloc, CounterState>(
      'Decrement 액션 시 count가 1 감소하는지 확인',
      build: () => CounterTcaBloc(mockEnvironment),
      act: (bloc) => bloc.add(CounterActions.decrement()),
      expect: () => [CounterState(count: -1, isLoading: false, error: null)],
    );

    // Reset 테스트
    blocTest<CounterTcaBloc, CounterState>(
      'Reset 액션 시 상태가 초기화되는지 확인',
      build: () => CounterTcaBloc(mockEnvironment),
      seed: () => CounterState(count: 10, isLoading: true, error: 'some error'),
      act: (bloc) => bloc.add(CounterActions.reset()),
      expect: () => [CounterState.initial()],
    );

    // incrementAsync 액션 성공 시 count가 업데이트되고 isLoading이 false가 되는지 확인
    blocTest<CounterTcaBloc, CounterState>(
      'incrementAsync 성공 시 count가 업데이트되고 isLoading이 false가 된다',
      build: () => CounterTcaBloc(mockEnvironment),
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
    blocTest<CounterTcaBloc, CounterState>(
      'incrementAsync 실패 시 error가 설정되고 isLoading이 false가 된다',
      build: () => CounterTcaBloc(mockEnvironment),
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

    // Success 테스트 (내부적으로 호출되지만, 명시적 테스트)
    blocTest<CounterTcaBloc, CounterState>(
      'AsyncIncrementSuccess 액션 시 상태가 올바르게 업데이트되는지 확인',
      build: () => CounterTcaBloc(mockEnvironment),
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.success(10)),
      expect: () => [CounterState(count: 10, isLoading: false, error: null)],
    );

    // Failed 테스트 (내부적으로 호출되지만, 명시적 테스트)
    blocTest<CounterTcaBloc, CounterState>(
      'AsyncIncrementFailed 액션 시 에러가 설정되는지 확인',
      build: () => CounterTcaBloc(mockEnvironment),
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.failed('API 호출 실패')),
      expect: () => [CounterState(count: 5, isLoading: false, error: 'API 호출 실패')],
    );
  });

  group('CounterBloc: BlocTestSuite 테스트', () {
    final testSuite = CounterBlocTestSuite();
    testSuite.initTestSuite(); // setUp 및 tearDown 자동 실행

    // initial 테스트
    blocTest<CounterTcaBloc, CounterState>(
      '블록이 초기 상태로 시작하는지 확인',
      build: () => testSuite.buildBloc(),
      expect: () => [],
      verify: (bloc) {
        expect(bloc.state, CounterState.initial());
      },
    );

    // Increment 테스트
    blocTest<CounterTcaBloc, CounterState>(
      'Increment 액션 시 count가 1 증가하는지 확인',
      build: () => testSuite.buildBloc(),
      act: (bloc) => bloc.add(CounterActions.increment()),
      expect: () => [CounterState(count: 1, isLoading: false, error: null)],
    );

    // Decrement 테스트
    blocTest<CounterTcaBloc, CounterState>(
      'Decrement 액션 시 count가 1 감소하는지 확인',
      build: () => testSuite.buildBloc(),
      act: (bloc) => bloc.add(CounterActions.decrement()),
      expect: () => [CounterState(count: -1, isLoading: false, error: null)],
    );

    // Reset 테스트
    blocTest<CounterTcaBloc, CounterState>(
      'Reset 액션 시 상태가 초기화되는지 확인',
      build: () => testSuite.buildBloc(),
      seed: () => CounterState(count: 10, isLoading: true, error: 'some error'),
      act: (bloc) => bloc.add(CounterActions.reset()),
      expect: () => [CounterState.initial()],
    );

    // incrementAsync 액션 성공 시 count가 업데이트되고 isLoading이 false가 되는지 확인
    blocTest<CounterTcaBloc, CounterState>(
      'incrementAsync 성공 시 count가 업데이트되고 isLoading이 false가 된다',
      build: () => testSuite.buildBloc(),
      setUp: () {
        // 비동기 증가 성공 시 TaskEither.right(5)를 반환하도록 Mocking
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
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
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    // incrementAsync 액션 실패 시 error가 설정되고 isLoading이 false가 되는지 확인
    blocTest<CounterTcaBloc, CounterState>(
      'incrementAsync 실패 시 error가 설정되고 isLoading이 false가 된다',
      build: () => testSuite.buildBloc(),
      setUp: () {
        // 비동기 증가 실패 시 TaskEither.left(exception)을 반환하도록 Mocking
        final exception = Exception("Cannot increment beyond 5!");
        when(
          () => testSuite.mockEnvironment.performAsyncIncrement(
            currentCount: any(named: 'currentCount'),
          ),
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
        verify(() => testSuite.mockEnvironment.performAsyncIncrement(currentCount: 0)).called(1);
      },
    );

    // Success 테스트 (내부적으로 호출되지만, 명시적 테스트)
    blocTest<CounterTcaBloc, CounterState>(
      'Success 액션 시 상태가 올바르게 업데이트되는지 확인',
      build: () => testSuite.buildBloc(),
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.success(10)),
      expect: () => [CounterState(count: 10, isLoading: false, error: null)],
    );

    // Failed 테스트 (내부적으로 호출되지만, 명시적 테스트)
    blocTest<CounterTcaBloc, CounterState>(
      'Failed 액션 시 에러가 설정되는지 확인',
      build: () => testSuite.buildBloc(),
      seed: () => CounterState(count: 5, isLoading: true, error: null),
      act: (bloc) => bloc.add(CounterActions.failed('API 호출 실패')),
      expect: () => [CounterState(count: 5, isLoading: false, error: 'API 호출 실패')],
    );
  });
}