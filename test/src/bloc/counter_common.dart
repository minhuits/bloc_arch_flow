import 'package:flutter/foundation.dart';
import 'package:fpdart/src/task_either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_common.freezed.dart';

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