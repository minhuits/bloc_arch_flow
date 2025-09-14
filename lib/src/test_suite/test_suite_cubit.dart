part of 'test_suite.dart';

/// A test suite base class specifically for a [Cubit] that follows the Bloc Arch Flow pattern.
///
/// This class extends [BlocBaseTestSuite] and adds a generic type constraint to `BlocType`,
/// ensuring it must be a [Cubit]. This provides more specific type safety and improves readability
/// for tests focused on a Cubit, which only handles state changes directly without events.
///
/// **Type Parameters:**
/// - [Cubit]: The specific type of the Cubit being tested. It must extend `Cubit<State>`.
/// - [State]: The type of the state managed by the Cubit.
/// - [Environment]: The mock class for the Cubit's dependencies.
///
/// **Example Usage:**
/// ```dart
/// // Assuming the following classes exist:
/// // - class CounterCubit extends Cubit<CounterState> {...}
/// // - class CounterState { ... }
/// // - class MockCounterEnvironment extends Mock implements CounterEnvironment {...}
///
/// class CounterCubitTestSuite extends CubitTestSuite<CounterCubit, CounterState, MockCounterEnvironment> {
///   @override
///   MockCounterEnvironment createMockEnvironment() => MockCounterEnvironment();
///
///   @override
///   CounterState getInitialState() => const CounterState();
///
///   @override
///   CounterCubit buildBloc() => CounterCubit(mockEnvironment);
/// }
///
/// void main() {
///   final suite = CounterCubitTestSuite();
///   group('CounterCubit', () {
///     suite.initTestSuite();
///
///     suite.blocArchTest(
///       'should emit a new state with an incremented count',
///       act: (cubit) => cubit.increment(),
///       expect: () => const <CounterState>[CounterState(count: 1)],
///     );
///   });
/// }
/// ```
///
/// ---
///
/// Bloc Arch Flow 패턴을 따르는 [Cubit]을 위한 테스트 스위트 기본 클래스입니다.
///
/// 이 클래스는 [BlocBaseTestSuite]를 확장하고 `BlocType`에 제네릭 타입 제약 조건을
/// 추가하여, 반드시 [Cubit]이어야 함을 보장합니다. 이를 통해 이벤트 없이 상태 변화만
/// 직접 처리하는 Cubit에 특화된 테스트를 위한 타입 안정성과 가독성을 높입니다.
///
/// **타입 매개변수:**
/// - [Cubit]: 테스트할 Cubit의 특정 타입. `Cubit<State>`를 확장해야 합니다.
/// - [State]: Cubit이 관리하는 상태의 타입.
/// - [Environment]: Cubit의 의존성에 대한 Mock 클래스.
///
/// **사용 예시:**
/// ```dart
/// // 다음 클래스들이 존재한다고 가정합니다:
/// // - class CounterCubit extends Cubit<CounterState> {...}
/// // - class CounterState { ... }
/// // - class MockCounterEnvironment extends Mock implements CounterEnvironment {...}
///
/// class CounterCubitTestSuite extends CubitTestSuite<CounterCubit, CounterState, MockCounterEnvironment> {
///   @override
///   MockCounterEnvironment createMockEnvironment() => MockCounterEnvironment();
///
///   @override
///   CounterState getInitialState() => const CounterState();
///
///   @override
///   CounterCubit buildBloc() => CounterCubit(mockEnvironment);
/// }
///
/// void main() {
///   final suite = CounterCubitTestSuite();
///   group('CounterCubit', () {
///     suite.initTestSuite();
///
///     suite.blocArchTest(
///       '카운트가 증가된 새 상태를 방출해야 합니다',
///       act: (cubit) => cubit.increment(),
///       expect: () => const <CounterState>[CounterState(count: 1)],
///     );
///   });
/// }
/// ```
abstract class CubitTestSuite<Cubit extends bloc.Cubit<State>, State, Environment>
    extends BlocBaseTestSuite<Cubit, State, Environment> {}

/// A test suite base class specifically for an MVI (Model-View-Intent) formatted Cubit.
///
/// This class extends `CubitTestSuite` and provides a set of helper functions
/// for testing the core MVI principles: state changes and side effects.
///
/// **Type Parameters:**
/// - [C]: The specific type of the MviCubit being tested.
/// - [I]: The type of the Intent (user action).
/// - [S]: The type of the State managed by the Cubit.
/// - [Effect]: The type of the side effects.
/// - [Environment]: The mock class for the Cubit's dependencies.
///
/// ---
/// MVI(Model-View-Intent) 형식의 Cubit을 위한 테스트 스위트 기본 클래스입니다.
///
/// 이 클래스는 [CubitTestSuite]를 확장하며, MVI의 핵심 원칙인 상태 변화와
/// 부수 효과를 테스트하기 위한 헬퍼 함수들을 제공합니다.
///
/// **타입 매개변수:**
/// - [C]: 테스트할 MviCubit의 특정 타입.
/// - [I]: 인텐트(사용자 액션)의 타입.
/// - [S]: Cubit이 관리하는 상태의 타입.
/// - [Effect]: 부수 효과의 타입.
/// - [Environment]: Cubit의 의존성에 대한 Mock 클래스.
abstract class MviCubitTestSuite<C extends MviCubit<I, S, Effect>, I, S, Effect, Environment>
    extends CubitTestSuite<C, S, Environment>
    with TestSuiteUtilityMixin {
  /// A core helper method for triggering an Intent and waiting for the Cubit's
  /// asynchronous logic to complete.
  ///
  /// This method is intended for internal use within the test suite to ensure
  /// consistent `async/await` handling.
  ///
  /// **Parameters:**
  /// - [intent]: The Intent to be handled by the Cubit.
  ///
  /// ---
  /// 인텐트를 트리거하고 Cubit의 비동기 로직이 완료될 때까지 기다리는 핵심 헬퍼 메서드입니다.
  ///
  /// 이 메서드는 테스트 스위트 내에서 일관된 `async/await` 처리를 보장하기 위해
  /// 내부적으로 사용됩니다.
  ///
  /// **매개변수:**
  /// - [intent]: Cubit이 처리할 인텐트.
  @protected
  Future<void> cubitIntentTest(I intent) async {
    await mockBaseBloc.onIntent(intent);
  }

  /// A comprehensive test function that combines both state change and side effect
  /// validation for a given Intent.
  ///
  /// It groups two separate tests ([blocTest] for state and [test] for effects)
  /// for a clear and structured test report. Use this for complex intents that
  /// affect both the state and produce a side effect.
  ///
  /// **Parameters:**
  /// - [description]: A description for the test group.
  /// - [intent]: The Intent to be tested.
  /// - [loadingState]: (Optional) The state emitted during an asynchronous loading process.
  /// - [finalState]: The final state expected after the operation.
  /// - [expectedEffect]: The side effect expected to be emitted.
  /// - [setUp]: (Optional) Additional setup to run before each test in the group.
  /// - [wait]: (Optional) The duration to wait before asserting.
  ///
  /// **Example:**
  /// ```dart
  /// class CounterCubitTestSuite extends MviCubitTestSuite<
  ///   CounterCubit, CounterIntent, CounterState, CounterEffect, MockCounterEnvironment,
  /// > {
  ///   // Implementation of abstract methods...
  /// }
  ///
  /// final suite = CounterCubitTestSuite();
  ///
  /// // Async operation that updates state and shows a toast
  /// group('CounterMviCubit', () {
  ///   suite.initTestSuite();
  ///   suite.testCubitGroup(
  ///     'should emit incremented state and a toast on successful async increment',
  ///     intent: const CounterIntent.incrementAsync(),
  ///     loadingState: const CounterState(isLoading: true),
  ///     finalState: const CounterState(count: 1, isLoading: false),
  ///     expectedEffect: const CounterEffect.showToast('Incremented successfully!'),
  ///     setUp: () {
  ///       when(
  ///         () => suite.mockEnvironment.performAsyncIncrement(any()),
  ///       ).thenAnswer((_) => TaskEither.right(1));
  ///     },
  ///   );
  /// });
  /// ```
  ///
  /// ---
  /// 주어진 인텐트에 대한 상태 변화와 부수 효과를 모두 검증하는 포괄적인 테스트 함수입니다.
  ///
  /// 이 함수는 두 개의 개별 테스트(`blocTest`와 `test`)를 `group`으로 묶어
  /// 명확하고 구조화된 테스트 리포트를 제공합니다. 상태를 변경하고 부수 효과를
  /// 발생시키는 복잡한 인텐트에 사용됩니다.
  ///
  /// **매개변수:**
  /// - [description]: 테스트 그룹에 대한 설명.
  /// - [intent]: 테스트할 인텐트.
  /// - [loadingState]: (선택 사항) 비동기 로딩 과정 중에 방출되는 상태.
  /// - [finalState]: 작업 완료 후 예상되는 최종 상태.
  /// - [expectedEffect]: 방출될 것으로 예상되는 부수 효과.
  /// - [setUp]: (선택 사항) 그룹 내 각 테스트 실행 전 추가 설정.
  /// - [wait]: (선택 사항) 검증 전 기다릴 시간.
  @isTest
  void testCubitGroup(
    String description, {
    required I intent,
    S? loadingState,
    required S finalState,
    required Effect expectedEffect,
    FutureOr<void> Function()? setUp,
    Duration? wait,
  }) {
    group(description, () {
      // 상태 변경 테스트
      blocTest(
        'State',
        build: () => buildMockBaseBloc(),
        setUp: setUp,
        act: (C cubit) async {
          await cubit.onIntent(intent);
        },
        wait: wait,
        expect: () {
          final List<S> expected = [];
          if (loadingState != null) {
            expected.add(loadingState);
          }
          expected.add(finalState);
          return expected;
        },
      );

      // 부수 효과 테스트
      test('Side Effect', () async {
        // 1. setUp을 먼저 호출하여 Mocking 설정을 적용합니다.
        if (setUp != null) {
          await setUp();
        }

        // 2. Mocking이 적용된 `mockEnvironment`를 사용하는 Cubit 인스턴스를 빌드합니다.
        // 이 로직이 buildMockBaseBloc() 함수 내에 올바르게 구현되어 있어야 합니다.
        final C cubit = buildMockBaseBloc();

        // 3. expectLater를 사용하여 부수 효과를 구독합니다.
        final Future<void> effectsSubscription = expectLater(
          cubit.effects,
          emitsInOrder([expectedEffect]),
        );

        // 4. 인텐트를 실행하고, 비동기 작업이 완료되기를 기다립니다.
        await cubit.onIntent(intent);

        // 5. 모든 부수 효과가 방출되기를 기다립니다.
        await effectsSubscription;
      });
    });
  }

  /// A specialized test function for validating pure state changes without
  /// any side effects.
  ///
  /// Use this for intents that only update the Cubit's state based on
  /// synchronous or asynchronous logic, but do not produce effects like
  /// navigating or showing toasts.
  ///
  /// **Parameters:**
  /// - [description]: A description for the test case.
  /// - [intent]: The Intent to be tested.
  /// - [expectedState]: The single state expected after the operation.
  /// - [setUp]: (Optional) Additional setup to run before the test.
  ///
  /// **Example:**
  /// ```dart
  /// final suite = CounterCubitTestSuite();
  ///
  /// // Simple sync operation that only updates state
  /// group('CounterMviCubit', () {
  ///   suite.initTestSuite();
  ///   suite.testState(
  ///     'should emit an incremented state on sync increment',
  ///     intent: const CounterIntent.increment(),
  ///     expectedState: const CounterState(count: 1),
  ///   );
  /// });
  /// ```
  ///
  /// ---
  /// 부수 효과 없이 순수한 상태 변화만 검증하기 위한 특화된 테스트 함수입니다.
  ///
  /// 이 함수는 동기 또는 비동기 로직에 따라 Cubit의 상태만 업데이트하고,
  /// 내비게이션이나 토스트 표시와 같은 부수 효과를 발생시키지 않는 인텐트에 사용됩니다.
  ///
  /// **매개변수:**
  /// - [description]: 테스트 케이스에 대한 설명.
  /// - [intent]: 테스트할 인텐트.
  /// - [expectedState]: 작업 후 예상되는 단일 상태.
  /// - [setUp]: (선택 사항) 테스트 실행 전 추가 설정
  @isTest
  void testState(
    String description, {
    required I intent,
    required S expectedState,
    FutureOr<void> Function()? setUp,
  }) {
    blocTest(
      description,
      build: () => buildMockBaseBloc(),
      setUp: setUp,
      act: (C cubit) async {
        await cubit.onIntent(intent);
      },
      expect: () => [expectedState],
    );
  }

  /// A specialized test function for validating a pure side effect without
  /// any state changes.
  ///
  /// This is useful for testing intents that trigger an action (e.g., a network request)
  /// which might update the state later, but the immediate intent
  /// only produces a side effect.
  ///
  /// **Parameters:**
  /// - [description]: A description for the test case.
  /// - [intent]: The Intent to be tested.
  /// - [expectedEffect]: The side effect expected to be emitted.
  /// - [setUp]: (Optional) Additional setup to run before the test.
  ///
  /// **Example:**
  /// ```dart
  /// final suite = CounterCubitTestSuite();
  ///
  /// // Async operation that only shows a toast and no state change
  /// group('CounterMviCubit', () {
  ///   suite.initTestSuite();
  ///   suite.testSideEffect(
  ///     'should emit a toast effect on a failed async operation',
  ///     intent: const CounterIntent.incrementAsync(),
  ///     expectedEffect: const CounterEffect.showToast('Increment failed!'),
  ///     setUp: () {
  ///       when(
  ///         () => suite.mockEnvironment.performAsyncIncrement(any()),
  ///       ).thenAnswer((_) => TaskEither.left(Exception('Error')));
  ///     },
  ///   );
  /// });
  /// ```
  ///
  /// ---
  /// 상태 변화 없이 순수한 부수 효과만 검증하기 위한 특화된 테스트 함수입니다.
  ///
  /// 이 함수는 즉각적인 상태 변화 없이 부수 효과만 발생하는 인텐트(예: 네트워크 요청)를
  /// 테스트할 때 유용합니다.
  ///
  /// **매개변수:**
  /// - [description]: 테스트 케이스에 대한 설명.
  /// - [intent]: 테스트할 인텐트.
  /// - [expectedEffect]: 방출될 것으로 예상되는 부수 효과.
  /// - [setUp]: (선택 사항) 테스트 실행 전 추가 설정.
  @isTest
  void testSideEffect(
    String description, {
    required I intent,
    required Effect expectedEffect,
    FutureOr<void> Function()? setUp,
    Duration? wait,
  }) {
    test(description, () async {
      if (setUp != null) {
        await setUp();
      }

      final C cubit = buildMockBaseBloc();
      final Future<void> effectsSubscription = expectLater(
        cubit.effects,
        emitsInOrder([expectedEffect]),
      );

      await cubit.onIntent(intent);

      if (wait != null) {
        await Future.delayed(wait);
      }

      await effectsSubscription;
    });
  }
}