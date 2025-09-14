import 'package:bloc_arch_flow/bloc_arch_flow.dart';
import 'package:fpdart/fpdart.dart' show TaskEither;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_mvi.freezed.dart';

// Cubit
class CounterMviCubit extends MviCubit<CounterIntent, CounterState, CounterEffect> {
  final CounterEnvironment _environment;

  CounterMviCubit(this._environment) : super(CounterState.initial());

  @override
  Future<void> onIntent(CounterIntent intent) async {
    await intent.when(
      increment: () {
        // 동기적인 증가 로직: 상태만 업데이트합니다.
        emit(state.copyWith(count: state.count + 1));
      },
      decrement: () {
        // 동기적인 감소 로직: 상태만 업데이트합니다.
        emit(state.copyWith(count: state.count - 1));
      },
      incrementAsync: () async {
        // 비동기 작업 시작: 로딩 상태를 true로 설정합니다.
        emit(state.copyWith(isLoading: true, error: null));

        // mviPerformTaskEither를 사용하여 비동기 작업을 처리합니다.
        // TaskEither는 성공 시 String, 실패 시 Exception을 반환합니다.
        await handleIntentPerformAsync<Exception, int>(
          task: _environment.performAsyncIncrement(currentCount: state.count),
          logicState: logicState(),
        );
      },
      reset: () {
        // 리셋 로직: 초기 상태로 되돌립니다.
        emit(CounterState.initial());
      },
    );
  }

  LogicState<CounterState, int, Exception> logicState() {
    return LogicState<CounterState, int, Exception>(
      onSuccess: (int success, CounterState currentState) {
        // // 성공 시 로직: 카운트를 업데이트하고 토스트 메시지 효과를 발생시킵니다.
        emitEffect(const CounterEffect.showToast('Incremented successfully!'));
        return emitNewState(currentState.copyWith(count: success, isLoading: false));
      },
      onFailure: (Exception failure, CounterState currentState) {
        // 실패 시 로직: 에러 메시지를 상태에 저장하고 토스트 메시지 효과를 발생시킵니다.
        emitEffect(CounterEffect.showToast(failure.toString()));
        return emitNewState(currentState.copyWith(isLoading: false, error: failure.toString()));
      },
    );
  }
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