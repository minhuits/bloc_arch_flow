part of 'test_suite.dart';

/// A test suite base class specifically for a [Cubit] that follows the Bloc Arch Flow pattern.
///
/// This class extends [BlocTestSuiteBase] and adds a generic type constraint to `BlocType`,
/// ensuring it must be a [Cubit]. This provides more specific type safety and improves readability
/// for tests focused on a Cubit, which only handles state changes directly without events.
///
/// **Type Parameters:**
/// - [BlocType]: The specific type of the Cubit being tested. It must extend `Cubit<State>`.
/// - [State]: The type of the state managed by the Cubit.
/// - [EnvironmentMock]: The mock class for the Cubit's dependencies.
///
/// **Example Usage:**
/// ```dart
/// // Assuming the following classes exist:
/// // - class CounterCubit extends Cubit<CounterState>
/// // - class CounterState { ... }
/// // - class MockCounterEnvironment extends Mock implements CounterEnvironment
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
/// 이 클래스는 [BlocTestSuiteBase]를 확장하고 `BlocType`에 제네릭 타입 제약 조건을
/// 추가하여, 반드시 [Cubit]이어야 함을 보장합니다. 이를 통해 이벤트 없이 상태 변화만
/// 직접 처리하는 Cubit에 특화된 테스트를 위한 타입 안정성과 가독성을 높입니다.
///
/// **타입 매개변수:**
/// - [BlocType]: 테스트할 Cubit의 특정 타입. `Cubit<State>`를 확장해야 합니다.
/// - [State]: Cubit이 관리하는 상태의 타입.
/// - [EnvironmentMock]: Cubit의 의존성에 대한 Mock 클래스.
///
/// **사용 예시:**
/// ```dart
/// // 다음 클래스들이 존재한다고 가정합니다:
/// // - class CounterCubit extends Cubit<CounterState>
/// // - class CounterState { ... }
/// // - class MockCounterEnvironment extends Mock implements CounterEnvironment
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
abstract class CubitTestSuite<BlocType extends Cubit<State>, State, EnvironmentMock>
    extends BlocTestSuiteBase<BlocType, State, EnvironmentMock> {}