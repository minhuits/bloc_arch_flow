[한국어](https://github.com/minhuits/bloc_arch_flow/blob/master/README-ko.md) | [English](https://github.com/minhuits/bloc_arch_flow/blob/master/README.md)

---

# Bloc Architecture Flow (bloc_arch_flow)

`bloc_arch_flow` is a Dart package that extends Flutter's BLoC (Business Logic Component) pattern by integrating
predictable architectural patterns like **MVI (Model-View-Intent)** or **TCA (The Composable Architecture)**. This
package helps structure state management logic and makes it easier to test.

---

## 🚀 Key Features

### 1. MVI (Model-View-Intent) Pattern Support

The `BlocArchMvi` abstract class helps you manage **one-off side effects (Effects)** separately from the **state**. For
example, you can handle UI actions like showing a snackbar or navigating to a new screen independently of state
changes, which clearly separates UI and business logic.

* `mviEffects`: A stream for the UI to subscribe to and process side effects.
* `mviEmitEffect`: A method to emit a side effect through the `mviEffects` stream.
* `mviPerformTaskEither`: A utility that uses `fpdart`'s `TaskEither` to handle the success and failure of asynchronous
  operations in a clean, functional way.

### 2. TCA (The Composable Architecture) Pattern Support

The `BlocArchTca` abstract class enables a **purely functional reducer**-based architecture. All business logic is
defined within the reducer, which creates a predictable and easily testable state flow.

* `tcaReducer`: A pure function that processes an **action** and returns a new state and a side effect.
* `tcaPerformEffect`: A utility that uses `TaskEither` to execute an asynchronous side effect and re-injects the result
  back into the system as a new action.

### 3. Automated Testing (`BlocTestSuite`)

`BlocTestSuite` is an abstract class for BLoC/Cubit testing. It automates test environment setups like `setUp` and
`tearDown`, making your test code more concise and reusable.

* `initTestSuite()`: Automatically performs test suite initialization and cleanup tasks.
* `blocArchTest()`: A wrapper for `bloc_test` that simplifies test environment setup.

---

## 📦 Installation

Add the following dependencies to your `pubspec.yaml` file.

```yaml
dependencies:
  freezed_annotation: ^3.1.0
  fpdart: ^1.1.1
  flutter_bloc: ^9.1.1
  bloc: ^9.0.0
  bloc_arch_flow: ^1.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter

  freezed: ^3.2.0
  build_runner: ^2.6.0
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```

## 📖 Usage

### MVI (Model-View-Intent)

```dart
// MVI pattern applied to a BLoC example
class CounterMviBloc extends BlocArchMvi<CounterIntent, CounterState, CounterEffect> {
  CounterMviBloc(super.initialState);

  @override
  Future<void> mviHandleIntent(CounterIntent intent, Emitter<CounterState> stateEmitter) {
    // Implement intent handling logic here
  }
}
```

### TCA (The Composable Architecture)

```dart
// TCA pattern applied to a BLoC example
class CounterTcaBloc extends BlocArchTca<CounterActions, CounterState, CounterEnvironment> {
  CounterTcaBloc(super.initialState, super.environment);

  @override
  ReducerEffect<CounterState, CounterActions> tcaReducer(
    CounterActions action,
    CounterState currentState,
    CounterEnvironment environment,
  ) {
    // Implement reducer logic here
    return (newState: currentState, effect: TaskEither.right(CounterActions.none()));
  }
}
```

### Test Suite

```dart
// Test code using BlocTestSuite
class CounterMviBlocTestSuite
    extends BlocTestSuite<CounterMviBloc, CounterState, CounterIntent, CounterEnvironment> {
  @override
  CounterMviBloc buildBloc(CounterEnvironment environment) => CounterMviBloc(environment);

  @override
  CounterEnvironment buildEnvironment() => MockCounterEnvironment();
}

void main() {
  final testSuite = CounterMviBlocTestSuite();

  group('CounterMviBloc', () {
    testSuite.initTestSuite();

    testSuite.blocArchTest(
      'incrementAsync success should update count and set isLoading to false',
      // ... test logic
    );
  });
}
```