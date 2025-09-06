import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'counter_common.dart' show CounterState, CounterEnvironment;

part 'counter_tca.freezed.dart';

typedef TcaBlocCounter = BlocArchTca<CounterActions, CounterState, CounterEnvironment>;

// Bloc
class CounterTcaBloc extends TcaBlocCounter {
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

      /// Emit the new state returned by the reducer.
      ///
      /// 리듀서가 반환한 새 상태를 발행합니다.
      emit(reduction.newState);

      /// Run the effect task returned by the reducer.
      ///
      /// 리듀서가 반환한 이펙트 태스크를 실행합니다.
      final effectResult = await reduction.effect.run();

      /// Fold the result of the effect task
      ///
      /// 이펙트 태스크의 결과를 접습니다.
      effectResult.fold(
        (failure) {
          /// Handle global effect failures (e.g., logging)
          ///
          /// 전역 이펙트 실패 처리 (예: 로깅)
          debugPrint('TCA 이펙트 전역 실패: $failure');

          /// Dispatch a failure action if it's not already one (to prevent infinite loops)
          ///
          /// 실패 액션이 이미 존재하지 않는 경우 (무한 루프 방지) 실패 액션을 다시 디스패치합니다.
          if (action is! AsyncIncrementFailed) {
            add(CounterActions.failed(failure.toString()));
          }
        },
        (nextAction) {
          /// If the effect successfully produced a new action, dispatch it back to the Bloc (action chaining)
          ///
          /// 이펙트가 성공적으로 새 액션을 생성했다면, 해당 액션을 Bloc에 다시 디스패치합니다 (액션 체이닝).
          ///
          /// NoOp 액션이 아니거나, null이 아닌 경우에만 다시 디스패치
          if (nextAction is! NoneTCA) {
            // nextAction이 NoOpTCA가 아닐 때만 add
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
        final TaskEither<Object, CounterActions> effect = tcaPerformEffect<Object, int>(
          task: environment.performAsyncIncrement(currentCount: currentState.count),
          onSuccess: (newCount) {
            return CounterActions.success(newCount);
          },
          onFailure: (error) {
            final errorMessage = error is Exception ? error.toString() : 'Unknown error';
            return errorMessage;
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

// Actions
@freezed
sealed class CounterActions with _$CounterActions {
  const factory CounterActions.increment() = IncrementTCA;

  const factory CounterActions.decrement() = DecrementTCA;

  const factory CounterActions.incrementAsync() = IncrementAsyncTCA;

  const factory CounterActions.reset() = ResetTCA;

  const factory CounterActions.success(int newCount) = AsyncIncrementSuccess;

  const factory CounterActions.failed(String error) = AsyncIncrementFailed;

  const factory CounterActions.none() = NoneTCA;
}