import 'dart:async';

import 'package:bloc/bloc.dart' show Bloc, Cubit, BlocBase, Emitter;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:fpdart/fpdart.dart' show Either, TaskEither;
import 'package:meta/meta.dart' show protected;

mixin MviMixin<State, Effect> on BlocBase<State> {
  /// Internal [StreamController] for emitting side effects that will be delivered externally.
  ///
  /// 외부로 전달될 부수 효과를 발행하기 위한 내부 [StreamController]입니다.
  final StreamController<Effect> _controller = StreamController<Effect>.broadcast();

  /// A stream that the UI Layer can subscribe to for processing side effects.
  /// For example, it can be subscribed to via `context.read<MyCubit>().effects.listen(...)`
  /// to trigger specific UI actions (e.g., showing a snackbar, displaying a dialog).
  /// ---
  /// UI Layer에서 구독하여 부수 효과를 처리할 수 있는 스트림입니다.
  /// 예를 들어, `context.read<MyCubit>().effects.listen(...)`과 같이 구독하여
  /// 특정 UI 동작(예: 스낵바 표시, 다이얼로그 띄우기)을 트리거할 수 있습니다.
  Stream<Effect> get effects => _controller.stream;

  /// A function that emits a side effect to be delivered externally.
  /// Calling this method will deliver the [Effect] through the [effects] stream,
  /// where it can be processed by the subscribing UI components.
  /// ---
  /// 외부로 전달될 부수 효과를 발행하는 함수입니다.
  /// 이 메서드를 호출하면 [Effect]가 [effects] 스트림을 통해 전달되어,
  /// 해당 스트림을 구독하는 UI 부분에서 처리될 수 있습니다.
  @protected
  void emitEffect(Effect effect) {
    if (!_controller.isClosed) {
      _controller.add(effect);
    } else {
      debugPrint('Warning: Effect emitted after Cubit was closed: $effect');
    }
  }

  /// A utility that processes a synchronous operation using `fpdart`'s [Either]
  /// and returns a new [State] based on its result.
  ///
  /// This function follows a pure functional approach. It calculates and returns
  /// the next state without emitting it. This separation of concerns allows the
  /// state calculation logic to be reused and easily tested independently.
  ///
  /// - [either]: The synchronous operation to execute. [Failure] is the failure type, [Success] is the success type.
  /// - [onFailure]: A callback function invoked when [either] contains a failure value. It receives the [failure] and the current state, and must return a new state.
  /// - [onSuccess]: A callback function invoked when [either] contains a success value. It receives the [success] and the current state, and must return a new state.
  ///
  /// Returns the new state based on the outcome of the [Either].
  /// ---
  /// `fpdart`의 [Either]를 사용하여 동기 작업을 처리하고
  /// 그 결과에 따라 새로운 [State]를 반환하는 유틸리티입니다.
  ///
  /// 이 함수는 순수 함수형 접근 방식을 따릅니다. 상태를 발행하지 않고
  /// 오직 다음 상태를 계산하여 반환합니다. 이러한 관심사 분리를 통해
  /// 상태 계산 로직의 재사용성과 독립적인 테스트가 용이해집니다.
  ///
  /// - [either]: 실행할 동기 작업입니다. [Failure]는 실패 타입, [Success]는 성공 타입입니다.
  /// - [onFailure]: [either]가 실패 값을 담고 있을 때 호출되는 콜백 함수입니다. [failure] 값과 현재 상태를 받아 새로운 상태를 반환해야 합니다.
  /// - [onSuccess]: [either]가 성공 값을 담고 있을 때 호출되는 콜백 함수입니다. [success] 값과 현재 상태를 받아 새로운 상태를 반환해야 합니다.
  ///
  /// [Either]의 결과에 따라 계산된 새로운 상태를 반환합니다.
  @protected
  State _toState<Failure, Success>({
    required Either<Failure, Success> either,
    required State Function(Failure failure, State currentState) onFailure,
    required State Function(Success success, State currentState) onSuccess,
  }) {
    return either.fold(
      (failure) => onFailure(failure, state),
      (success) => onSuccess(success, state),
    );
  }

  /// A utility that processes an asynchronous operation using [fpdart]'s [TaskEither]
  /// and returns a new [State] based on its result.
  ///
  /// Similar to [_toState], this function is a pure functional utility that
  /// calculates and returns the next state without emitting it. It first awaits
  /// the [TaskEither] to get an [Either] and then uses [_toState] to calculate the final state.
  ///
  /// - [task]: The asynchronous operation to execute. [Failure] is the failure type, [Success] is the success type.
  /// - [onFailure]: A callback function invoked when the [task] fails. It receives the [failure] and the current state, and must return a new state.
  /// - [onSuccess]: A callback function invoked when the [task] succeeds. It receives the [success] and the current state, and must return a new state.
  ///
  /// Returns a [Future] that completes with the new state.
  /// ---
  /// [fpdart]의 [TaskEither]를 사용하여 비동기 작업을 처리하고
  /// 그 결과에 따라 새로운 [State]를 반환하는 유틸리티입니다.
  ///
  /// [_toState]와 유사하게, 이 함수는 순수 함수형 유틸리티로 상태를 발행하지 않고
  /// 오직 다음 상태를 계산하여 반환합니다. 먼저 [TaskEither]의 비동기 작업 결과를
  /// 기다린 후, [_toState]를 사용하여 최종 상태를 계산합니다.
  ///
  /// - [task]: 실행할 비동기 작업입니다. [Failure]는 실패 타입, [Success]는 성공 타입입니다.
  /// - [onFailure]: [task]가 실패했을 때 호출되는 콜백 함수입니다. [failure] 값과 현재 상태를 받아 새로운 상태를 반환해야 합니다.
  /// - [onSuccess]: [task]가 성공했을 때 호출되는 콜백 함수입니다. [success] 값과 현재 상태를 받아 새로운 상태를 반환해야 합니다.
  ///
  /// 새로운 상태를 담고 있는 [Future]를 반환합니다.
  @protected
  Future<State> _toStateAsync<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required State Function(Failure failure, State currentState) onFailure,
    required State Function(Success success, State currentState) onSuccess,
  }) async {
    final Either<Failure, Success> either = await task.run();
    return _toState(either: either, onFailure: onFailure, onSuccess: onSuccess);
  }

  /// Closes the internal [StreamController] to prevent memory leaks.
  /// This method should be called when the Bloc is no longer needed.
  /// ---
  /// 메모리 누수를 방지하기 위해 내부 [StreamController]를 닫습니다.
  /// 이 메서드는 Bloc이 더 이상 필요하지 않을 때 호출되어야 합니다.
  @override
  Future<void> close() {
    _controller.close();
    return super.close();
  }
}

abstract class BlocArchMvi<Intent, State, Effect> extends Bloc<Intent, State>
    with MviMixin<State, Effect> {
  BlocArchMvi(super.initialState);

  /// An abstract function to process an [Intent] and emit new states.
  /// Within this function, business logic is performed, and side effects can be
  /// triggered using [emitEffect] if necessary.
  ///
  /// [handleIntent] is designed to be called from within Bloc's `on<Event>` handler.
  ///
  /// A Bloc utilizing this class should call this method as follows:
  /// `on<Intent>((intent, emit) async => await mviHandleIntent(intent, emit));`.
  /// ---
  /// [Intent]를 처리하고 새로운 상태를 발행하는 추상 함수입니다.
  /// 이 함수 내에서 비즈니스 로직을 수행하며, 필요한 경우 [emitEffect]를 통해
  /// 부수 효과를 발생시킬 수 있습니다.
  ///
  /// [handleIntent]는 Bloc의 `on<Event>` 핸들러 내부에서 호출되도록 설계되었습니다.
  ///
  /// 이 클래스를 사용하는 Bloc은 다음과 같이은 메서드를 호출해야 합니다:
  /// `on<Intent>((intent, emit) async => await mviHandleIntent(intent, emit));`
  Future<void> handleIntent(Intent intent, Emitter<State> blocEmit);

  /// Executes a synchronous operation using `fpdart`'s [Either] and emits a new state.
  ///
  /// This utility method encapsulates the process of handling a synchronous task. It
  /// calculates the next state based on whether the [either] contains a success or
  /// a failure value, and then uses the provided [Emitter] to emit that state.
  ///
  /// - [either]: The synchronous operation's result.
  /// - [blocEmit]: The [Emitter] provided by the BLoC's [on] handler to emit new states.
  /// - [onFailure]: A callback to compute the next state when the operation fails.
  /// - [onSuccess]: A callback to compute the next state when the operation succeeds.
  /// ---
  /// `fpdart`의 [Either]를 사용하여 동기 작업을 실행하고 새로운 상태를 발행합니다.
  ///
  /// 이 유틸리티 메서드는 동기 작업 처리 과정을 캡슐화합니다. [either]가 성공 또는
  /// 실패 값을 포함하는지에 따라 다음 상태를 계산한 후, 제공된 [Emitter]를 사용하여
  /// 해당 상태를 발행합니다.
  ///
  /// - [either]: 동기 작업의 결과.
  /// - [blocEmit]: BLoC의 [on] 핸들러에서 제공되는, 새로운 상태를 발행하는 [Emitter].
  /// - [onFailure]: 작업 실패 시 다음 상태를 계산하는 콜백.
  /// - [onSuccess]: 작업 성공 시 다음 상태를 계산하는 콜백.
  @protected
  void performEither<Failure, Success>({
    required Either<Failure, Success> either,
    required Emitter<State> blocEmit,
    required State Function(Failure failure, State blocState) onFailure,
    required State Function(Success success, State blocState) onSuccess,
  }) {
    final State newState = _toState(either: either, onFailure: onFailure, onSuccess: onSuccess);
    blocEmit(newState);
  }

  /// Executes an asynchronous operation using `fpdart`'s [TaskEither] and emits a new state.
  ///
  /// This method handles asynchronous tasks by first running the `task` to get its
  /// result, and then calculating and emitting the new state. This process ensures that
  /// the state is only updated after the asynchronous operation has completed.
  ///
  /// - [task]: The asynchronous operation to execute.
  /// - [blocEmit]: The [Emitter] provided by the BLoC's [on] handler to emit new states.
  /// - [onFailure]: A callback to compute the next state when the operation fails.
  /// - [onSuccess]: A callback to compute the next state when the operation succeeds.
  /// ---
  /// `fpdart`의 [TaskEither]를 사용하여 비동기 작업을 실행하고 새로운 상태를 발행합니다.
  ///
  /// 이 메서드는 비동기 작업을 먼저 실행하여 결과를 얻은 후, 다음 상태를 계산하고
  /// 발행합니다. 이 과정을 통해 비동기 작업이 완료된 후에만 상태가 업데이트되는 것을 보장합니다.
  ///
  /// - [task]: 실행할 비동기 작업.
  /// - [blocEmit]: BLoC의 [on] 핸들러에서 제공되는, 새로운 상태를 발행하는 [Emitter].
  /// - [onFailure]: 작업 실패 시 다음 상태를 계산하는 콜백.
  /// - [onSuccess]: 작업 성공 시 다음 상태를 계산하는 콜백.
  @protected
  Future<void> performTaskEither<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required Emitter<State> blocEmit,
    required State Function(Failure failure, State blocState) onFailure,
    required State Function(Success success, State blocState) onSuccess,
  }) async {
    final State newState = await _toStateAsync(
      onFailure: onFailure,
      onSuccess: onSuccess,
      task: task,
    );
    blocEmit(newState);
  }
}

abstract class CubitMvi<State, Effect> extends Cubit<State> with MviMixin<State, Effect> {
  CubitMvi(super.initialState);

  /// Executes an asynchronous operation using `fpdart`'s [TaskEither] and emits a new state.
  ///
  /// This method encapsulates the process of handling asynchronous tasks within a Cubit.
  /// It first runs the provided [task] to get the result, then uses the [onFailure] or [onSuccess]
  /// callback to compute the new state, and finally emits the calculated state. This ensures
  /// that the state is updated only after the asynchronous operation has successfully
  /// completed or failed.
  ///
  /// - [task]: The asynchronous operation to execute. It must be a [TaskEither] from the `fpdart`  package.
  /// - [onFailure]: A callback function that receives the failure value and the current Cubit state, returning a new state.
  /// - [onSuccess]: A callback function that receives the success value and the current Cubit state, returning a new state.
  /// ---
  /// `fpdart`의 [TaskEither]를 사용하여 비동기 작업을 실행하고 새로운 상태를 발행합니다.
  ///
  /// 이 메서드는 Cubit 내에서 비동기 작업을 처리하는 과정을 캡슐화합니다. 제공된 [task]를 실행하여
  /// 결과를 얻은 후, [onFailure] 또는 [onSuccess] 콜백을 사용하여 다음 상태를 계산하고,
  /// 최종적으로 계산된 상태를 발행합니다. 이를 통해 비동기 작업이 성공하거나 실패한 후에만
  /// 상태가 안전하게 업데이트되는 것을 보장합니다.
  ///
  /// - [task]: 실행할 비동기 작업. `fpdart` 패키지의 [TaskEither] 타입이어야 합니다.
  /// - [onFailure]: 실패 값과 현재 Cubit 상태를 받아 새로운 상태를 반환하는 콜백 함수.
  /// - [onSuccess]: 성공 값과 현재 Cubit 상태를 받아 새로운 상태를 반환하는 콜백 함수.
  @protected
  Future<void> performTaskEither<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required State Function(Failure failure, State cubitState) onFailure,
    required State Function(Success success, State cubitState) onSuccess,
  }) async {
    final State newState = await _toStateAsync(
      task: task,
      onFailure: onFailure,
      onSuccess: onSuccess,
    );
    emit(newState);
  }

  /// Executes a synchronous operation using [fpdart]'s [Either] and emits a new state.
  ///
  /// This utility method encapsulates the process of handling a synchronous task. It
  /// calculates the next state based on whether the [either] contains a success or
  /// a failure value, and then emits the calculated state.
  ///
  /// - [either]: The synchronous operation's result. It must be an [Either] from the `fpdart` package.
  /// - [onFailure]: A callback function that receives the failure value and the current Cubit state, returning a new state.
  /// - [onSuccess]: A callback function that receives the success value and the current Cubit state, returning a new state.
  /// ---
  /// [fpdart]의 [Either]를 사용하여 동기 작업을 실행하고 새로운 상태를 발행합니다.
  ///
  /// 이 유틸리티 메서드는 동기 작업 처리 과정을 캡슐화합니다. [either]가 성공 또는
  /// 실패 값을 포함하는지에 따라 다음 상태를 계산한 후, 계산된 상태를 발행합니다.
  ///
  /// - [either]: 동기 작업의 결과. `fpdart` 패키지의 [Either] 타입이어야 합니다.
  /// - [onFailure]: 실패 값과 현재 Cubit 상태를 받아 새로운 상태를 반환하는 콜백 함수.
  /// - [onSuccess]: 성공 값과 현재 Cubit 상태를 받아 새로운 상태를 반환하는 콜백 함수.
  @protected
  void performEither<Failure, Success>({
    required Either<Failure, Success> either,
    required State Function(Failure failure, State cubitState) onFailure,
    required State Function(Success success, State cubitState) onSuccess,
  }) {
    final State newState = _toState(either: either, onFailure: onFailure, onSuccess: onSuccess);
    emit(newState);
  }
}