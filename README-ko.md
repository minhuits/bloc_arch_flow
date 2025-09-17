[한국어](https://github.com/minhuits/bloc_arch_flow/blob/master/README-ko.md) | [English](https://github.com/minhuits/bloc_arch_flow/blob/master/README.md)

---

# Bloc Architecture Flow (bloc\_arch\_flow)

`bloc_arch_flow`는 Flutter의 `BLoC(Business Logic Component)` 패턴을 확장하여 **MVI (Model-View-Intent)** 또는 **TCA (The
Composable
Architecture)** 와 같은 예측 가능한 아키텍처 패턴을 통합하는 Dart 패키지입니다.

이 패키지는 상태 관리 로직을 더욱 구조화하고 테스트하기 쉽게 만듭니다.

## 🚀 Key Features

### 1. MVI (Model-View-Intent) 패턴 지원

`MviCubit` 추상 클래스를 통해 **상태(State)** 와 분리된 일회성 **부수 효과(Effect)** 를 관리할 수 있습니다.
예를 들어, `showSnackbar`나 `MapsTo`와 같은 UI 동작을 상태 변경과 별도로 처리하여, UI와 비즈니스 로직을 명확하게 분리합니다.

#### Core

- `effects`
- `emitEffect`
- `emitNewState`
- `close`

#### Type

- `TcaEffect`
- `TcaReducer`

#### MviCubit

- `onIntent`
- `handleIntentPerform`
- `handleIntentPerformAsync`

### 2. TCA (The Composable Architecture) Pattern Support

`TcaBloc` 추상 클래스를 통해 **순수 함수형 리듀서(Reducer)** 기반 아키텍처를 구현할 수 있습니다.

모든 비즈니스 로직은 **리듀서(Reducer)** 내부에 정의되어 예측 가능하고 테스트하기 쉬운 **단일 책임 원칙**을 따릅니다.

#### TcaCoreMixin

- `effectBuilder`
- `parallelEffectBuilder`
- `reduce`
- `sideEffect`

#### TcaBloc

- `handleAction`

#### LogicState

- `LogicState`

### 3. 테스트 스위트 (Test Suite)

`bloc_arch_flow`는 MVI와 TCA 패턴에 최적화된 테스트 스위트를 제공하여, 블랙박스 테스트를 쉽게 작성할 수 있도록 돕습니다.

#### BlocBaseTestSuite

- `buildMockEnvironment`
- `buildInitialState`
- `buildMockBaseBloc`
- `initTestSuite`

#### TestSuiteUtilityMixin

- `whenSuccessTask`
- `whenFailureTask`
- `whenSuccess`
- `whenFailure`

#### TcaBlocTestSuite

- `reduceTest`
- `effectBuilderTest`
- `testEffect`
- `testReducer`
- `testSequence`
- `step`

#### Step

- `ReducerStep`
- `ReducerStepAction`

## 📦 설치

`pubspec.yaml` 파일에 다음 종속성을 추가하십시오.

```yaml
dependencies:
  fpdart: ^1.1.1
  flutter_bloc: ^9.1.1
  bloc: ^9.0.0
  bloc_arch_flow: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```

> **Note**: 불변의 국가 관리를 위해서는`freezed` 패키지를 사용하는 것이 좋습니다.

---

## 💡 Architecture Selection Guide

어떤 아키텍처를 사용할지 잘 모르시겠습니까?

이 안내서는 프로젝트에 가장 적합한 패턴을 결정하는 데 도움이됩니다. 질문을 순서대로 따르십시오.

### 질문 1. 대부분의 앱 상태 변경이 간단하고 직접적입니까?

* **예** → **Cubit**
* **아니요** → 다음 질문 2

### 질문 2 상태 변경 외에도 스낵바를 표시하거나 사용자의 의도에 따라 새 페이지로 탐색하는 것과 같은 부작용이 필요합니까?

* **예** → **MVI**
* **아니요** → 다음 질문 3

### 질문 3. 비즈니스 논리가 매우 복잡하여 여러 사용자 이벤트가 순차적으로 상호 작용하고 상태를 변경해야합니까?

* **예** → **Bloc**
* **아니요** → 다음 질문 4

### 질문 4. 비동기 논리를 순수한 기능으로 분리하고 비동기 작업의 성공 또는 실패가 다음 조치로 이어지는 명확한 액션 루프를 구축하려고합니까?

* **예** → **TCA**
* **아니요** → 질문1부터 다시해보세요

---

## 📖 Usage Examples

### MVI (Model-View-Intent)

MVI 패턴은 `MviCubit`을 사용하여 구현됩니다. 비즈니스 로직은 `onIntent` 메서드 내에서 처리됩니다.

```dart
// MVI pattern applied to a Cubit
class CounterMviCubit extends MviCubit<CounterIntent, CounterState, CounterEffect> {
  CounterMviCubit(this._environment) : super(CounterState.initial());

  final CounterEnvironment _environment;

  @override
  Future<void> onIntent(CounterIntent intent) async {
    await intent.when(
      increment: () {
        emit(state.copyWith(count: state.count + 1));
      },
      decrement: () {
        emit(state.copyWith(count: state.count - 1));
      },
      incrementAsync: () async {
        emit(state.copyWith(isLoading: true, error: null));
        await handleIntentPerformAsync<Exception, int>(
          task: _environment.performAsyncIncrement(currentCount: state.count),
          logicState: logicState(),
        );
      },
      reset: () {
        emit(CounterState.initial());
      },
    );
  }

  LogicState<CounterState, int, Exception> logicState() {
    return LogicState<CounterState, int, Exception>(
      onSuccess: (int success, CounterState currentState) {
        emitEffect(const CounterEffect.showToast('Incremented successfully!'));
        return emitNewState(currentState.copyWith(count: success, isLoading: false));
      },
      onFailure: (Exception failure, CounterState currentState) {
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
```

### TCA (The Composable Architecture)

TCA 패턴은 `TcaBloc`을 사용하여 구현됩니다. 모든 로직은 `reduce` 메서드 내의 순수 함수로 정의됩니다.

```dart
// TCA pattern applied to a BLoC
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
      runBothTasks: () {
        final effect = parallelEffectBuilder(
          effects: [
            effectBuilder(
              task: environment.performAsyncIncrement(currentCount: currentState.count),
              onSuccess: (newCount) => CounterActions.success(newCount),
              onFailure: (error) => CounterActions.failed(error.toString()),
            ),

            effectBuilder(
              task: environment.performAsyncIncrement(currentCount: currentState.count),
              onSuccess: (_) => CounterActions.success(0),
              onFailure: (error) => CounterActions.failed(error.toString()),
            ),
          ],
          onSuccess: (successList) {
            final newCount = (successList.first as AsyncIncrementSuccess).newCount;
            return CounterActions.bothTasksSucceeded(newCount);
          },
          onFailure: (failure) {
            final error = (failure as AsyncIncrementFailed).error;
            return CounterActions.anyTaskFailed(error);
          },
        );
        return TcaReducer.withEffect(
          newState: currentState.copyWith(isLoading: true),
          effect: effect,
        );
      },
      bothTasksSucceeded: (newCount) {
        final newState = currentState.copyWith(count: newCount, isLoading: false, error: null);
        return TcaReducer.pure(newState: newState, action: const CounterActions.none());
      },
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
```

## Test Suite

`bloc_arch_flow`는 테스트를 위한 전용 추상 클래스를 제공합니다.

### MVI

```dart
class CounterMock extends Mock implements CounterEnvironment {}

typedef CounterCubit =
MviCubitTestSuite<CounterMviCubit, CounterIntent, CounterState, CounterEffect, CounterEnvironment>;

// Test code using BlocBaseTestSuite
class CounterCubitTestSuite extends CounterCubit {
  @override
  CounterState buildInitialState() => CounterState.initial();

  @override
  CounterMviCubit buildMockBaseBloc() => CounterMviCubit(mockEnvironment);

  @override
  CounterEnvironment buildMockEnvironment() => CounterMock();
}

void main() {
  final CounterCubitTestSuite testSuite = CounterCubitTestSuite();

  group('CounterMviCubit', () {
    testSuite.initTestSuite();

    testSuite.testState(
      'The count must increase by 1 when the Increment Intent occurs.',
      intent: const CounterIntent.increment(),
      expectedState: const CounterState(count: 1),
    );

    testSuite.testState(
      'The count must be reduced by 1 when an increment intent occurs.',
      intent: const CounterIntent.decrement(),
      expectedState: const CounterState(count: -1),
    );

    testSuite.testSideEffect(
      'Toast effects must be generated when successful IncrementAsync.',
      intent: const CounterIntent.incrementAsync(),
      expectedEffect: const CounterEffect.showToast('Incremented successfully!'),
      setUp: () {
        when(
              () =>
              testSuite.mockEnvironment.performAsyncIncrement(
                currentCount: any(named: 'currentCount'),
              ),
        ).thenAnswer((_) => testSuite.whenSuccessTask(1));
      },
    );

    testSuite.testSideEffect(
      'Toast effects must be generated when successful IncrementAsync.',
      intent: const CounterIntent.incrementAsync(),
      expectedEffect: const CounterEffect.showToast('Exception: Cannot increment beyond 5!'),
      setUp: () {
        when(
              () =>
              testSuite.mockEnvironment.performAsyncIncrement(
                currentCount: any(named: 'currentCount'),
              ),
        ).thenAnswer((_) => testSuite.whenFailureTask(Exception('Cannot increment beyond 5!')));
      },
    );

    testSuite.testCubitGroup(
      'IncrementAsync success must be loaded, final and toast effect.',
      intent: const CounterIntent.incrementAsync(),
      loadingState: const CounterState(isLoading: true),
      finalState: const CounterState(count: 1, isLoading: false),
      expectedEffect: const CounterEffect.showToast('Incremented successfully!'),
      wait: const Duration(seconds: 1, milliseconds: 1),
      setUp: () {
        when(
              () =>
              testSuite.mockEnvironment.performAsyncIncrement(
                currentCount: any(named: 'currentCount'),
              ),
        ).thenAnswer((_) => testSuite.whenSuccessTask(1));
      },
    );

    testSuite.testCubitGroup(
      'IncrementAsync failures must result in error status and error toast effect.',
      intent: const CounterIntent.incrementAsync(),
      loadingState: const CounterState(isLoading: true),
      finalState: const CounterState(
        isLoading: false,
        error: 'Exception: Cannot increment beyond 5!',
      ),
      wait: const Duration(seconds: 1, milliseconds: 50),
      expectedEffect: const CounterEffect.showToast('Exception: Cannot increment beyond 5!'),
      setUp: () {
        when(
              () =>
              testSuite.mockEnvironment.performAsyncIncrement(
                currentCount: any(named: 'currentCount'),
              ),
        ).thenAnswer((_) => testSuite.whenFailureTask(Exception('Cannot increment beyond 5!')));
      },
    );
  });
}
```

### TCA

```dart
class MockCounter extends Mock implements CounterEnvironment {}

// TcaBlocTestSuite<B extends TcaBloc<A, S, E>, A, S, E>
typedef CounterBloc =
TcaBlocTestSuite<CounterTcaBloc, CounterActions, CounterState, CounterEnvironment>;

class CounterBlocTestSuite extends CounterBloc {
  @override
  CounterState buildInitialState() => const CounterState();

  @override
  CounterTcaBloc buildMockBaseBloc() => CounterTcaBloc(mockEnvironment);

  @override
  CounterEnvironment buildMockEnvironment() => MockCounter();

  @override
  TcaReducer<CounterActions, CounterState> reduceTest(CounterActions action,
      CounterState currentState,
      CounterEnvironment environment,) {
    return mockBaseBloc.reduce(action, currentState, environment);
  }
}

void main() {
  group('CounterBloc', () {
    final CounterBlocTestSuite testSuite = CounterBlocTestSuite();
    testSuite.initTestSuite();

    group('testSequence', () {
      testSuite.testSequence(
        'INCREMENT-> Decrement-> Reset The condition must change correctly.',
        initialState: const CounterState(count: 1),
        steps: [
          testSuite.step(
            'Increment action increases by 6.',
            stepAction: ReducerStepAction.pure(action: const CounterActions.increment()),
            state: const CounterState(count: 6),
            effect: isA<TcaEffect>(),
          ),
          testSuite.step(
            'Count is reduced to 5 with Decrement action.',
            stepAction: ReducerStepAction.pure(action: const CounterActions.decrement()),
            state: const CounterState(count: 5),
            effect: isA<TcaEffect>(),
          ),
          testSuite.step(
            'Reset action returns to the initial state Count: 0.',
            stepAction: ReducerStepAction.pure(action: const CounterActions.reset()),
            state: CounterState.initial(),
            effect: isA<TcaEffect>(),
          ),
        ],
        wait: const Duration(milliseconds: 100),
      );
    });

    group('testEffect', () {
      testSuite.testEffect(
        'IncrementAsync successes will be updated and isLanding becomes false.',
        setUp: () {
          when(
                () =>
                testSuite.mockEnvironment.performAsyncIncrement(
                  currentCount: any(named: 'currentCount'),
                ),
          ).thenAnswer((_) => testSuite.whenSuccessTask(5));
        },
        stepAction: ReducerStepAction.success(
          action: const CounterActions.incrementAsync(),
          expected: const CounterActions.success(5),
        ),
        wait: const Duration(milliseconds: 10),
      );

      testSuite.testEffect(
        'IncrementAsync failures are set when the failure is set and isLoading becomes false.',
        setUp: () {
          final exception = Exception("Cannot increment beyond 5!");
          when(
                () =>
                testSuite.mockEnvironment.performAsyncIncrement(
                  currentCount: any(named: 'currentCount'),
                ),
          ).thenAnswer((_) => testSuite.whenFailureTask(exception));
        },
        stepAction: ReducerStepAction.failure(
          action: const CounterActions.incrementAsync(),
          expected: const CounterActions.failed("Exception: Cannot increment beyond 5!"),
        ),
        wait: const Duration(milliseconds: 10),
      );
    });

    group('testReducer', () {
      testSuite.testReducer(
        'Increment Action: Count must increase by 1.',
        action: const CounterActions.increment(),
        initialState: const CounterState(count: 0),
        expectedState: const CounterState(count: 1),
        expectedEffect: isA<TcaEffect>(),
      );

      testSuite.testReducer(
        'Decrement Action: Count must be reduced by 1.',
        action: const CounterActions.decrement(),
        initialState: const CounterState(count: 0),
        expectedState: const CounterState(count: -1),
        expectedEffect: isA<TcaEffect>(),
      );

      testSuite.testReducer(
        'Reset Action: The condition must be initialized.',
        action: const CounterActions.reset(),
        initialState: const CounterState(count: 10, isLoading: true, error: 'some error'),
        expectedState: CounterState.initial(),
        expectedEffect: isA<TcaEffect>(),
      );
    });
  });
}

```

-----

## ⚙️ Migration Guide

### **`1.0.0`버전에서 `1.1.0` 버전으로**

`1.1.0` 릴리스는 새로운 `MviCubit` 및 `TcaBloc` 클래스를 도입하여 더 깔끔한 API를 제공합니다.

기존의 `BlocArchMvi`와 `BlocArchTca` 클래스는 더 이상 사용되지 않습니다 (deprecated).

이 클래스들은 `2.0.0` 버전에서 완전히 제거될 예정입니다.

**Old API (`1.0.0`)**

```dart
// Old MVI example
class CounterMviBloc extends BlocArchMvi<CounterIntent, CounterState, CounterEffect> {
  // ...
}

// Old TCA example
class CounterTcaBloc extends BlocArchTca<CounterAction, CounterState, CounterEnvironment> {
  // ...
}
```

**New API (`1.1.0`)**

```dart
// New MVI example (MviCubit)
class CounterMviCubit extends MviCubit<CounterIntent, CounterState, CounterEffect> {
  // ...
}

// New TCA example (TcaBloc)
class CounterTcaBloc extends TcaBloc<CounterAction, CounterState, CounterEnvironment> {
  // ...
}
```