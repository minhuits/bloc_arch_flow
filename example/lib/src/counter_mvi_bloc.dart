import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_arch_flow/bloc_arch_flow.dart';

import 'counter_types.dart';

typedef MviBlocCounter = BlocArchMvi<CounterIntent, CounterState, CounterEffect>;

class CounterMviBloc extends MviBlocCounter {
  final CounterEnvironment _environment;

  CounterMviBloc(this._environment) : super(CounterState.initial()) {
    on<CounterIntent>((intent, emit) async {
      await handleIntent(intent, emit);
    });
  }

  @override
  Future<void> handleIntent(CounterIntent intent, Emitter<CounterState> blocEmit) async {
    await intent.when(
      increment: () {
        // 동기적인 증가 로직: 상태만 업데이트합니다.
        blocEmit(state.copyWith(count: state.count + 1));
      },
      decrement: () {
        // 동기적인 감소 로직: 상태만 업데이트합니다.
        blocEmit(state.copyWith(count: state.count - 1));
      },
      incrementAsync: () async {
        // 비동기 작업 시작: 로딩 상태를 true로 설정합니다.
        blocEmit(state.copyWith(isLoading: true, error: null));

        // mviPerformTaskEither를 사용하여 비동기 작업을 처리합니다.
        // TaskEither는 성공 시 String, 실패 시 Exception을 반환합니다.
        await performTaskEither<Exception, int>(
          task: _environment.performAsyncIncrement(currentCount: state.count),
          // currentState: state,
          onFailure: (failure, currentState) {
            // 실패 시 로직: 에러 메시지를 상태에 저장하고 토스트 메시지 효과를 발생시킵니다.
            emitEffect(CounterEffect.showToast('Error: ${failure.toString()}'));
            return currentState.copyWith(isLoading: false, error: failure.toString());
          },
          onSuccess: (success, currentState) {
            // 성공 시 로직: 카운트를 업데이트하고 토스트 메시지 효과를 발생시킵니다.
            emitEffect(const CounterEffect.showToast('Incremented successfully!'));
            return currentState.copyWith(count: success, isLoading: false);
          },
          blocEmit: blocEmit,
        );
      },
      reset: () {
        // 리셋 로직: 초기 상태로 되돌립니다.
        blocEmit(CounterState.initial());
      },
    );
  }
}