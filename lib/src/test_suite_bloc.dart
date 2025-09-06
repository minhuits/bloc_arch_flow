part of 'test_suite.dart';

/// An abstract class for BLoC testing that helps integrate specific
/// architectural patterns like MVI (Model-View-Intent) or TCA
/// (The Composable Architecture) to write structured test code.
///
/// This class explicitly defines the **user's intent (Intent)** or
/// **action (Action)** that the BLoC handles through the `T` generic,
/// which clarifies the meaning and purpose of each test.
///
/// ### Generic Parameters
///
/// - **`BlocType extends Bloc<T, State>`**: The type of the BLoC being tested.
/// - **`State`**: The type of the state managed by the BLoC.
/// - **`T`**: The type representing the BLoC's events, such as an MVI `Intent`
///   or a TCA `Action`.
/// - **`EnvironmentMock`**: The container type for the mock objects that
///   the BLoC depends on.
///
/// ### Usage Examples
///
/// #### 1. MVI Pattern
/// When using a user's intent (`Intent`) as an event.
///
/// ```dart
/// // Using LoginIntent as an event in LoginBloc
/// class LoginBlocTestSuite extends BlocTestSuite<
///     LoginBloc,
///     LoginState,
///     LoginIntent, // T = LoginIntent
///     LoginEnvironment
/// > {
///   @override
///   LoginBloc buildBloc(LoginEnvironment environment) => throw UnimplementedError();
///
///   @override
///   LoginEnvironment buildEnvironment() => throw UnimplementedError();
/// }
/// ```
///
/// #### 2. TCA Pattern
/// When using an action (`Action`) as an event to change the state.
///
/// ```dart
/// // Using CounterAction as an event in CounterBloc
/// class CounterBlocTestSuite extends BlocTestSuite<
///     CounterBloc,
///     int,
///     CounterAction, // T = CounterAction
///     void // Use void if there are no dependencies
/// > {
///   @override
///   CounterBloc buildBloc(void environment) => throw UnimplementedError();
///
///   @override
///   void buildEnvironment() => throw UnimplementedError();
/// }
/// ```
/// ---
/// BLoC 테스트를 위한 추상 클래스로, MVI (Model-View-Intent) 또는
/// TCA (The Composable Architecture)와 같은 특정 아키텍처 패턴을
/// 통합하여 테스트 코드를 작성할 수 있도록 돕습니다.
///
/// 이 클래스는 `T` 제네릭을 통해 BLoC이 처리하는 **사용자의 의도(Intent)**나
/// **액션(Action)**을 명시적으로 정의하여 테스트의 의미를 명확하게 만듭니다.
///
/// ### 제네릭 타입 (Generic Parameters)
///
/// - **`BlocType extends Bloc<T, State>`**: 테스트 대상이 되는 BLoC의 타입입니다.
/// - **`State`**: BLoC이 관리하는 상태의 타입입니다.
/// - **`T`**: MVI의 `Intent` 또는 TCA의 `Action`과 같이, BLoC의 이벤트를 나타내는 타입입니다.
/// - **`EnvironmentMock`**: BLoC이 의존하는 모의(Mock) 객체들을 담는 컨테이너 타입입니다.
///
/// ### 사용 예제 (Usage Examples)
///
/// #### 1. MVI 패턴
/// 사용자의 의도(`Intent`)를 이벤트로 사용하는 경우.
///
/// ```dart
/// // LoginBloc에서 LoginIntent를 이벤트로 사용
/// class LoginBlocTestSuite extends BlocTestSuite<
///     LoginBloc,
///     LoginState,
///     LoginIntent, // T = LoginIntent
///     LoginEnvironment
/// > {
///   @override
///   LoginBloc buildBloc(LoginEnvironment environment) => throw UnimplementedError();
///
///   @override
///   LoginEnvironment buildEnvironment() => throw UnimplementedError();
/// }
/// ```
///
/// #### 2. TCA 패턴
/// 액션(`Action`)을 이벤트로 사용하여 상태를 변경하는 경우.
///
/// ```dart
/// // CounterBloc에서 CounterAction을 이벤트로 사용
/// class CounterBlocTestSuite extends BlocTestSuite<
///     CounterBloc,
///     int,
///     CounterAction, // T = CounterAction
///     void // 의존성이 없는 경우 void 사용
/// > {
///   @override
///   CounterBloc buildBloc(void environment) => throw UnimplementedError();
///
///   @override
///   void buildEnvironment() => throw UnimplementedError();
/// }
/// ```
abstract class BlocTestSuite<BlocType extends Bloc<T, State>, State, T, EnvironmentMock>
    extends BlocTestSuiteBase<BlocType, State, EnvironmentMock> {}