part of 'mvi_core.dart';

/// A class that represents the state changes resulting from a business logic operation.
///
/// It encapsulates the logic for mapping the outcome of an operation (Success or Failure)
/// to a new state.
///
/// **Type Parameters:**
/// - [State]: The type of the state being managed.
/// - [Success]: The type of the value returned on a successful operation.
/// - [Failure]: The type of the error returned on a failed operation.
///
/// ---
/// 비즈니스 로직 연산으로부터 발생하는 상태 변화를 나타내는 클래스입니다.
///
/// 연산의 결과(성공 또는 실패)를 새로운 상태로 매핑하는 로직을 캡슐화합니다.
///
/// **타입 매개변수:**
/// - [State]: 관리 중인 상태의 타입.
/// - [Success]: 성공적인 연산에서 반환되는 값의 타입.
/// - [Failure]: 실패한 연산에서 반환되는 오류의 타입.
final class LogicState<State, Success, Failure> {
  final Option<State> Function(Success success, State state) onSuccess;
  final Option<State> Function(Failure failure, State state) onFailure;

  /// Creates a transformer for mapping operation outcomes to new states.
  ///
  /// - [onSuccess]: A callback that computes the next state upon operation success.
  /// - [onFailure]: A callback that computes the next state upon operation failure.
  ///
  /// ---
  /// 연산 결과물을 새로운 상태에 매핑하기 위한 변환기를 생성합니다.
  ///
  /// - [onSuccess]: 작업 성공 시 다음 상태를 계산하는 콜백입니다.
  /// - [onFailure]: 작업 실패 시 다음 상태를 계산하는 콜백입니다.
  const LogicState({required this.onSuccess, required this.onFailure});

  /// Transforms a synchronous operation's result into a new state.
  ///
  /// This method takes a [Either] and the current [state] to compute the next state
  /// by applying the appropriate [onSuccess] or [onFailure] callback.
  ///
  /// **Parameters:**
  /// - [either]: The result of a synchronous operation, wrapped in a [Either].
  /// - [state]: The current state of the Cubit.
  ///
  /// **Returns:**
  /// The newly computed state, or [Option.None] if no state change is required.
  ///
  /// ---
  /// 동기 작업의 결과를 새로운 상태로 변환합니다.
  ///
  /// 이 메서드는 [Either]과 현재 [state]를 사용하여, 적절한 [onSuccess] 또는
  /// [onFailure] 콜백을 적용해 다음 상태를 계산합니다.
  ///
  /// **매개변수:**
  /// - [either]: [Either]으로 감싸진 동기 작업의 결과입니다.
  /// - [state]: Cubit의 현재 상태입니다.
  ///
  /// **반환:**
  /// 새로 계산된 상태를 반환하며, 상태 변경이 필요하지 않은 경우 [Option.None]을 반환합니다.
  Option<State> of(Either<Failure, Success> either, State state) {
    return either.fold(
      (failure) => onFailure(failure, state),
      (success) => onSuccess(success, state),
    );
  }

  /// Transforms an asynchronous operation's result into a new state.
  ///
  /// This method executes an asynchronous [task] and uses the resulting [TaskEither]
  /// to compute the next state by calling the [of] method.
  ///
  /// **Parameters:**
  /// - [task]: The asynchronous operation to execute, wrapped in a [Either].
  /// - [state]: The current state of the BLoC or Cubit.
  ///
  /// **Returns:**
  /// The newly computed state, or [Option.None] if no state change is required.
  ///
  /// ---
  /// 비동기 작업의 결과를 새로운 상태로 변환합니다.
  ///
  /// 이 메서드는 비동기 [task]를 실행하고, 그 결과로 얻은 [TaskEither]을
  /// [of] 메서드에 전달하여 다음 상태를 계산합니다.
  ///
  /// **매개변수:**
  /// - [task]: [TaskEither]로 감싸진 실행할 비동기 작업입니다.
  /// - [state]: BLoC 또는 Cubit의 현재 상태입니다.
  ///
  /// **반환:**
  /// 새로 계산된 상태를 반환하며, 상태 변경이 필요하지 않은 경우 [Option.None]을 반환합니다.
  Future<Option<State>> ofAsync(TaskEither<Failure, Success> task, State state) async {
    final Either<Failure, Success> either = await task.run();

    return either.fold(
      (failure) => onFailure(failure, state),
      (success) => onSuccess(success, state),
    );
  }
}