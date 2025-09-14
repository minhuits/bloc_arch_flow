part of 'mvi_core.dart';

// ==== 아래는 2.0.0 버전에서 제거할 예정 ======

/// An abstract BLoC that applies the MVI pattern.
///
/// It provides a structure for handling intents and managing state and effects.
/// Ideal for complex, event-driven flows.
///
/// ---
/// MVI 패턴을 적용하는 추상 BLoC입니다.
///
/// 인텐트 처리 및 상태, 부수 효과 관리를 위한 구조를 제공하며,
/// 복잡하고 이벤트 중심의 흐름에 적합합니다.
@Deprecated('${_DeprecatedMVI.blocArchMviEnglish}\n\n${_DeprecatedMVI.blocArchMviKorean}')
abstract base class BlocArchMvi<I, S, E> extends Bloc<I, S> with MviCoreMixin<S, E> {
  BlocArchMvi(super.initialState);

  /// A stream that the UI Layer can subscribe to for processing side effects.
  /// For example, it can be subscribed to via `context.read<MyBloc>().mviEffects.listen(...)`
  /// to trigger specific UI actions (e.g., showing a snackbar, displaying a dialog).
  /// ---
  /// UI Layer에서 구독하여 부수 효과를 처리할 수 있는 스트림입니다.
  /// 예를 들어, `context.read<MyBloc>().mviEffects.listen(...)`과 같이 구독하여
  /// 특정 UI 동작(예: 스낵바 표시, 다이얼로그 띄우기)을 트리거할 수 있습니다.
  @Deprecated('${_DeprecatedMVI.mviEffectsEnglish}\n\n${_DeprecatedMVI.mviEffectsKorean}')
  Stream<E> get mviEffects => effects;

  /// A function that emits a side effect to be delivered externally.
  /// Calling this method will deliver the [Effect] through the [mviEffects] stream,
  /// where it can be processed by the subscribing UI components.
  /// ---
  /// 외부로 전달될 부수 효과를 발행하는 함수입니다.
  /// 이 메서드를 호출하면 [Effect]가 [mviEffects] 스트림을 통해 전달되어,
  /// 해당 스트림을 구독하는 UI 부분에서 처리될 수 있습니다.
  @Deprecated('${_DeprecatedMVI.mviEmitEffectEnglish}\n\n${_DeprecatedMVI.mviEmitEffectKorean}')
  @protected
  void mviEmitEffect(E effect) => emitEffect(effect);

  /// An abstract function to process an [Intent] and emit new states.
  /// Within this function, business logic is performed, and side effects can be
  /// triggered using [mviEmitEffect] if necessary.
  ///
  /// [mviHandleIntent] is designed to be called from within Bloc's `on<Event>` handler.
  ///
  /// A Bloc utilizing this class should call this method as follows:
  /// `on<Intent>((intent, emit) async => await mviHandleIntent(intent, emit));`.
  /// ---
  /// [Intent]를 처리하고 새로운 상태를 발행하는 추상 함수입니다.
  /// 이 함수 내에서 비즈니스 로직을 수행하며, 필요한 경우 [mviEmitEffect]를 통해
  /// 부수 효과를 발생시킬 수 있습니다.
  ///
  /// [mviHandleIntent]는 Bloc의 `on<Event>` 핸들러 내부에서 호출되도록 설계되었습니다.
  ///
  /// 이 클래스를 사용하는 Bloc은 다음과 같이은 메서드를 호출해야 합니다:
  /// `on<Intent>((intent, emit) async => await mviHandleIntent(intent, emit));`
  @Deprecated('${_DeprecatedMVI.mviHandleIntentEnglish}\n\n${_DeprecatedMVI.mviHandleIntentKorean}')
  Future<void> mviHandleIntent(I intent, Emitter<S> stateEmitter);

  /// A utility that processes an asynchronous operation using [fpdart]'s [TaskEither]
  /// and returns a new [State] based on its result.
  ///
  /// This function follows a pure functional approach.
  /// - [task]: The asynchronous operation to execute. ([Failure] is the failure type, [Success] is the success type).
  /// - [currentState]: The current state.
  /// - [onFailure]: A callback function invoked when [task] fails.
  ///   It receives the failure value ([Failure]) and the current state, and returns a new state.
  /// - [onSuccess]: A callback function invoked when [task] succeeds.
  ///   It receives the success value ([Success]) and the current state, and returns a new state.
  /// ---
  /// [fpdart]의 [TaskEither]를 사용하여 비동기 작업을 처리하고
  /// 그 결과에 따라 새로운 [State]를 반환하는 유틸리티입니다.
  ///
  /// 이 함수는 순수 함수형 접근 방식을 따릅니다.
  /// - [task]: 실행할 비동기 작업입니다. ([Failure]은 실패 타입, [Success]은 성공 타입).
  /// - [currentState]: 현재 상태입니다.
  /// - [onFailure]: [task]가 실패했을 때 호출되는 콜백 함수입니다.
  ///   실패 값([Failure])과 현재 상태를 받아 새로운 상태를 반환합니다.
  /// - [onSuccess]: [task]가 성공했을 때 호출되는 콜백 함수입니다.
  ///   성공 값([Success])과 현재 상태를 받아 새로운 상태를 반환합니다.
  @Deprecated(
    '${_DeprecatedMVI.mviPerformTaskEitherEnglish}\n\n${_DeprecatedMVI.mviPerformTaskEitherKorean}',
  )
  Future<S> mviPerformTaskEither<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required S currentState,
    required S Function(Failure failure, S currentState) onFailure,
    required S Function(Success success, S currentState) onSuccess,
  }) async {
    final either = await task.run();
    return either.fold(
      (failure) => onFailure(failure, currentState),
      (success) => onSuccess(success, currentState),
    );
  }

  /// A utility that processes a synchronous operation using [fpdart]'s [Either]
  /// and returns a new [State] based on its result.
  ///
  /// This function follows a pure functional approach.
  /// - [either]: The synchronous operation to execute. ([Failure] is the failure type, [Success] is the success type).
  /// - [currentState]: The current state.
  /// - [onFailure]: A callback function invoked when [either] fails.
  ///   It receives the failure value ([Failure]) and the current state, and returns a new state.
  /// - [onSuccess]: A callback function invoked when [either] succeeds.
  ///   It receives the success value ([Success]) and the current state, and returns a new state.
  /// ---
  /// [fpdart]의 [Either]를 사용하여 동기 작업을 처리하고
  /// 그 결과에 따라 새로운 [State]를 반환하는 유틸리티입니다.
  ///
  /// 이 함수는 순수 함수형 접근 방식을 따릅니다.
  /// - [either]: 실행할 동기 작업입니다. ([Failure]은 실패 타입, [Success]은 성공 타입).
  /// - [currentState]: 현재 상태입니다.
  /// - [onFailure]: [either]가 실패했을 때 호출되는 콜백 함수입니다.
  ///   실패 값([Failure])과 현재 상태를 받아 새로운 상태를 반환합니다.
  /// - [onSuccess]: [either]가 성공했을 때 호출되는 콜백 함수입니다.
  ///   성공 값([Success])과 현재 상태를 받아 새로운 상태를 반환합니다.
  @Deprecated(
    '${_DeprecatedMVI.mviPerformEitherEnglish}\n\n${_DeprecatedMVI.mviPerformEitherKorean}',
  )
  S mviPerformEither<Failure, Success>(
    Either<Failure, Success> either, {
    required S currentState,
    required S Function(Failure failure, S currentState) onFailure,
    required S Function(Success success, S currentState) onSuccess,
  }) {
    return either.fold(
      (failure) => onFailure(failure, currentState),
      (success) => onSuccess(success, currentState),
    );
  }
}

sealed class _DeprecatedMVI {
  _DeprecatedMVI._();

  static const String blocArchMviEnglish =
      '`BlocArchMvi` will be removed in version `2.0.0`. \nUse `MviCubit` or `MviCoreMixin` instead.';
  static const String blocArchMviKorean =
      '`BlocArchMvi`는 `2.0.0` 버전에서 제거됩니다. 대신 `MviCubit` 또는 `MviCoreMixin`를 사용하세요.';

  static const String mviEffectsEnglish =
      '`mviEffects` will be removed in version `2.0.0`. \nUse `MviCubit.effects` or `MviCoreMixin.effects` instead.';
  static const String mviEffectsKorean =
      '`mviEffects`는 `2.0.0` 버전에서 제거됩니다. 대신 `MviCubit.effects` 또는 `MviCoreMixin.effects`를 사용하세요.';

  static const String mviEmitEffectEnglish =
      '`mviEmitEffect` will be removed in version `2.0.0`. \nUse `MviCubit.emitEffect` or `MviCoreMixin.emitEffect` instead.';

  static const String mviEmitEffectKorean =
      '`mviEmitEffect`는 `2.0.0` 버전에서 제거됩니다. 대신 `MviCubit.emitEffect` 또는 `MviCoreMixin.emitEffect`를 사용하세요.';
  static const String mviHandleIntentEnglish =
      '`mviHandleIntent` will be removed in version `2.0.0`.Use `MviCubit.onIntent` instead.';

  static const String mviHandleIntentKorean =
      '`mviHandleIntent`는 `2.0.0` 버전에서 제거됩니다. 대신 `MviCubit.onIntent`를 사용하세요.';

  static const String mviPerformTaskEitherEnglish =
      '`mviPerformTaskEither` will be removed in version `2.0.0`. \nUse `MviCubit.handleIntentPerformAsync` instead.';

  static const String mviPerformTaskEitherKorean =
      '`mviPerformTaskEither`는 `2.0.0` 버전에서 제거됩니다. 대신 `MviCubit.handleIntentPerformAsync`를 사용하세요.';
  static const String mviPerformEitherEnglish =
      '`mviPerformEither` will be removed in version `2.0.0`. \nUse `MviCubit.handleIntentPerform` instead.';

  static const String mviPerformEitherKorean =
      '`mviPerformEither`는 `2.0.0` 버전에서 제거됩니다. 대신 `MviCubit.handleIntentPerform`를 사용하세요.';
}