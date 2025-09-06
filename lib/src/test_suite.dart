import 'dart:async' show FutureOr;

import 'package:bloc/bloc.dart' show BlocBase, Bloc, Cubit;
import 'package:bloc_test/bloc_test.dart' show blocTest;
import 'package:flutter_test/flutter_test.dart' show setUp, tearDown;
import 'package:meta/meta.dart' show isTest;
import 'package:mocktail/mocktail.dart' show registerFallbackValue, reset;

part 'test_suite_bloc.dart';
part 'test_suite_cubit.dart';

/// **Bloc Arch Flow Pattern**
///
/// An approach provided by the `bloc_arch_flow` package. It offers a predictable state flow
/// and structured business logic by adopting either MVI (Model-View-Intent) or
/// TCA (The Composable Architecture) architectural principles alongside Bloc.
///
/// The [BlocTestSuiteBase] class is an abstract base class for testing a Bloc or Cubit
/// that follows the **Bloc Arch Flow pattern**. Inherit from this class to define the setup
/// for the specific Bloc/Cubit you want to test.
///
/// - [BlocType]: The type of the Bloc or Cubit to be tested (e.g., `CounterMviBloc`, `CounterTcaBloc`).
/// - [State]: The state type of the Bloc or Cubit (e.g., `CounterState`).
/// - [EnvironmentMock]: The mock type for the Bloc or Cubit's Environment (dependencies) (e.g., `MockCounterEnvironment`).
/// ---
/// **Bloc Arch Flow 패턴**
///
/// 이 `bloc_arch_flow` 패키지에서 제공하는 접근 방식으로, Bloc과 함께 MVI (Model-View-Intent)
/// 또는 TCA (The Composable Architecture) 아키텍처 원칙 중 하나를 선택하여,
/// 예측 가능한 상태 흐름과 구조화된 비즈니스 로직을 제공하는 접근 방식입니다.
///
/// [BlocTestSuiteBase] 클래스는 **Bloc Arch Flow 패턴**을 따르는 Bloc 또는 Cubit을 테스트하기 위한 추상 기본 클래스입니다.
/// [BlocTestSuiteBase] 클래스를 상속받아 테스트할 특정 Bloc/Cubit에 대한 설정을 정의합니다.
///
/// - [BlocType]: 테스트할 Bloc 또는 Cubit의 타입 (예: `CounterMviBloc`, `CounterTcaBloc`).
/// - [State]: Bloc 또는 Cubit의 상태 타입 (예: `CounterState`).
/// - [EnvironmentMock]: Bloc 또는 Cubit의 Environment(의존성) Mock 타입 (예: `MockCounterEnvironment`).
abstract interface class BlocTestSuiteBase<
  BlocType extends BlocBase<State>,
  State,
  EnvironmentMock
> {
  /// The Mock Environment instance that will be initialized before each test case.
  /// ---
  /// 테스트 전 각 테스트 케이스에 대해 초기화될 Mock Environment 인스턴스입니다.
  late EnvironmentMock mockEnvironment;

  /// Creates and returns the Mock Environment instance.
  /// This must be implemented by the user for each test suite.
  /// ---
  /// Mock Environment 인스턴스를 생성하고 반환합니다.
  /// 사용자가 각 테스트 스위트에 맞게 구현해야 합니다.
  EnvironmentMock createMockEnvironment();

  /// Returns the initial state of the Bloc or Cubit to be tested.
  /// This may be needed for `bloc_test`'s [registerFallbackValue].
  /// ---
  /// 테스트할 Bloc 또는 Cubit의 초기 상태를 반환합니다.
  /// `bloc_test`의 [registerFallbackValue]를 위해 필요할 수 있습니다.
  State getInitialState();

  /// Builds and returns the Bloc or Cubit instance to be tested.
  /// This method is used in the `build` callback of `blocTest`.
  /// ---
  /// 테스트할 Bloc 또는 Cubit 인스턴스를 빌드하여 반환합니다.
  /// 이 메서드는 `blocTest`의 `build` 콜백에서 사용됩니다.
  BlocType buildBloc();

  /// Initializes this test group.
  /// Call this at the beginning of a `group` function to set up the `setUp` and `tearDown` logic.
  /// ---
  /// 이 테스트 그룹을 초기화합니다.
  /// `group` 함수의 시작 부분에서 호출하여 `setUp` 및 `tearDown` 로직을 설정합니다.
  void initTestSuite() {
    setUp(() {
      // Mocktail의 `any()` 매처가 예상치 못한 타입의 인자를 받을 때를 대비하여 fallback을 등록합니다.
      // 특히, 상태 객체나 이벤트/액션 객체를 Mock 함수에 전달할 때 유용합니다.
      mockEnvironment = createMockEnvironment();

      // 만약 이벤트/액션이 `any()`로 전달될 수 있다면, 해당 타입에 대한 fallback도 등록해야 합니다.
      // 예시: registerFallbackValue(const CounterIntent.increment());
      registerFallbackValue(getInitialState());
    });

    tearDown(() {
      // 각 테스트 후 Mock 상태를 초기화하여 테스트 간 독립성을 보장합니다.
      reset(mockEnvironment);
    });
  }

  /// A wrapped `blocTest` function for a Bloc or Cubit that follows the Bloc Arch Flow pattern.
  /// This function provides `build: () => buildBloc()` as a default, which simplifies test code.
  ///
  /// You can explicitly provide a `build` callback to perform additional setup, such as
  /// mocking configurations, before the Bloc/Cubit under test is built.
  ///
  /// - [description] A description of the test case.
  /// - [build] (Optional) A function that returns the Bloc/Cubit instance to be tested.
  /// By default, calls `buildBloc()`.
  /// - [setUp] (Optional) Additional setup before each test case.
  /// - [seed] (Optional) The initial state of the Bloc/Cubit.
  /// - [act] (Optional) A function that performs an action on the Bloc/Cubit.
  /// - [wait] (Optional) The duration to wait between `act` and `expect`.
  /// - [skip] (Optional) The number of tests to skip.
  /// - [expect] (Optional) A list of expected state changes or a Matcher.
  /// - [verify] (Optional) Additional verification logic.
  /// - [errors] (Optional) A list of expected errors or a Matcher.
  /// - [tearDown] (Optional) Cleanup after each test case.
  /// - [tags] (Optional) Test tags.
  ///
  /// ---
  /// Bloc Arch Flow 패턴을 따르는 Bloc 또는 Cubit을 위한 래핑된 `blocTest` 함수입니다.
  /// 이 함수는 `build: () => buildBloc()`를 기본값으로 제공하여 테스트 코드의 간결성을 높입니다.
  ///
  /// `build` 콜백을 명시적으로 제공하여 테스트 대상 Bloc/Cubit이 빌드되기 전에
  /// Mocking 설정과 같은 추가적인 준비 작업을 수행할 수 있습니다.
  ///
  /// - [description] 테스트 케이스에 대한 설명.
  /// - [build] (선택 사항) 테스트할 Bloc/Cubit 인스턴스를 반환하는 함수.
  ///           기본적으로 `buildBloc()`을 호출합니다.
  /// - [setUp] (선택 사항) 각 테스트 케이스 실행 전 추가 설정.
  /// - [seed] (선택 사항) Bloc/Cubit의 초기 상태.
  /// - [act] (선택 사항) Bloc/Cubit에 액션을 실행하는 함수.
  /// - [wait] (선택 사항) `act`와 `expect` 사이에 기다릴 시간.
  /// - [skip] (선택 사항) 건너뛸 테스트 수.
  /// - [expect] (선택 사항) 예상되는 상태 변화 목록 또는 Matcher.
  /// - [verify] (선택 사항) 추가적인 검증 로직.
  /// - [errors] (선택 사항) 예상되는 오류 목록 또는 Matcher.
  /// - [tearDown] (선택 사항) 각 테스트 케이스 실행 후 정리 작업.
  /// - [tags] (선택 사항) 테스트 태그.
  @isTest
  void blocArchTest(
    String description, {
    BlocType Function()? build,
    FutureOr<void> Function()? setUp,
    State Function()? seed,
    dynamic Function(BlocType bloc)? act,
    Duration? wait,
    int skip = 0,
    dynamic Function()? expect,
    dynamic Function(BlocType bloc)? verify,
    dynamic Function()? errors,
    FutureOr<void> Function()? tearDown,
    dynamic tags,
  }) {
    blocTest(
      description,
      build: build ?? () => buildBloc(),
      setUp: setUp,
      seed: seed,
      act: act,
      wait: wait,
      skip: skip,
      expect: expect,
      verify: verify,
      errors: errors,
      tearDown: tearDown,
      tags: tags,
    );
  }
}