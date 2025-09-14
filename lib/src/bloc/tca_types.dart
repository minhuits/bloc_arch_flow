part of 'tca_core.dart';

/// Represents a composable side effect using the `fpdart` library.
///
/// It's a [TaskEither] that encapsulates a potentially failing asynchronous operation.
/// The [TcaEffect] type unifies the success and failure outcomes of a task
/// by mapping both to a new [Action] that can be dispatched back to the reducer.
///
/// **Type Parameters:**
/// - [Action]: The type of action to be dispatched upon successful or failed completion of the effect.
///
/// ---
/// `fpdart` 라이브러리를 사용한 컴포저블 부수 효과를 나타냅니다.
///
/// 이 타입은 실패할 수 있는 비동기 작업을 캡슐화하는 [TaskEither]입니다.
/// [TcaEffect]는 작업의 성공 및 실패 결과를 모두 리듀서로 다시 디스패치할 수 있는
/// 새로운 [Action]으로 매핑하여 결과를 통합합니다.
///
/// **타입 매개변수:**
/// - [Action]: 부수 효과가 성공 또는 실패로 완료되었을 때 디스패치할 액션의 타입.
///
/// ### **Example**
///
/// ```dart
/// TcaEffect<Action> loginEffect(LoginRequest request) {
///   final apiCall = TaskEither<LoginError, LoginResult>.tryCatch(
///     () => loginService.performLogin(request),
///     (e, s) => LoginError.unknown(),
///   );
///
///   return effectBuilder(
///     task: apiCall,
///     onSuccess: (result) => LoginAction.loginSucceeded(result.user),
///     onFailure: (error) => LoginAction.loginFailed(error.message),
///   );
/// }
/// ```
typedef TcaEffect<Action> = TaskEither<Action, Action>;

/// Represents the result from a TCA-style reducer.
///
/// This type bundles the new state derived from an action and an optional side effect.
///
/// **Fields:**
/// - [newState]: The updated state calculated by the reducer.
/// - [effect]: A side effect to be executed after the state change.
///
/// ---
/// TCA 스타일 리듀서의 결과를 나타냅니다.
///
/// 액션으로부터 도출된 새로운 상태와 선택적인 부수 효과를 묶는 타입입니다.
///
/// **필드:**
/// - [newState]: 리듀서에 의해 계산된 업데이트된 상태.
/// - [effect]: 상태 변경 후 실행될 부수 효과.
final class TcaReducer<Action, State> {
  final State newState;
  final TcaEffect<Action> effect;

  const TcaReducer._(this.effect, this.newState);

  /// A factory constructor for creating a [TcaReducer] that represents a pure
  /// state change without any side effects.
  ///
  /// This is a convenient way to signify that an action results in a state update
  /// but does not require any side effect. It internally uses `TaskEither.of` to
  /// wrap a special "none" action, which ensures the effect is never null and
  /// maintains the integrity of the TCA pattern. This concept is analogous to a
  /// **pure function** in functional programming.
  ///
  /// **Parameters:**
  /// - [action]: The special "none" action that signifies no meaningful side effect.
  /// - [newState]: The new state after the reducer has processed the action.
  ///
  /// **Example:**
  /// ```dart
  /// // A special `none` action that signifies no side effect.
  /// enum CounterAction {
  ///   increment,
  ///   decrement,
  ///   none, // The "no-op" action
  /// }
  ///
  /// TcaReducer<CounterAction, int> counterReducer(CounterAction action, int state) {
  ///   switch (action) {
  ///     case CounterAction.increment:
  ///       return TcaReducer.pure(action: CounterAction.none, newState: state + 1);
  ///     case CounterAction.decrement:
  ///       return TcaReducer.pure(action: CounterAction.none, newState: state - 1);
  ///     case CounterAction.none:
  ///       return TcaReducer.pure(action: CounterAction.none, newState: state);
  ///   }
  /// }
  /// ```
  ///
  /// ---
  /// 부수 효과가 없는 **순수한(pure)** 상태 변화를 나타내는 [TcaReducer]를 생성하는 팩토리 생성자입니다.
  ///
  /// 이 함수는 액션의 결과로 상태 변화는 발생하지만, 어떤 부수 효과도 필요하지 않음을
  /// 명시적으로 표현하는 편리한 방법입니다. 내부적으로 특별한 "none" 액션을 `TaskEither.of`로
  /// 감싸, 효과가 절대 null이 아니며 TCA 패턴의 무결성을 유지하도록 합니다. 이 개념은
  /// 함수형 프로그래밍의 **순수 함수**와 유사합니다.
  ///
  /// **매개변수:**
  /// - [action]: 의미 있는 부수 효과가 없음을 나타내는 특별한 "none" 액션.
  /// - [newState]: 리듀서가 액션을 처리한 후의 새로운 상태.
  ///
  /// **사용 예시:**
  /// ```dart
  /// // 부수 효과가 없음을 나타내는 특별한 'none' 액션.
  /// enum CounterAction {
  ///   increment,
  ///   decrement,
  ///   none, // "no-op" 액션
  /// }
  ///
  /// TcaReducer<CounterAction, int> counterReducer(CounterAction action, int state) {
  ///   switch (action) {
  ///     case CounterAction.increment:
  ///       return TcaReducer.pure(action: CounterAction.none, newState: state + 1);
  ///     case CounterAction.decrement:
  ///       return TcaReducer.pure(action: CounterAction.none, newState: state - 1);
  ///     case CounterAction.none:
  ///       return TcaReducer.pure(action: CounterAction.none, newState: state);
  ///   }
  /// }
  /// ```
  factory TcaReducer.pure({required State newState, required Action action}) {
    return TcaReducer._(TaskEither.of(action), newState);
  }

  /// Creates a [TcaReducer] with a state change and an explicit side effect.
  ///
  /// This factory is used when an action results in a state update and
  /// also requires performing a side effect, such as an API call or timer.
  ///
  /// ---
  /// 상태 변화와 명시적인 부수 효과를 포함하는 [TcaReducer]를 생성합니다.
  ///
  /// 액션이 상태를 업데이트하고, API 호출이나 타이머와 같은 부수 효과를
  /// 수행해야 할 때 이 팩토리를 사용합니다.
  factory TcaReducer.withEffect({required State newState, required TcaEffect<Action> effect}) {
    return TcaReducer._(effect, newState);
  }
}