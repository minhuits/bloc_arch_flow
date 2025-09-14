import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_tca.freezed.dart';

final class CounterTcaBloc extends TcaBloc<CounterActions, CounterState, CounterEnvironment> {
  CounterTcaBloc(CounterEnvironment environment)
    : super(initialState: CounterState.initial(), environment: environment);

  @override
  TcaReducer<CounterActions, CounterState> reduce(
    CounterActions action,
    CounterState currentState,
    CounterEnvironment environment,
  ) {
    return action.when(
      increment: () {
        final CounterState newState = currentState.copyWith(count: currentState.count + 1);
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
      decrement: () {
        final CounterState newState = currentState.copyWith(count: currentState.count - 1);
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
      incrementAsync: () {
        final CounterState newState = currentState.copyWith(isLoading: true, error: null);
        final effect = effectBuilder<Object, int>(
          task: environment.performAsyncIncrement(currentCount: currentState.count),
          onSuccess: (newCount) {
            return CounterActions.success(newCount);
          },
          onFailure: (error) {
            final String errorMessage = error is Exception ? error.toString() : 'Unknown error';
            return CounterActions.failed(errorMessage);
          },
        );
        return TcaReducer.withEffect(newState: newState, effect: effect);
      },
      reset: () {
        final CounterState newState = CounterState.initial();
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
      success: (int newCount) {
        final CounterState newState = currentState.copyWith(
          isLoading: false,
          count: newCount,
          error: null,
        );
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
      failed: (String error) {
        final CounterState newState = currentState.copyWith(
          isLoading: false,
          error: error,
          count: currentState.count,
        );
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
      none: () {
        return TcaReducer.pure(newState: currentState, action: const CounterActions.none());
      },
      // 새로운 액션 처리 로직
      runBothTasks: () {
        final effect = parallelEffectBuilder(
          effects: [
            // 카운트 증가 비동기 효과
            effectBuilder(
              task: environment.performAsyncIncrement(currentCount: currentState.count),
              onSuccess: (newCount) => CounterActions.success(newCount),
              onFailure: (error) => CounterActions.failed(error.toString()),
            ),

            // 카운트 증가 비동기 효과
            effectBuilder(
              task: environment.performAsyncIncrement(currentCount: currentState.count),
              onSuccess: (_) => CounterActions.success(0), // 성공했지만 상태 변화 없음
              onFailure: (error) => CounterActions.failed(error.toString()),
            ),
          ],
          onSuccess: (successList) {
            // 모든 효과가 성공했을 때, 첫 번째 효과의 성공 값(newCount)을 사용합니다.
            final newCount = (successList.first as AsyncIncrementSuccess).newCount;
            return CounterActions.bothTasksSucceeded(newCount);
          },
          onFailure: (failure) {
            // 하나라도 실패하면 실패 액션을 반환합니다.
            final error = (failure as AsyncIncrementFailed).error;
            return CounterActions.anyTaskFailed(error);
          },
        );
        return TcaReducer.withEffect(
          newState: currentState.copyWith(isLoading: true),
          effect: effect,
        );
      },
      // 병렬 작업 성공 후 상태 업데이트
      bothTasksSucceeded: (newCount) {
        final newState = currentState.copyWith(count: newCount, isLoading: false, error: null);
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
      // 병렬 작업 실패 후 에러 상태 업데이트
      anyTaskFailed: (error) {
        final newState = currentState.copyWith(isLoading: false, error: error);
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
    );
  }
}

// Actions
@freezed
sealed class CounterActions with _$CounterActions {
  const factory CounterActions.increment() = IncrementTCA;

  const factory CounterActions.decrement() = DecrementTCA;

  const factory CounterActions.incrementAsync() = IncrementAsyncTCA;

  const factory CounterActions.reset() = ResetTCA;

  const factory CounterActions.success(int newCount) = AsyncIncrementSuccess;

  const factory CounterActions.failed(String error) = AsyncIncrementFailed;

  const factory CounterActions.bothTasksSucceeded(int newCount) = BothTasksSucceeded;

  const factory CounterActions.anyTaskFailed(String error) = AnyTaskFailed;

  const factory CounterActions.runBothTasks() = RunBothTasks;

  const factory CounterActions.none() = NoneTCA;
}

// INTENT
@freezed
sealed class CounterIntent with _$CounterIntent {
  const factory CounterIntent.increment() = Increment;

  const factory CounterIntent.decrement() = Decrement;

  const factory CounterIntent.incrementAsync() = IncrementAsync;

  const factory CounterIntent.reset() = Reset;
}

// EFFECT
@freezed
sealed class CounterEffect with _$CounterEffect {
  const factory CounterEffect.showToast(String message) = ShowToast;

  const factory CounterEffect.navigateTo(String route) = NavigateTo;

  const factory CounterEffect.playSound(String soundAsset) = PlaySound;
}

// STATE
@freezed
abstract class CounterState with _$CounterState {
  const factory CounterState({
    @Default(0) int count,
    @Default(false) bool isLoading,
    String? error,
  }) = _CounterState;

  factory CounterState.initial() => const CounterState();
}

// ENVIRONMENT
class CounterEnvironment {
  TaskEither<Exception, int> performAsyncIncrement({required int currentCount}) {
    return TaskEither.tryCatch(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (currentCount >= 5) {
        throw Exception("Cannot increment beyond 5!");
      }
      return currentCount + 1;
    }, (e, s) => e is Exception ? e : Exception(e.toString()));
  }
}