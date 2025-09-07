import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:fpdart/fpdart.dart';

import 'counter_types.dart';

class CounterTcaBloc extends BlocArchTca<CounterActions, CounterState, CounterEnvironment> {
  CounterTcaBloc(CounterEnvironment environment) : super(CounterState.initial(), environment) {
    on<CounterActions>((action, emit) async {
      /// Call the pure TCA reducer to process the action and get the new state and effect.
      ///
      /// 순수 TCA 리듀서를 호출하여 액션을 처리하고 새 상태와 이펙트를 가져옵니다.
      final ReducerEffect<CounterState, CounterActions> reduction = tcaReducer(
        action,
        state,
        environment,
      );
      emit(reduction.newState);
      final effectResult = await reduction.effect.run();
      effectResult.fold(
        (failure) {
          debugPrint('TCA 이펙트 전역 실패: $failure');
          if (action is! AsyncIncrementFailed) {
            add(CounterActions.failed(failure.toString()));
          }
        },
        (nextAction) {
          if (nextAction is! NoneTCA) {
            add(nextAction);
          }
        },
      );
    });
  }

  @override
  ReducerEffect<CounterState, CounterActions> tcaReducer(
    CounterActions action,
    CounterState currentState,
    CounterEnvironment environment,
  ) {
    return action.when(
      increment: () {
        final CounterState newState = currentState.copyWith(count: currentState.count + 1);
        return (newState: newState, effect: TaskEither.right(CounterActions.none()));
      },
      decrement: () {
        final CounterState newState = currentState.copyWith(count: currentState.count - 1);
        return (newState: newState, effect: TaskEither.right(CounterActions.none()));
      },
      incrementAsync: () {
        final CounterState newState = currentState.copyWith(isLoading: true, error: null);
        final effect = tcaEffectBuilder<Object, int>(
          task: environment.performAsyncIncrement(currentCount: currentState.count),
          onSuccess: (newCount) {
            return CounterActions.success(newCount);
          },
          onFailure: (error) {
            final errorMessage = error is Exception ? error.toString() : 'Unknown error';
            return CounterActions.failed(errorMessage);
          },
        );
        return (newState: newState, effect: effect);
      },
      reset: () {
        final CounterState newState = CounterState.initial();
        return (newState: newState, effect: TaskEither.right(CounterActions.none()));
      },
      success: (int newCount) {
        final CounterState newState = currentState.copyWith(
          isLoading: false,
          count: newCount,
          error: null,
        );
        return (newState: newState, effect: TaskEither.right(CounterActions.none()));
      },
      failed: (String error) {
        final CounterState newState = currentState.copyWith(
          isLoading: false,
          error: error,
          count: currentState.count,
        );
        return (newState: newState, effect: TaskEither.right(CounterActions.none()));
      },
      none: () {
        return (newState: currentState, effect: TaskEither.right(CounterActions.none()));
      },
    );
  }
}