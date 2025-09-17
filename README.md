[한국어](https://github.com/minhuits/bloc_arch_flow/blob/master/README-ko.md) | [English](https://github.com/minhuits/bloc_arch_flow/blob/master/README.md)

---

# Bloc Architecture Flow (bloc\_arch\_flow)

`bloc_arch_flow` is a Dart package that extends Flutter's BLoC (Business Logic Component) pattern by integrating
predictable architectural patterns like **MVI (Model-View-Intent)** and **TCA (The Composable Architecture)**. This
package helps structure state management logic and makes it easier to test by promoting a single-responsibility
principle.

## 🚀 Key Features

### 1. MVI (Model-View-Intent) Pattern Support

The `MviCubit` abstract class helps you manage **one-off side effects (Effects)** separately from the state. You can
handle UI actions like showing a snackbar or navigating to a new screen independently of state changes, which clearly
separates UI and business logic.

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

The `TcaBloc` abstract class enables a **purely functional reducer**-based architecture. All business logic is defined
within the reducer, which creates a predictable and easily testable state flow.

#### TcaCoreMixin

- `effectBuilder`
- `parallelEffectBuilder`
- `reduce`
- `sideEffect`

#### TcaBloc

- `handleAction`

#### LogicState

- `LogicState`

### 3. Test Suite

`BlocBaseTestSuite` is a base class for BLoC/Cubit testing. It automates test environment setups like `setUp` and
`tearDown`, making your test code more concise and reusable.

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

---

## 📦 Installation

Add the following dependencies to your `pubspec.yaml` file.

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

> **Note**: For immutable state management, we highly recommend using the `freezed` package.

-----

## 💡 Architecture Selection Guide

Not sure which architecture to use? This guide helps you determine the most suitable pattern for your project. Follow
the questions in order.

### **Question 1: Are most of your app's state changes simple and direct?**

* **Yes** → Use **Cubit**
* **No** → Go to Question 2

### **Question 2: In addition to state changes, do you need side effects like displaying a snackbar or navigating to a new

page based on a user's intent?**

* **Yes** → Use **MVI**
* **No** → Go to Question 3

### **Question 3: Is your business logic very complex, requiring multiple user events to interact sequentially and change

the state?**

* **Yes** → Use **Bloc**
* **No** → Go to Question 4

### **Question 4: Do you want to separate your business logic into pure functions and build a clear action loop where the

success or failure of an asynchronous task leads to the next action?**

* **Yes** → Use **TCA**
* **No** → Re-evaluate your needs and go back to Question 1.

-----

## 📖 Usage Examples

### MVI (Model-View-Intent)

The `MviCubit` provides a clean structure for handling intents and their related state and side effects.

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

The `TcaBloc` enables a purely functional reducer approach for predictable state changes.

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

Use the `BlocBaseTestSuite` to simplify your test environment setup and make tests more readable.

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

### **From `1.0.0` to `1.1.0`**

The `1.1.0` release introduces a cleaner API with the new `MviCubit` and `TcaBloc` classes.

The old `BlocArchMvi` and
`BlocArchTca` classes have been deprecated in this version to facilitate a smoother transition.

They will be completely removed in version `2.0.0`.

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

Simply replace the old abstract classes with the new `MviCubit` and `TcaBloc` classes. The core methods like
`mviEmitEffect` and `tcaReducer` remain, but they are now accessed through the mixins.