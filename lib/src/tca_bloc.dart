import 'package:bloc/bloc.dart' show Bloc;
import 'package:flutter/foundation.dart' show protected;
import 'package:fpdart/fpdart.dart' show TaskEither;

/// Typedef for defining the result returned by a TCA Reducer.
/// This typedef is a record type that includes a new [State] and an [effect]
/// representing an asynchronous operation.
/// - [newState]: The new Bloc [State] calculated after processing an action.
/// - [effect]: An [effect] of type [TaskEither<Object, Action>], representing a side effect.
///   If the effect succeeds, it returns an [Action] that can be re-injected into the system;
///   if it fails, it returns an error of type [Object].
///---
/// TCA 리듀서가 반환하는 결과를 정의하는 typedef입니다.
/// 이 typedef는 새로운 [State]와 함께 비동기 작업을 나타내는 [effect]를 포함하는 레코드 타입입니다.
/// - [newState]: 액션 처리 후 계산된 새로운 Bloc의 상태입니다.
/// - [effect]: [TaskEither<Object, Action>] 타입으로, 부수 효과를 나타냅니다.
///   이펙트가 성공하면 [Action]을 반환하여 시스템에 다시 주입될 수 있고,
///   실패하면 [Object] 타입의 오류를 반환합니다.
typedef ReducerEffect<State, Action> = ({State newState, TaskEither<Object, Action> effect});

/// Abstract base class for applying the TCA (The Composable Architecture) pattern to Bloc.
/// This class focuses on a pure functional reducer approach centered around [fpdart].
/// - [Action]: Corresponds to a Bloc [Event], representing user or system actions.
/// - [State]: Represents the Bloc's state.
/// - [Environment]: A container for managing dependencies required by the business logic
///   (e.g., API services, databases).
///---
/// Bloc과 함께 TCA (The Composable Architecture) 패턴을 적용하기 위한 추상 클래스입니다.
/// 이 클래스는 [fpdart]를 중심으로 하는 순수 함수형 리듀서 접근 방식에 중점을 둡니다.
/// - [Action]: 사용자 또는 시스템의 행동을 나타내는 Bloc의 [Event]에 해당합니다.
/// - [State]: Bloc의 상태를 나타냅니다.
/// - [Environment]: 비즈니스 로직에 필요한 의존성(예: API 서비스, 데이터베이스)을 관리하는 컨테이너입니다.
abstract class BlocArchTca<Action, State, Environment> extends Bloc<Action, State> {
  /// Environment dependency to be used in the reducer.
  /// It is injected when the Bloc is initialized via this constructor.
  /// ---
  /// 리듀서에서 사용될 환경(Environment) 종속성입니다.
  /// 이 생성자를 통해 Bloc이 초기화될 때 주입됩니다.
  final Environment environment;

  /// Constructor for [BlocArchTca].
  /// Calls the super [Bloc] class constructor to set the initial state and inject the environment.
  /// ---
  /// [BlocArchTca]의 생성자입니다.
  /// 상위 [Bloc] 클래스의 생성자를 호출하여 초기 상태를 설정하고 환경을 주입합니다.
  BlocArchTca(super.initialState, this.environment);

  /// A utility function using [fpdart]'s [TaskEither] to process asynchronous operations
  /// and transform their results back into an [Action].
  /// This function itself is pure. It only defines *what* effect (asynchronous operation) to perform and *how*
  /// to map its success or failure to an [Action].
  /// It does not directly execute the effect or update the Bloc's state.
  /// - [task]: The asynchronous operation to execute. ([L] is the failure type, [R] is the success type).
  /// - [onSuccess]: A callback function invoked when [task] completes successfully.
  ///   It should receive the success value ([R]) and return an [Action] corresponding to that success.
  /// - [onFailure]: A callback function invoked when [task] fails.
  ///   It should receive the failure value ([L]) and return an [Action] or [Object] (error) corresponding to that failure.
  /// This function is useful for defining asynchronous operations within the [tcaReducer]
  /// and transforming their outcomes back into Bloc [Action]s for re-injection into the system.
  /// ---
  /// [fpdart]의 [TaskEither]를 사용하여 비동기 작업을 처리하고 그 결과를 다시 [Action]으로 변환하는 유틸리티 함수입니다.
  /// 이 함수 자체는 순수합니다. 단지 *어떤* 효과(비동기 작업)를 수행하고
  /// 해당 작업의 성공 또는 실패를 *어떻게* [Action]으로 매핑할지 정의할 뿐입니다.
  /// 직접 효과를 실행하거나 Bloc의 상태를 업데이트하지 않습니다.
  /// - [task]: 실행할 비동기 작업입니다. ([L]은 실패 타입, [R]은 성공 타입).
  /// - [onSuccess]: [task]가 성공적으로 완료되었을 때 호출되는 콜백 함수입니다.
  ///   성공 값([R])을 받아 해당 성공에 대응하는 [Action]을 반환해야 합니다.
  /// - [onFailure]: [task]가 실패했을 때 호출되는 콜백 함수입니다.
  ///   실패 값([L])을 받아 해당 실패에 대응하는 [Action] 또는 [Object] (오류)를 반환해야 합니다.
  /// 이 함수는 [tcaReducer] 내부에서 비동기 작업을 정의하고 그 결과를 다시 Bloc의 [Action]으로
  /// 주입할 때 유용합니다.
  @protected
  TaskEither<L, Action> tcaPerformEffect<L, R>({
    required TaskEither<L, R> task,
    required Action Function(R successValue) onSuccess,
    required L Function(L failureValue) onFailure,
  }) {
    return task.map(onSuccess).mapLeft(onFailure);
  }

  /// An abstract function that processes an [Action], calculates a new state,
  /// and returns a side effect if necessary.
  /// This function plays a similar role to TCA's Reducer and is designed as a **pure function**.
  /// The reducer takes the current [Action], [currentState], and [environment] as input,
  /// and deterministically returns a new [State] and a [ReducerEffect] defining the [Effect] to be executed.
  /// **How it works:**
  /// 1. [tcaReducer] is called from within Bloc's `on<Action>` handler.
  /// 2. The `newState` from the returned `ReducerEffect` is used to update the Bloc's state
  ///    via `emit` within the `on<Action>` handler.
  /// 3. The `effect` ([TaskEither]) from the returned `ReducerEffect` is executed *after* the new state is emitted.
  /// 4. If the [Effect] succeeds, it returns an [Action] which can then be `add`ed back to the Bloc,
  ///    completing the action chaining cycle.
  /// **Important Considerations:**
  /// `emit` is NOT passed directly to this [tcaReducer].
  /// State transformation is done by returning `newState`,
  /// and the actual `emit` call occurs in the `on<Action>` handler after the reducer returns.
  /// This aligns with the pure functional nature of TCA reducers and maximizes testability.
  /// ---
  /// [Action]을 처리하고 새로운 상태를 계산하며, 필요한 경우 부수 효과를 반환하는 추상 함수입니다.
  /// 이 함수는 TCA의 Reducer와 유사한 역할을 하며 **순수 함수**로 설계됩니다.
  /// 리듀서는 현재 [Action], [currentState], [environment]를 입력으로 받아,
  /// 결정론적으로 새로운 [State]와 실행될 [Effect]를 정의하는 [ReducerEffect]를 반환합니다.
  /// **작동 방식:**
  /// 1. [tcaReducer]는 Bloc의 `on<Action>` 핸들러 내부에서 호출됩니다.
  /// 2. 반환된 `ReducerEffect`의 `newState`는 `on<Action>` 핸들러에서 `emit`을 통해 Bloc의 상태를 업데이트하는 데 사용됩니다.
  /// 3. 반환된 `ReducerEffect`의 `effect` ([TaskEither])는 새로운 상태가 방출된 *후* 실행됩니다.
  /// 4. [Effect]가 성공하면 [Action]을 반환하며, 이 [Action]은 다시 Bloc에 `add`되어 액션 순환(action chaining)이 이루어집니다.
  /// **중요 고려사항:**
  /// `emit`은 이 [tcaReducer]에 직접 전달되지 않습니다. 상태 변환은 `newState`를 반환함으로써 이루어지며,
  /// 실제 `emit` 호출은 리듀서가 반환된 후 `on<Action>` 핸들러에서 발생합니다. 이는 TCA 리듀서의
  /// 순수 함수적 특성과 일치하며 테스트 용이성을 극대화합니다.
  ReducerEffect<State, Action> tcaReducer(
    Action action,
    State currentState,
    Environment environment,
  );

  /// Calls the [close] method of the super [Bloc] class to complete resource cleanup when the Bloc is closed.
  /// ---
  /// Bloc이 닫힐 때 상위 Bloc 클래스의 close 메서드를 호출하여 리소스 정리를 완료합니다.
  @override
  Future<void> close() => super.close();
}