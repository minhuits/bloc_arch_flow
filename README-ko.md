[한국어](https://github.com/minhuits/bloc_arch_flow/blob/master/README-ko.md) | [English](https://github.com/minhuits/bloc_arch_flow/blob/master/README.md)

---

# Bloc Architecture Flow (bloc_arch_flow)

`bloc_arch_flow`는 Flutter의 BLoC(Business Logic Component) 패턴을 확장하여 **MVI (Model-View-Intent)** 또는 **TCA (The Composable
Architecture)**와 같은 예측 가능한 아키텍처 패턴을 통합하는 Dart 패키지입니다. 이 패키지는 상태 관리 로직을 더욱 구조화하고 테스트하기 쉽게 만듭니다.

---

## 🚀 주요 기능

### 1. MVI (Model-View-Intent) 패턴 지원

`BlocArchMvi` 추상 클래스를 통해 **상태(State)**와 분리된 **일회성 부수 효과(Effect)**를 관리할 수 있습니다. 예를 들어, `showSnackbar`나 `MapsTo`와 같은 UI
동작을 상태 변경과 별도로 처리하여, UI와 비즈니스 로직을 명확하게 분리합니다.

* `mviEffects`: UI가 구독하여 부수 효과를 처리하는 스트림입니다.
* `mviEmitEffect`: `mviEffects` 스트림을 통해 부수 효과를 발생시킵니다.
* `mviPerformTaskEither`: `fpdart`의 `TaskEither`를 사용해 비동기 작업의 성공/실패를 함수형 방식으로 깔끔하게 처리합니다.

### 2. TCA (The Composable Architecture) 패턴 지원

`BlocArchTca` 추상 클래스를 통해 **순수 함수형 리듀서(Reducer)** 기반의 아키텍처를 구현할 수 있습니다. 모든 비즈니스 로직이 리듀서에 정의되어, 예측 가능하고 테스트가 용이한 상태 흐름을
만듭니다.

* `tcaReducer`: **액션(Action)**을 처리하고 새로운 상태와 부수 효과를 반환하는 순수 함수입니다.
* `tcaPerformEffect`: `TaskEither`를 사용하여 비동기 부수 효과를 실행하고, 그 결과를 다시 액션으로 시스템에 주입합니다.

### 3. 테스트 자동화 (`BlocTestSuite`)

`BlocTestSuite`는 BLoC/Cubit 테스트를 위한 추상 클래스입니다. `setUp` 및 `tearDown`과 같은 테스트 환경 설정을 자동화하여 테스트 코드를 더 간결하고 재사용 가능하게 만듭니다.

* `initTestSuite()`: 테스트 스위트의 초기화 및 정리 작업을 자동으로 수행합니다.
* `blocArchTest()`: `bloc_test`를 래핑하여 테스트 환경 설정을 간소화합니다.

---

## 📦 설치

`pubspec.yaml` 파일에 다음 의존성을 추가하세요.

```yaml
dependencies:
  bloc_arch_flow: ^1.0.0
  bloc: ^8.1.0
  flutter_bloc: ^8.1.1
  fpdart: ^1.0.0

dev_dependencies:
  bloc_test: ^9.0.0
  flutter_test:
    sdk: flutter
  mockito: ^5.0.0
  mocktail: ^0.3.0
  build_runner: ^2.1.0
  freezed: ^2.0.0
```

## 📖 사용법

### MVI (Model-View-Intent)

```dart
// MVI 패턴을 적용한 BLoC 예제
class CounterMviBloc extends BlocArchMvi<CounterIntentMVI, CounterState, CounterEffect> {
  CounterMviBloc(super.initialState);

  @override
  Future<void> mviHandleIntent(CounterIntentMVI intent, Emitter<CounterState> stateEmitter) {
    // Intent 처리 로직을 여기에 구현
  }
}
```

### TCA (The Composable Architecture)

```dart
// TCA 패턴을 적용한 BLoC 예제
class CounterTcaBloc extends BlocArchTca<CounterActions, CounterState, CounterEnvironment> {
  CounterTcaBloc(super.initialState, super.environment);

  @override
  ReducerEffect<CounterState, CounterActions> tcaReducer(CounterActions action,
      CounterState currentState,
      CounterEnvironment environment,) {
    // Reducer 로직을 여기에 구현
    return (newState: currentState, effect: TaskEither.right(CounterActions.none()));
  }
}
```

### 테스트 스위트

```dart
// BlocTestSuite를 사용한 테스트 코드
class CounterMviBlocTestSuite
    extends BlocTestSuite<CounterMviBloc, CounterState, CounterIntentMVI, CounterEnvironment> {
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
      'incrementAsync 성공 시 count가 증가하고 isLoading이 false가 된다',
      // ... 테스트 로직
    );
  });
}
```