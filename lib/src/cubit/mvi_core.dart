import 'dart:async' show StreamController;

import 'package:bloc/bloc.dart' show BlocBase, Bloc, Cubit, Emitter;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:fpdart/fpdart.dart' show Either, TaskEither, Option, Some;
import 'package:meta/meta.dart' show protected;

part 'mvi_deprecated.dart';
part 'mvi_types.dart';

/// A mixin that provides core MVI (Model-View-Intent) pattern functionalities.
///
/// It separates state changes from side effects and is reusable across both
/// BLoC and Cubit.
///
/// **Type Parameters:**
/// - [State]: The type of the state.
/// - [Effect]: The type of the side effects.
///
/// ---
/// MVI(Model-View-Intent) 패턴의 핵심 기능을 제공하는 믹스인입니다.
///
/// 상태 변화와 부수 효과를 분리하며, Cubit에서 재사용할 수 있습니다.
///
/// **타입 매개변수:**
/// - [State]: 상태의 타입.
/// - [Effect]: 부수 효과의 타입.
mixin MviCoreMixin<State, Effect> on BlocBase<State> {
  /// Internal [StreamController] for delivering side effects to the UI.
  ///
  /// ---
  /// UI로 부수 효과를 전달하기 위한 내부 [StreamController]입니다.
  final StreamController<Effect> _controller = StreamController<Effect>.broadcast();

  /// A stream for the UI layer to subscribe to for processing side effects.
  ///
  /// Use this to trigger actions like showing a snackbar or a dialog.
  ///
  /// ---
  /// UI 레이어가 부수 효과를 처리하기 위해 구독하는 스트림입니다.
  ///
  /// 스낵바 또는 다이얼로그 표시와 같은 동작을 트리거하는 데 사용하세요.
  Stream<Effect> get effects => _controller.stream;

  /// Emits a side effect to be delivered externally to the UI.
  ///
  /// ---
  /// 외부 UI로 전달될 부수 효과를 발행합니다.
  @protected
  void emitEffect(Effect effect) {
    if (!_controller.isClosed) {
      _controller.add(effect);
    } else {
      debugPrint('Warning: Effect emitted after Cubit was closed: $effect');
    }
  }

  /// Returns an [Option] containing a new state to be emitted.
  ///
  /// This is a convenience method that wraps the provided state [s] in an
  /// [Option.Some] type. It is intended to be used within a [LogicState]
  /// callback to clearly indicate that a state change should occur.
  ///
  /// **Parameters:**
  /// - [s]: The new state to be wrapped.
  ///
  /// **Returns:**
  /// An [Option.Some] containing the new state, or [Option.None] if no
  /// state change is needed.
  ///
  /// ### **Example**
  ///
  /// ```dart
  /// final logicState = LogicState<MyState, MySuccess, MyFailure>(
  ///   onSuccess: (success, currentState) {
  ///     // Explicitly indicates a state change
  ///     return emitNewState(currentState.copyWith(data: success));
  ///   },
  ///   onFailure: (failure, currentState) {
  ///     // Explicitly indicates a state change with an error
  ///     return emitNewState(currentState.copyWith(error: failure));
  ///   },
  /// );
  /// ```
  ///
  /// ---
  /// 발행될 새로운 상태를 담은 [Option]을 반환합니다.
  ///
  /// 이 메서드는 제공된 상태 [s]를 [Option.Some] 타입으로 감싸는 편의 함수입니다.
  /// [LogicState] 콜백 내에서 사용되어 상태 변경이 발생해야 함을 명확하게
  /// 나타내기 위해 만들어졌습니다.
  ///
  /// **매개변수:**
  /// - [s]: 감쌀 새로운 상태.
  ///
  /// **반환:**
  /// 새로운 상태를 담은 [Option.Some]을 반환합니다. 상태 변경이 필요하지 않은 경우
  /// [Option.None]을 반환할 수 있습니다.
  ///
  /// ### **예제**
  ///
  /// ```dart
  /// final logicState = LogicState<MyState, MySuccess, MyFailure>(
  ///   onSuccess: (success, currentState) {
  ///     // 상태 변경이 일어날 것을 명시적으로 나타냄
  ///     return emitNewState(currentState.copyWith(data: success));
  ///   },
  ///   onFailure: (failure, currentState) {
  ///     // 오류를 포함한 상태 변경이 일어날 것을 명시적으로 나타냄
  ///     return emitNewState(currentState.copyWith(error: failure));
  ///   },
  /// );
  /// ```
  @protected
  Option<State> emitNewState(State newState) => Some(newState);

  /// Closes the internal stream controller to prevent memory leaks.
  ///
  /// ---
  /// 메모리 누수를 방지하기 위해 내부 스트림 컨트롤러를 닫습니다.
  @override
  Future<void> close() {
    _controller.close();
    return super.close();
  }
}

/// An abstract Cubit that applies the MVI pattern.
///
/// ---
/// MVI 패턴을 적용하는 추상 Cubit입니다.
abstract class MviCubit<I, S, E> extends Cubit<S> with MviCoreMixin<S, E> {
  MviCubit(super.initialState);

  /// Handles an incoming intent and manages state and effects.
  ///
  /// This is the core method for implementing MVI business logic. It takes an [intent]
  /// and dispatches it to the appropriate handler to perform state changes or emit side effects.
  ///
  /// ---
  /// 들어오는 인텐트를 처리하고 상태 및 부수 효과를 관리합니다.
  ///
  /// 이 메서드는 MVI 비즈니스 로직을 구현하기 위한 핵심입니다. [intent]를 받아
  /// 인텐트를 적절한 핸들러에 전달하여 상태를 변경하거나 부수 효과를 발행합니다.
  Future<void> onIntent(I intent);

  /// Executes a synchronous operation and emits the resulting state.
  ///
  /// This method uses the provided [logicState] to convert the [either]
  /// from a synchronous operation into a new state. If the new state is not null,
  /// it's emitted to update the UI.
  ///
  /// **Parameters:**
  /// - [either]: The result of a synchronous operation, wrapped in a [Either].
  /// - [logicState]: A [LogicState] that defines how to map the operation's result to the next state.
  ///
  /// ---
  /// 동기 작업을 실행하고 결과 상태를 발행합니다.
  ///
  /// 이 메서드는 제공된 [logicState]를 사용하여 동기 작업의 결과인 [Either]을
  /// 새로운 상태로 변환합니다. 새로운 상태가 `null`이 아닌 경우, UI를 업데이트하기 위해
  /// 해당 상태를 발행합니다.
  ///
  /// **매개변수:**
  /// - [either]: [Either]으로 감싸진 동기 작업의 결과입니다.
  /// - [logicState]: 연산 결과를 다음 상태로 매핑하는 방법을 정의하는 [LogicState]입니다.
  @protected
  void handleIntentPerform<Failure, Success>({
    required Either<Failure, Success> either,
    required LogicState<S, Success, Failure> logicState,
  }) {
    final Option<S> nextStateOption = logicState.of(either, state);

    nextStateOption.fold(
      () {}, // 상태 변화가 필요 없는 경우
      (newState) => emit(newState), // 새로운 상태를 발행
    );
  }

  /// Executes an asynchronous operation and emits the resulting state.
  ///
  /// This method asynchronously runs the [task] and then uses the provided
  /// [logicState] to map the outcome to a new state. If a new state is
  /// returned, it's emitted to the UI.
  ///
  /// **Parameters:**
  /// - [task]: The asynchronous operation to execute, wrapped in a [TaskEither].
  /// - [logicState]: A [LogicState] that defines how to map the operation's result to the next state.
  ///
  /// ---
  /// 비동기 작업을 실행하고 결과 상태를 발행합니다.
  ///
  /// 이 메서드는 비동기적으로 [task]를 실행한 후, 제공된 [logicState]를
  /// 사용하여 그 결과를 새로운 상태로 매핑합니다. 새로운 상태가 반환되면, 해당 상태를
  /// UI에 발행합니다.
  ///
  /// **매개변수:**
  /// - [task]: [TaskEither]로 감싸진 실행할 비동기 작업입니다.
  /// - [logicState]: 연산 결과를 다음 상태로 매핑하는 방법을 정의하는 [LogicState]입니다.
  @protected
  Future<void> handleIntentPerformAsync<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required LogicState<S, Success, Failure> logicState,
  }) async {
    final Option<S> nextStateOption = await logicState.ofAsync(task, state);

    nextStateOption.fold(
      () {}, // 상태 변화가 필요 없는 경우
      (newState) => emit(newState), // 새로운 상태를 발행
    );
  }
}