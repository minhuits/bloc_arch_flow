import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_types.freezed.dart';

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