import 'package:bloc/bloc.dart' show Bloc, Cubit, Emitter;
import 'package:fpdart/fpdart.dart' show TaskEither, Either;
import 'package:meta/meta.dart' show protected;

part 'tca_deprecated.dart';
part 'tca_types.dart';

/// A mixin that provides core TCA-like functionality to both [Bloc] and [Cubit].
///
/// It encapsulates the pure reducer logic and the mechanism for building side effects,
/// abstracting them away from the state management framework's boilerplate.
///
/// **Type Parameters:**
/// - [Action]: The action type, which represents all possible user or system events.
/// - [State]: The state type, representing the UI state.
/// - [Environment]: The environment type, holding all dependencies (e.g., API clients, databases).
///
/// ---
/// [Bloc]와 [Cubit]에 TCA의 핵심 기능을 제공하는 믹스인입니다.
///
/// 순수 리듀서 로직과 부수 효과를 생성하는 메커니즘을 캡슐화하여,
/// 상태 관리 프레임워크의 반복적인 코드로부터 분리합니다.
///
/// **타입 매개변수:**
/// - [Action]: 모든 가능한 사용자 또는 시스템 이벤트를 나타내는 액션 타입.
/// - [State]: UI 상태를 나타내는 상태 타입.
/// - [Environment]: 모든 의존성(예: API 클라이언트, 데이터베이스)을 담는 환경 타입.
abstract mixin class TcaCoreMixin<Action, State, Environment> {
  /// A pure utility to build a side effect with `fpdart`'s [TaskEither].
  ///
  /// This function takes a potentially failing asynchronous [task] and transforms its
  /// outcome (success or failure) into a unified [TcaEffect] that returns an action.
  ///
  /// **Type Parameters:**
  /// - [Failure]: The type of a non-recoverable error.
  /// - [Success]: The type of value returned on a successful task.
  ///
  /// **Parameters:**
  /// - [task]: The raw asynchronous operation.
  /// - [onSuccess]: A callback that transforms the successful result into a new action.
  /// - [onFailure]: A callback that transforms the failure result into a new action.
  ///
  /// **Returns:**
  /// A [TcaEffect] that will yield an action upon execution.
  ///
  /// ---
  /// `fpdart`의 [TaskEither]로 부수 효과를 만드는 순수 유틸리티입니다.
  ///
  /// 이 함수는 잠재적으로 실패할 수 있는 비동기 [task]를 받아, 그 결과(성공 또는 실패)를
  /// 액션을 반환하는 통합된 [TcaEffect]로 변환합니다.
  ///
  /// **타입 매개변수:**
  /// - [Failure]: 복구 불가능한 오류의 타입.
  /// - [Success]: 성공적인 작업 완료 시 반환되는 값의 타입.
  ///
  /// **매개변수:**
  /// - [task]: 비동기 작업.
  /// - [onSuccess]: 성공 결과를 새로운 액션으로 변환하는 콜백.
  /// - [onFailure]: 실패 결과를 새로운 액션으로 변환하는 콜백.
  ///
  /// **반환:**
  /// 실행 시 액션을 생성하는 [TcaEffect].
  @protected
  TcaEffect<Action> effectBuilder<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required Action Function(Success success) onSuccess,
    required Action Function(Failure failure) onFailure,
  }) {
    return task.map(onSuccess).mapLeft(onFailure);
  }

  /// 병렬 효과를 처리하는 유틸리티 함수입니다.
  ///
  /// 여러 [TcaEffect]를 받아 이들을 병렬로 실행하고
  /// 모든 효과가 성공적으로 완료되었을 때만 새로운 액션을 반환하는
  /// [TcaEffect]를 생성합니다.
  ///
  /// **매개변수:**
  /// - [effects]: 병렬로 실행할 [TcaEffect] 리스트.
  /// - [onSuccess]: 모든 효과가 성공적으로 완료되었을 때 호출되는 콜백.
  ///   이 콜백은 성공 값들의 리스트를 받고 새로운 액션을 반환해야 합니다.
  /// - [onFailure]: 하나라도 실패한 효과가 있을 때 호출되는 콜백.
  ///   이 콜백은 실패 값을 받고 새로운 액션을 반환해야 합니다.
  ///
  /// **반환:**
  /// 실행 시 병렬로 작업을 수행하는 새로운 [TcaEffect].
  @protected
  TcaEffect<Action> parallelEffectBuilder({
    required List<TcaEffect<Action>> effects,
    required Action Function(List<Action> successList) onSuccess,
    required Action Function(Action failure) onFailure,
  }) {
    // 1. TaskEither 리스트를 하나의 TaskEither로 합칩니다.
    // 모든 TaskEither가 Right(성공)일 때만 결과가 Right로 반환됩니다.
    final TaskEither<Action, List<Action>> sequencedTask = TaskEither.sequenceList(effects);

    // 2. 성공/실패 케이스에 따라 액션을 매핑합니다.
    return sequencedTask.map(onSuccess).mapLeft(onFailure);
  }

  /// A pure function that processes an action and returns a new state and effect.
  ///
  /// This is the core reducer logic, completely separate from the state management framework.
  ///
  /// **Parameters:**
  /// - [action]: The action to process.
  /// - [state]: The current state of the BLoC.
  /// - [environment]: The dependencies needed for the business logic.
  ///
  /// **Returns:**
  /// A [TcaReducer] containing the next state and a side effect.
  ///
  /// ---
  /// 액션을 처리하고 새로운 상태와 효과를 반환하는 순수 함수입니다.
  ///
  /// 상태 관리 프레임워크와 완벽하게 분리된 핵심 리듀서 로직입니다.
  ///
  /// **매개변수:**
  /// - [action]: 처리할 액션.
  /// - [state]: BLoC의 현재 상태.
  /// - [environment]: 비즈니스 로직에 필요한 의존성.
  ///
  /// **반환:**
  /// 다음 상태와 부수 효과를 담은 [TcaReducer].
  @protected
  TcaReducer<Action, State> reduce(Action action, State state, Environment environment);

  /// A pure utility that transforms a single action into a side effect.
  ///
  /// This function is a convenient helper for creating a [TcaEffect]
  /// that simply returns a single, new action. It is useful for cases
  /// where a reducer's logic immediately dictates a follow-up action
  /// without any asynchronous or potentially failing operations.
  ///
  /// **Parameters:**
  /// - [action]: The action to be returned as the successful outcome of the effect.
  ///
  /// **Returns:**
  /// A [TcaEffect] that will immediately yield the given action.
  ///
  /// ---
  /// 단일 액션을 부수 효과로 변환하는 순수 유틸리티입니다.
  ///
  /// 이 함수는 하나의 새로운 액션을 반환하는 [TcaEffect]를 간편하게 생성하기 위한 헬퍼입니다.
  /// 비동기 작업이나 실패할 가능성이 있는 작업 없이, 리듀서의 로직이 즉시
  /// 후속 액션을 요구하는 경우에 유용합니다.
  ///
  /// **매개변수:**
  /// - [action]: 효과의 성공적인 결과로 반환될 액션.
  ///
  /// **반환:**
  /// 즉시 주어진 액션을 생성하는 [TcaEffect].
  @protected
  TcaEffect<Action> sideEffect(Action action) => TcaEffect.right(action);
}

/// An abstract base class that applies the TCA pattern to [Bloc].
///
/// It provides a consistent entry point for handling actions and delegates to a pure reducer.
///
/// **Type Parameters:**
/// - [A]: The action type, which represents all possible user or system events.
/// - [S]: The state type, representing the UI state.
/// - [E]: The environment type, holding all dependencies (e.g., API clients, databases).
///
/// ---
/// [Bloc]에 TCA 패턴을 적용하는 추상 기본 클래스입니다.
///
/// 액션 처리를 위한 일관된 진입점을 제공하며, 순수 리듀서에 로직을 위임합니다.
///
/// **타입 매개변수:**
/// - [A]: 모든 가능한 사용자 또는 시스템 이벤트를 나타내는 액션 타입.
/// - [S]: UI 상태를 나타내는 상태 타입.
/// - [E]: 모든 의존성(예: API 클라이언트, 데이터베이스)을 담는 환경 타입.
abstract base class TcaBloc<A, S, E> extends Bloc<A, S> with TcaCoreMixin<A, S, E> {
  /// The dependencies for the BLoC.
  ///
  /// ---
  /// BLoC의 의존성입니다.
  final E environment;

  /// Creates a [TcaBloc].
  ///
  /// ---
  /// [TcaBloc]를 생성합니다.
  TcaBloc({required S initialState, required this.environment}) : super(initialState) {
    on<A>(handleAction);
  }

  /// A core method for processing an action and managing its side effects.
  ///
  /// This method is automatically triggered when a new action is added to the BLoC.
  /// It first calls the pure [reduce] function to get the next state and a side effect,
  /// then emits the new state. Finally, it executes the side effect and dispatches
  /// the resulting follow-up action, completing a predictable **action loop**.
  ///
  /// **Parameters:**
  /// - [emit]: The function to emit a new state.
  /// - [action]: The action to be processed.
  ///
  /// ---
  /// 액션을 처리하고 부수 효과를 관리하는 핵심 메서드입니다.
  ///
  /// 이 메서드는 BLoC에 새로운 액션이 추가될 때 자동으로 트리거됩니다.
  /// 먼저 순수한 [reduce] 함수를 호출하여 다음 상태와 부수 효과를 얻고,
  /// 그 후 새로운 상태를 발행합니다. 마지막으로, 부수 효과를 실행하고
  /// 그 결과로 생성된 후속 액션을 디스패치하여 예측 가능한 **액션 루프**를 완성합니다.
  ///
  /// **매개변수:**
  /// - [emit]: 새로운 상태를 발행하는 함수.
  /// - [action]: 처리할 액션.
  void handleAction(A action, Emitter<S> emit) async {
    // 1. 순수 리듀서 호출: 새로운 상태와 부수 효과를 반환합니다.
    final TcaReducer<A, S> result = reduce(action, state, environment);

    // 2. 새로운 상태 발행: BLoC의 emit을 사용하여 상태를 업데이트합니다.
    emit(result.newState);

    // 3. 부수 효과 실행 및 결과 액션 계산
    final Either<A, A> either = await result.effect.run();

    // `run()`의 결과인 `Either`에서 성공/실패와 관계없이 액션을 추출합니다.
    final A nextAction = either.getOrElse((failure) => failure);

    // 4. 다음 액션에 대한 상태 변화를 즉시 적용
    final TcaReducer<A, S> nextResult = reduce(nextAction, state, environment);

    if (state != nextResult.newState) {
      emit(nextResult.newState);
    }
  }
}