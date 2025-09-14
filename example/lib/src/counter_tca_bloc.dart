import 'package:bloc_arch_flow/bloc_arch_flow.dart';

import 'counter_types.dart';

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
        return TcaReducer.pure(newState: newState, action: CounterActions.none());
      },
      decrement: () {
        final CounterState newState = currentState.copyWith(count: currentState.count - 1);
        return TcaReducer.pure(newState: newState, action: CounterActions.none());
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
        return TcaReducer.pure(newState: newState, action: CounterActions.none());
      },
      success: (int newCount) {
        final CounterState newState = currentState.copyWith(
          isLoading: false,
          count: newCount,
          error: null,
        );
        return TcaReducer.pure(newState: newState, action: CounterActions.none());
      },
      failed: (String error) {
        final CounterState newState = currentState.copyWith(
          isLoading: false,
          error: error,
          count: currentState.count,
        );
        return TcaReducer.pure(newState: newState, action: CounterActions.none());
      },
      none: () {
        return TcaReducer.pure(newState: currentState, action: CounterActions.none());
      },
    );
  }
}