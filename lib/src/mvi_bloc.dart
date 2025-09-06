import 'dart:async';

import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:fpdart/fpdart.dart' show Either, TaskEither;
import 'package:meta/meta.dart' show protected;

/// Intent와 Model이라는 용어를 통해 MVI 패턴의 맥락을 제공합니다.
abstract class BlocArchMvi<Intent, StateType, Effect> extends Bloc<Intent, StateType> {
  /// Internal [StreamController] for emitting side effects that will be delivered externally.
  ///
  /// 외부로 전달될 부수 효과를 발행하기 위한 내부 [StreamController]입니다.
  final StreamController<Effect> _controller = StreamController<Effect>.broadcast();

  BlocArchMvi(super.initialState);

  /// A stream that the UI Layer can subscribe to for processing side effects.
  /// For example, it can be subscribed to via `context.read<MyBloc>().mviEffects.listen(...)`
  /// to trigger specific UI actions (e.g., showing a snackbar, displaying a dialog).
  /// ---
  /// UI Layer에서 구독하여 부수 효과를 처리할 수 있는 스트림입니다.
  /// 예를 들어, `context.read<MyBloc>().mviEffects.listen(...)`과 같이 구독하여
  /// 특정 UI 동작(예: 스낵바 표시, 다이얼로그 띄우기)을 트리거할 수 있습니다.
  Stream<Effect> get mviEffects => _controller.stream;

  /// A function that emits a side effect to be delivered externally.
  /// Calling this method will deliver the [Effect] through the [mviEffects] stream,
  /// where it can be processed by the subscribing UI components.
  /// ---
  /// 외부로 전달될 부수 효과를 발행하는 함수입니다.
  /// 이 메서드를 호출하면 [Effect]가 [mviEffects] 스트림을 통해 전달되어,
  /// 해당 스트림을 구독하는 UI 부분에서 처리될 수 있습니다.
  @protected
  void mviEmitEffect(Effect effect) {
    if (!_controller.isClosed) {
      _controller.add(effect);
    } else {
      debugPrint('Warning: Effect emitted after Bloc was closed: $effect');
    }
  }

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
  Future<void> mviHandleIntent(Intent intent, Emitter<StateType> stateEmitter);

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
  @protected
  Future<StateType> mviPerformTaskEither<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required StateType currentState,
    required StateType Function(Failure failure, StateType currentState) onFailure,
    required StateType Function(Success success, StateType currentState) onSuccess,
  }) async {
    final result = await task.run();
    return result.fold(
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
  @protected
  StateType mviPerformEither<Failure, Success>(
    Either<Failure, Success> either, {
    required StateType currentState,
    required StateType Function(Failure failure, StateType currentState) onFailure,
    required StateType Function(Success success, StateType currentState) onSuccess,
  }) {
    return either.fold(
      (failure) => onFailure(failure, currentState),
      (success) => onSuccess(success, currentState),
    );
  }

  /// Closes the internal [StreamController] to prevent memory leaks.
  /// This method should be called when the Bloc is no longer needed.
  /// ---
  /// 메모리 누수를 방지하기 위해 내부 [StreamController]를 닫습니다.
  /// Bloc이 더 이상 필요하지 않을 때 호출되어야 합니다.
  @override
  Future<void> close() {
    _controller.close();
    return super.close();
  }
}