import 'package:bloc/bloc.dart' show Bloc, Cubit, Emitter;
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:meta/meta.dart' show protected;

/// Represents a composable side effect with `fpdart`.
///
/// It's a [TaskEither] that handles a potentially failing asynchronous operation.
///
/// - **Right (Success):** The type of action to be dispatched upon successful completion.
/// - **Left (Failure):** An `Object` representing a non-recoverable error.
///
/// ---
///
/// `fpdart`를 이용한 컴포저블 부수 효과를 나타냅니다.
///
/// 실패할 수 있는 비동기 작업을 처리하는 [TaskEither]입니다.
///
/// - **Right (성공):** 작업 성공 시 디스패치할 액션의 타입.
/// - **Left (실패):** 복구 불가능한 오류를 나타내는 `Object` 타입.
///
typedef TcaEffect<A> = TaskEither<Object, A>;

/// Represents the result from a TCA-style reducer.
///
/// This type bundles the new state derived from an action and an optional side effect.
///
/// - [newState]: The updated state calculated by the reducer.
/// - [effect]: A side effect defined as a [TcaEffect] to be executed after the state change.
///
/// ---
///
/// TCA 스타일 리듀서의 결과를 나타냅니다.
///
/// 액션으로부터 도출된 새로운 상태와 선택적인 부수 효과를 묶는 타입입니다.
///
/// - [newState]: 리듀서에 의해 계산된 업데이트된 상태.
/// - [effect]: 상태 변경 후 실행될 [TcaEffect]로 정의된 부수 효과.
///
typedef ReducerEffect<S, A> = ({TcaEffect<A> effect, S newState});

/// A mixin that provides core TCA-like functionality to both [Bloc] and [Cubit].
///
/// It encapsulates the pure reducer logic and the mechanism for building side effects,
/// abstracting them away from the state management framework's boilerplate.
///
/// - [A]: The Action type, which represents all possible user or system events.
/// - [S]: The State type, representing the UI state.
/// - [E]: The Environment type, holding all dependencies (e.g., API clients, databases).
///
/// ---
///
/// [Bloc]와 [Cubit]에 TCA의 핵심 기능을 제공하는 믹스인입니다.
///
/// 순수 리듀서 로직과 부수 효과를 생성하는 메커니즘을 캡슐화하여,
/// 상태 관리 프레임워크의 반복적인 코드로부터 분리합니다.
///
/// - [A]: 모든 가능한 사용자 또는 시스템 이벤트를 나타내는 액션 타입.
/// - [S]: UI 상태를 나타내는 상태 타입.
/// - [E]: 모든 의존성(예: API 클라이언트, 데이터베이스)을 담는 환경 타입.
///
mixin TcaMixin<A, S, E> {
  /// A pure utility to build a side effect with `fpdart`'s [TaskEither].
  ///
  /// This function takes a potentially failing asynchronous `task` and transforms its
  /// success or failure into a unified `TcaEffect` that returns an action `A`.
  /// The returned effect is a pure definition of the side effect, not its execution.
  ///
  /// **Core Logic:**
  /// 1.  Transforms the `Success` value of the input `task` into an action `A` using `onSuccess`.
  /// 2.  Transforms the `Failure` value into an action `A` using `onFailure`.
  /// 3.  Uses `.orElse()` to convert a failed task into a successful one (with an action).
  ///
  /// - [task]: The raw asynchronous operation, returning `Success` or `Failure`.
  /// - [onSuccess]: A callback to map a successful `Success` value to an action `A`.
  /// - [onFailure]: A callback to map a failed `Failure` value to an action `A`.
  /// - **Returns:** A [TcaEffect] that, upon execution, will yield an action `A` regardless of the original task's outcome.
  ///
  /// ---
  ///
  /// `fpdart`의 [TaskEither]로 부수 효과를 만드는 순수 유틸리티입니다.
  ///
  /// 이 함수는 잠재적으로 실패할 수 있는 비동기 `task`를 받아, 그 성공 또는 실패를
  /// 액션 `A`를 반환하는 통합된 `TcaEffect`로 변환합니다.
  /// 반환되는 효과는 부수 효과의 실행이 아닌, 순수한 정의일 뿐입니다.
  ///
  /// **핵심 로직:**
  /// 1. 입력 `task`의 `Success` 값을 `onSuccess`를 이용해 액션 `A`로 변환합니다.
  /// 2. `Failure` 값을 `onFailure`를 이용해 액션 `A`로 변환합니다.
  /// 3. `.orElse()`를 사용하여 실패한 태스크를 (액션과 함께) 성공적인 태스크로 변환합니다.
  ///
  /// - [task]: `Success` 또는 `Failure`를 반환하는 비동기 작업.
  /// - [onSuccess]: 성공적인 `Success` 값을 액션 `A`로 매핑하는 콜백.
  /// - [onFailure]: 실패한 `Failure` 값을 액션 `A`로 매핑하는 콜백.
  /// - **반환:** 원래 태스크의 결과와 상관없이 실행 시 액션 `A`를 생성하는 [TcaEffect].
  ///
  @protected
  TcaEffect<A> tcaEffectBuilder<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required A Function(Success success) onSuccess,
    required A Function(Failure failure) onFailure,
  }) {
    // 1. 성공 케이스를 먼저 map을 이용해 변환합니다.
    final TaskEither<Failure, A> success = task.map(onSuccess);

    // 2. 실패 시 실행될 로직을 변수로 정의합니다.
    TcaEffect<A> onTaskFailure(Failure failure) {
      final A action = onFailure(failure);
      return TcaEffect.right(action);
    }

    // 3. orElse 메서드에 정의된 함수를 전달하여 효과를 만듭니다.
    final TcaEffect<A> effect = success.orElse(onTaskFailure);

    return effect;
  }

  /// An abstract **pure function** that processes an action and returns a new state and effect.
  ///
  /// This is the core reducer logic, completely separate from the state management framework.
  /// It should contain no side effects, only pure business logic.
  ///
  /// - [action]: The action to process.
  /// - [state]: The current state of the BLoC/Cubit.
  /// - [environment]: The dependencies needed for the business logic.
  /// - **Returns:** A [ReducerEffect] containing the next state and a side effect.
  ///
  /// ---
  ///
  /// 액션을 처리하고 새로운 상태와 효과를 반환하는 추상적 **순수 함수**입니다.
  ///
  /// 상태 관리 프레임워크와 완벽하게 분리된 핵심 리듀서 로직입니다.
  /// 부수 효과 없이 오직 순수 비즈니스 로직만 포함해야 합니다.
  ///
  /// - [action]: 처리할 액션.
  /// - [state]: BLoC/Cubit의 현재 상태.
  /// - [environment]: 비즈니스 로직에 필요한 의존성.
  /// - **반환:** 다음 상태와 부수 효과를 담은 [ReducerEffect].
  ///
  @protected
  ReducerEffect<S, A> tcaReducer(A action, S state, E environment);
}

/// An abstract base class that applies the TCA pattern to [Bloc].
/// It provides a consistent entry point for handling actions and delegates to a pure reducer.
///
/// - [A]: Action type.
/// - [S]: State type.
/// - [E]: Environment type.
///
/// ---
///
/// [Bloc]에 TCA 패턴을 적용하는 추상 기본 클래스입니다.
/// 액션 처리를 위한 일관된 진입점을 제공하며, 순수 리듀서에 로직을 위임합니다.
///
/// - [A]: 액션 타입.
/// - [S]: 상태 타입.
/// - [E]: 환경 타입.
///
abstract class BlocArchTca<A, S, E> extends Bloc<A, S> with TcaMixin<A, S, E> {
  /// The dependencies for the BLoC.
  ///
  /// ---
  ///
  /// BLoC의 의존성입니다.
  final E environment;

  /// Creates a [BlocArchTca].
  ///
  /// ---
  ///
  /// [BlocArchTca]를 생성합니다.
  BlocArchTca(super.initialState, this.environment);

  /// A helper that runs the reducer and applies its results.
  ///
  /// This method handles the standard boilerplate: calling the reducer,
  /// emitting the new state, and executing any side effects.
  ///
  /// - [emit]: The [Emitter] provided by the BLoC framework.
  /// - [event]: The BLoC event to be processed.
  ///
  /// ---
  ///
  /// 리듀서를 실행하고 그 결과를 적용하는 헬퍼 메서드입니다.
  ///
  /// 리듀서 호출, 새로운 상태 방출, 부수 효과 실행과 같은 반복적인 코드를 처리합니다.
  ///
  /// - [emit]: BLoC 프레임워크가 제공하는 [Emitter].
  /// - [event]: 처리할 BLoC 이벤트.
  @protected
  void onAction<Event extends A>(Event event, Emitter<S> emit) async {
    final ReducerEffect<S, A> result = tcaReducer(event, state, environment);
    emit(result.newState);
    await result.effect.run();
  }
}

/// An abstract base class that applies the TCA pattern to [Cubit].
/// It provides a simple, direct entry point for handling actions.
///
/// - [A]: Action type.
/// - [S]: State type.
/// - [E]: Environment type.
///
/// ---
///
/// [Cubit]에 TCA 패턴을 적용하는 추상 기본 클래스입니다.
/// 액션 처리를 위한 간단하고 직접적인 진입점을 제공합니다.
///
/// - [A]: 액션 타입.
/// - [S]: 상태 타입.
/// - [E]: 환경 타입.
///
abstract class CubitArchTca<A, S, E> extends Cubit<S> with TcaMixin<A, S, E> {
  /// The dependencies for the [Cubit].
  ///
  /// ---
  ///
  /// [Cubit]의 의존성입니다.
  final E environment;

  /// Creates a [CubitArchTca].
  ///
  /// ---
  ///
  /// [CubitArchTca]를 생성합니다.
  CubitArchTca(super.initialState, this.environment);

  /// The main method to process an action.
  /// It calls the reducer, then handles the state change and side effect execution.
  ///
  /// - [action]: The action to process.
  ///
  /// ---
  ///
  /// 액션을 처리하는 주 메서드입니다.
  /// 리듀서를 호출한 후, 상태 변경과 부수 효과 실행을 처리합니다.
  ///
  /// - [action]: 처리할 액션.
  ///
  @protected
  Future<void> onAction(A action) async {
    final ReducerEffect<S, A> result = tcaReducer(action, state, environment);
    emit(result.newState);
    await result.effect.run();
  }
}