part of 'test_suite.dart';

/// An abstract class for BLoC testing that helps integrate specific
/// architectural patterns like MVI (Model-View-Intent) or TCA
/// (The Composable Architecture) to write structured test code.
///
/// This class explicitly defines the **user's intent (Intent)** or
/// **action (Action)** that the BLoC handles through the [Event] generic,
/// which clarifies the meaning and purpose of each test.
///
/// ### Generic Parameters
///
/// - **`Bloc extends bloc.Bloc<Event, State>`**: The type of the BLoC being tested.
/// - **[State]**: The type of the state managed by the BLoC.
/// - **[Event]**: The type representing the BLoC's events, such as an MVI `Intent`
///   or a TCA `Action`.
/// - **[Environment]**: The container type for the mock objects that
///   the BLoC depends on.
/// ---
/// BLoC 테스트를 위한 추상 클래스로, MVI (Model-View-Intent) 또는
/// TCA (The Composable Architecture)와 같은 특정 아키텍처 패턴을
/// 통합하여 테스트 코드를 작성할 수 있도록 돕습니다.
///
/// 이 클래스는 [Event] 제네릭을 통해 BLoC이 처리하는 **사용자의 의도(Intent)**나
/// **액션(Action)**을 명시적으로 정의하여 테스트의 의미를 명확하게 만듭니다.
///
/// ### 제네릭 타입 (Generic Parameters)
///
/// - **`Bloc extends bloc.Bloc<Event, State>`**: 테스트 대상이 되는 BLoC의 타입입니다.
/// - **[State]**: BLoC이 관리하는 상태의 타입입니다.
/// - **[Event]**: MVI의 `Intent` 또는 TCA의 `Action`과 같이, BLoC의 이벤트를 나타내는 타입입니다.
/// - **[Environment]**: BLoC이 의존하는 모의(Mock) 객체들을 담는 컨테이너 타입입니다.
abstract class BlocTestSuite<Bloc extends bloc.Bloc<Event, State>, State, Event, Environment>
    extends BlocBaseTestSuite<Bloc, State, Environment> {}

/// An abstract class for testing TCA reducers and effects.
///
/// This suite provides a set of utility functions to test the logic of a
/// Bloc that uses a reducer, focusing on the purity of reducers and the
/// predictability of side effects.
///
/// Inherit from this class to create clear and maintainable tests.
///
/// **Usage Example:**
///
/// ```dart
/// class CounterTcaBlocTestSuite extends TcaBlocTestSuite<
///   CounterTcaBloc,
///   CounterState,
///   CounterAction,
///   CounterEnvironment
/// > {
///
///   @override
///   TcaReducer<CounterAction, CounterState> reduceTest(
///     CounterAction action,
///     CounterState currentState,
///     CounterEnvironment environment,
///   ) {
///     // ... Your actual reducer logic here
///     return mockBaseBloc.reducer(action, currentState, environment);
///   }
///
///   @override
///   CounterEnvironment buildMockEnvironment() => MockCounterEnvironment();
///
///   @override
///   CounterState buildInitialState() => const CounterState();
///
///   @override
///   CounterTcaBloc buildMockBaseBloc() => CounterTcaBloc(environment: mockEnvironment);
/// }
/// ```
///
/// ---
///
/// TCA 리듀서 및 효과를 테스트하기 위한 추상 클래스입니다.
///
/// 이 테스트 스위트는 리듀서를 사용하는 Bloc의 로직을 테스트하는 유틸리티 함수들을 제공하며,
/// 리듀서의 순수성과 부수 효과의 예측 가능성에 초점을 맞춥니다.
///
/// 이 클래스를 상속받아 명확하고 유지보수하기 쉬운 테스트를 작성하세요.
///
/// **사용 예시:**
///
/// ```dart
/// class CounterTcaBlocTestSuite extends TcaBlocTestSuite<
///   CounterTcaBloc,
///   CounterState,
///   CounterAction,
///   CounterEnvironment
/// > {
///
///   @override
///   TcaReducer<CounterAction, CounterState> reduceTest(
///     CounterAction action,
///     CounterState currentState,
///     CounterEnvironment environment,
///   ) {
///     // ... 실제 리듀서 로직
///     return mockBaseBloc.reducer(action, currentState, environment);
///   }
///
///   @override
///   CounterEnvironment buildMockEnvironment() => MockCounterEnvironment();
///
///   @override
///   CounterState buildInitialState() => const CounterState();
///
///   @override
///   CounterTcaBloc buildMockBaseBloc() => CounterTcaBloc(environment: mockEnvironment);
/// }
/// ```
abstract class TcaBlocTestSuite<B extends TcaBloc<A, S, E>, A, S, E>
    extends BlocTestSuite<B, S, A, E>
    with TestSuiteUtilityMixin {
  /// A method that defines the core reducer logic for testing.
  /// This must be implemented by the user.
  /// ---
  /// 테스트를 위한 핵심 리듀서 로직을 정의하는 메서드입니다.
  /// 사용자가 직접 구현해야 합니다.
  @protected
  TcaReducer<A, S> reduceTest(A action, S currentState, E environment);

  /// A pure utility to build a side effect with `fpdart`'s [TaskEither].
  ///
  /// This function takes a potentially failing asynchronous [task] and transforms its
  /// outcome (success or failure) into a unified [TcaEffect] that returns an action.
  ///
  /// **Type Parameters:**
  /// - [Failure]: The type of a non-recoverable error.
  /// - [Success]: The type of value returned on a successful task.
  ///
  /// **Parameters:**
  /// - [task]: The raw asynchronous operation.
  /// - [onSuccess]: A callback that transforms the successful result into a new action.
  /// - [onFailure]: A callback that transforms the failure result into a new action.
  ///
  /// **Returns:**
  /// A [TcaEffect] that will yield an action upon execution.
  ///
  /// ---
  /// `fpdart`의 [TaskEither]로 부수 효과를 만드는 순수 유틸리티입니다.
  ///
  /// 이 함수는 잠재적으로 실패할 수 있는 비동기 [task]를 받아, 그 결과(성공 또는 실패)를
  /// 액션을 반환하는 통합된 [TcaEffect]로 변환합니다.
  ///
  /// **타입 매개변수:**
  /// - [Failure]: 복구 불가능한 오류의 타입.
  /// - [Success]: 성공적인 작업 완료 시 반환되는 값의 타입.
  ///
  /// **매개변수:**
  /// - [task]: 비동기 작업.
  /// - [onSuccess]: 성공 결과를 새로운 액션으로 변환하는 콜백.
  /// - [onFailure]: 실패 결과를 새로운 액션으로 변환하는 콜백.
  ///
  /// **반환:**
  /// 실행 시 액션을 생성하는 [TcaEffect].
  @protected
  TcaEffect<A> effectBuilderTest<Failure, Success>({
    required TaskEither<Failure, Success> task,
    required A Function(Success success) onSuccess,
    required A Function(Failure failure) onFailure,
  }) {
    return task.map(onSuccess).mapLeft(onFailure);
  }

  /// Tests the behavior of a side effect.
  ///
  /// This function verifies that a given action and its corresponding effect, when executed,
  /// lead to the expected state change. It's an **end-to-end test** for a single action,
  /// combining reducer logic and side effect execution.
  ///
  /// **Parameters:**
  /// - [description]: A description for the test case.
  /// - [stepAction]: An [ReducerStepAction] object that defines the action, the expected action
  /// from the effect, and whether it's a success, failure, or none.
  /// - [wait]: (Optional) The duration to wait for the asynchronous effect to complete.
  ///
  /// **Example:**
  /// ```dart
  /// // Testing a successful API call
  /// testEffect(
  ///   'API 호출 성공 시 loggedIn 상태로 전환되어야 함',
  ///   stepAction: ReducerStepAction.success(
  ///     action: LoginAction.loginSucceeded(user),
  ///     expected: LoginAction.loginSuccessState(),
  ///   ),
  /// );
  ///
  /// // Testing a network error
  /// testEffect(
  ///   '네트워크 오류 시 error 상태로 전환되어야 함',
  ///   stepAction: ReducerStepAction.failure(
  ///     action: LoginAction.loginFailed(message: 'Network Error'),
  ///     expected: LoginAction.loginErrorState(),
  ///   ),
  /// );
  ///
  /// // Testing a 'none' effect (no follow-up action)
  /// testEffect(
  ///   'UI 액션은 상태 변화만 일으키고 부수 효과는 없어야 함',
  ///   stepAction: ReducerStepAction.none(
  ///     action: LoginAction.usernameChanged('new_username'),
  ///   ),
  /// );
  /// ```
  /// ---
  ///
  /// 부수 효과의 동작을 테스트하는 유틸리티 함수입니다.
  ///
  /// 이 함수는 주어진 액션과 그에 상응하는 효과가 실행되었을 때,
  /// 예상된 상태 변화로 이어지는지 검증합니다. 리듀서 로직과 부수 효과 실행을 결합한
  /// 단일 액션에 대한 **엔드 투 엔드(end-to-end) 테스트**입니다.
  ///
  /// **매개변수:**
  /// - [description]: 테스트 케이스에 대한 설명.
  /// - [stepAction]: 액션, 효과로부터 예상되는 후속 액션, 그리고 성공/실패/없음 여부를
  /// 정의하는 [ReducerStepAction] 객체.
  /// - [wait]: (선택 사항) 비동기 효과가 완료될 때까지 기다릴 시간.
  ///
  /// **사용 예시:**
  /// ```dart
  /// // 성공적인 API 호출 테스트
  /// testEffect(
  ///   'API 호출 성공 시 loggedIn 상태로 전환되어야 함',
  ///   stepAction: ReducerStepAction.success(
  ///     action: LoginAction.loginSucceeded(user),
  ///     expected: LoginAction.loginSuccessState(),
  ///   ),
  /// );
  ///
  /// // 네트워크 오류 테스트
  /// testEffect(
  ///   '네트워크 오류 시 error 상태로 전환되어야 함',
  ///   stepAction: ReducerStepAction.failure(
  ///     action: LoginAction.loginFailed(message: 'Network Error'),
  ///     expected: LoginAction.loginErrorState(),
  ///   ),
  /// );
  ///
  /// // 'none' 효과(후속 액션 없음) 테스트
  /// testEffect(
  ///   'UI 액션은 상태 변화만 일으키고 부수 효과는 없어야 함',
  ///   stepAction: ReducerStepAction.none(
  ///     action: LoginAction.usernameChanged('new_username'),
  ///   ),
  /// );
  /// ```
  @isTest
  void testEffect(
    String description, {
    required ReducerStepAction<A> stepAction,
    FutureOr<void> Function()? setUp,
    Duration? wait,
  }) {
    assert(
      stepAction.expectedAction != null,
      'Error: ActionStep must have an expectedAction.\n(오류: ActionStep에는 expectedAction이 있어야 합니다.)',
    );
    late TcaReducer<A, S> initialResult;

    blocTest(
      description,
      setUp: setUp,
      seed: () {
        // seed 콜백은 build 이후에 실행되므로, mockEnvironment에 안전하게 접근 가능
        initialResult = reduceTest(stepAction.action, buildInitialState(), mockEnvironment);
        return initialResult.newState;
      },
      act: (B bloc) async {
        final Either<A, A> effectResult = await initialResult.effect.run();
        effectResult.fold(
          (A failureAction) => bloc.add(failureAction),
          (A successAction) => bloc.add(successAction),
        );
      },
      wait: wait,
      expect: () {
        // none 액션인 경우, 상태 변화가 없음을 기대
        if (stepAction.isNone) return [];

        // 그 외의 경우, 예상되는 액션에 따른 상태 변화를 기대
        final TcaReducer<A, S> finalResult = reduceTest(
          stepAction.expectedAction,
          initialResult.newState,
          mockEnvironment,
        );
        return [finalResult.newState];
      },
    );
  }

  /// Tests the behavior of a reducer.
  ///
  /// This function verifies that a given action correctly transitions the state
  /// and returns the expected side effect. It is ideal for testing the pure
  /// functional core of your TCA logic.
  ///
  /// **Parameters:**
  /// - [description]: (Required) A description for the test case.
  /// - [initialState]: (Optional) The state before the action is dispatched.
  /// - [environment]: (Optional) The environment (dependencies) passed to the reducer.
  /// - [action]: (Required) The action to be processed by the reducer.
  /// - [expectedState]: (Required) The expected state after the action is processed.
  /// - [expectedEffect]: (Required) The expected side effect returned by the reducer. Use `isA<TcaEffect>()` to check its type.
  ///
  /// **Example:**
  /// ```dart
  /// testReducer(
  ///   'Login succeeded should transition to loggedIn state',
  ///   initialState: const LoginState.loading(),
  ///   action: const LoginAction.loginSucceeded(user),
  ///   expectedState: const LoginState.loggedIn(user),
  ///   expectedEffect: isA<TcaEffect<LoginAction>>(),
  /// );
  /// ```
  ///
  /// ---
  ///
  /// 리듀서의 동작을 테스트하는 유틸리티 함수입니다.
  ///
  /// 이 함수는 주어진 액션이 상태를 올바르게 전환시키고 예상된 부수 효과를 반환하는지 검증합니다.
  /// TCA 로직의 순수한 함수형 코어를 테스트하는 데 이상적입니다.
  ///
  /// **매개변수:**
  /// - [description]: (필수) 테스트 케이스에 대한 설명.
  /// - [initialState]: (선택) 액션이 디스패치되기 전의 상태.
  /// - [environment]: (선택) 리듀서에 전달될 환경(의존성).
  /// - [action]: (필수) 리듀서가 처리할 액션.
  /// - [expectedState]: (필수) 액션 처리 후 예상되는 상태.
  /// - [expectedEffect]: (필수) 리듀서가 반환할 예상 부수 효과. `isA<TcaEffect>()`를 사용하여 타입을 검증합니다.
  ///
  /// **사용 예시:**
  /// ```dart
  /// testReducer(
  ///   '로그인 성공 시 loggedIn 상태로 전환되어야 함',
  ///   initialState: const LoginState.loading(),
  ///   action: const LoginAction.loginSucceeded(user),
  ///   expectedState: const LoginState.loggedIn(user),
  ///   expectedEffect: isA<TcaEffect<LoginAction>>(),
  /// );
  /// ```
  @isTest
  void testReducer(
    String description, {
    S? initialState,
    E? environment,
    required A action,
    required S expectedState,
    required dynamic expectedEffect,
  }) {
    final S currentState = initialState ?? buildInitialState();
    final E mockEnvironment = environment ?? buildMockEnvironment();

    test(description, () {
      final TcaReducer<A, S> result = reduceTest(action, currentState, mockEnvironment);
      expect(result.newState, expectedState);
      expect(result.effect, expectedEffect);
    });
  }

  /// Tests a sequence of multiple actions, state transitions, and effects.
  ///
  /// This function is optimized for testing complex, multi-step user flows
  /// where the state changes and new effects are generated in a specific order.
  /// It provides a clear, declarative way to define each step of the flow.
  ///
  /// **Parameters:**
  /// - [description]: A description for the test case.
  /// - [initialState]: The starting state for the sequence.
  /// - [steps]: A list of [ReducerStep] objects defining each step of the sequence.
  /// - [wait]: (Optional) The duration to wait for the asynchronous effects to complete.
  ///
  /// **Example:**
  /// ```dart
  /// testSequence(
  ///   'Verifies the sequential state changes and effects of the login process',
  ///   initialState: const LoginState.loggedOut(),
  ///   steps: [
  ///     step(
  ///       'Transition to loading state',
  ///       state: const LoginState.loading(),
  ///       effect: isA<TcaEffect<LoginAction>>(),
  ///       stepAction: ActionStep.success(
  ///         action: const LoginAction.loginTapped(),
  ///         expected: const LoginAction.loginSucceeded(user),
  ///       ),
  ///     ),
  ///     step(
  ///       'Transition to loggedIn state after successful login',
  ///       state: const LoginState.loggedIn(user),
  ///       effect: isA<TcaEffect<LoginAction>>(),
  ///       stepAction: ActionStep.none(
  ///         action: const LoginAction.loginSucceeded(user),
  ///       ),
  ///     ),
  ///   ],
  /// );
  /// ```
  ///
  /// ---
  ///
  /// 여러 액션, 상태 변화, 효과의 시퀀스를 한 번에 검증하는 유틸리티입니다.
  ///
  /// 이 함수는 상태가 변화하고 새로운 효과가 특정 순서로 생성되는
  /// 복잡하고 다단계적인 사용자 흐름을 테스트하는 데 최적화되어 있습니다.
  /// 각 흐름 단계를 명확하고 선언적으로 정의할 수 있습니다.
  ///
  /// **매개변수:**
  /// - [description]: 테스트 케이스에 대한 설명.
  /// - [initialState]: 시퀀스의 시작 상태.
  /// - [steps]: 시퀀스의 각 단계를 정의하는 [ReducerStep] 객체 리스트.
  /// - [wait]: (선택 사항) 비동기 효과가 완료될 때까지 기다릴 시간.
  ///
  /// **사용 예시:**
  /// ```dart
  /// testSequence(
  ///   '로그인 과정의 상태 변화와 효과를 순차적으로 검증한다',
  ///   initialState: const LoginState.loggedOut(),
  ///   steps: [
  ///     step(
  ///       '로딩 상태로 전환',
  ///       state: const LoginState.loading(),
  ///       effect: isA<TcaEffect<LoginAction>>(),
  ///       stepAction: ReducerStepAction.success(
  ///         action: const LoginAction.loginTapped(),
  ///         expected: const LoginAction.loginSucceeded(user),
  ///       ),
  ///     ),
  ///     step(
  ///       '로그인 성공 후 최종 상태로 전환',
  ///       state: const LoginState.loggedIn(user),
  ///       effect: isA<TcaEffect<LoginAction>>(),
  ///       stepAction: ReducerStepAction.none(
  ///         action: const LoginAction.loginSucceeded(user),
  ///       ),
  ///     ),
  ///   ],
  /// );
  /// ```
  @isTest
  void testSequence(
    String description, {
    S? initialState,
    required List<ReducerStep<A, S, E>> steps,
    Duration? wait,
  }) {
    final S startState = initialState ?? buildInitialState();

    blocTest(
      description,
      setUp: () => mockBaseBloc,
      seed: () => startState,
      act: (B bloc) async {
        await _runSequenceActions(bloc, steps);
      },
      wait: wait,
      expect: () {
        return _calculateExpectedStates(startState, steps);
      },
    );
  }

  /// A helper function to calculate the sequence of expected states.
  /// This function is purely responsible for returning the list of expected states.
  /// ---
  /// 예상 상태의 시퀀스를 계산하는 헬퍼 함수입니다.
  /// 이 함수는 순수하게 예상 상태 목록을 반환하는 역할만 담당합니다.
  List<S> _calculateExpectedStates(S initialState, List<ReducerStep<A, S, E>> steps) {
    S currentState = initialState;
    final List<S> expectedStates = [];

    for (final ReducerStep<A, S, E> step in steps) {
      // 1단계: 액션에 따른 상태 변화 계산
      final TcaReducer<A, S> result = reduceTest(
        step.stepAction.action,
        currentState,
        mockEnvironment,
      );
      currentState = result.newState;
      expectedStates.add(currentState);

      // 2단계: 부수 효과에 따른 상태 변화 계산
      if (!step.stepAction.isNone) {
        final TcaReducer<A, S> effectResult = reduceTest(
          step.stepAction.expectedAction,
          currentState,
          mockEnvironment,
        );

        currentState = effectResult.newState;
        expectedStates.add(currentState);
      }
    }

    return expectedStates;
  }

  /// A helper function to run the sequence of actions on the BLoC and handle side effects.
  ///
  /// This function encapsulates the 'act' logic of the test.
  /// ---
  /// BLoC에 액션 시퀀스를 실행하고 부수 효과를 처리하는 헬퍼 함수입니다.
  /// 이 함수는 테스트의 'act' 로직을 캡슐화합니다.
  Future<void> _runSequenceActions(B bloc, List<ReducerStep<A, S, E>> steps) async {
    for (final ReducerStep<A, S, E> step in steps) {
      final A action = step.stepAction.action;

      bloc.add(action);
      final TcaReducer<A, S> result = reduceTest(action, bloc.state, mockEnvironment);
      final Either<A, A> effectResult = await result.effect.run();

      effectResult.fold((A failureAction) => bloc.add(failureAction), (A successAction) {
        if (!step.stepAction.isNone) {
          bloc.add(successAction);
        }
      });
    }
  }

  /// A helper function to define a step within a [testSequence].
  ///
  /// It creates a [ReducerStep] object that holds the details for a single
  /// action-state-effect transition.
  ///
  /// **Parameters:**
  /// - [description]: A description for the step.
  /// - [state]: The expected state after the action.
  /// - [effect]: The expected side effect returned by the reducer.
  /// - [stepAction]: An [ReducerStepAction] object that encapsulates the action and its expected outcome.
  ///
  /// **Example:**
  /// ```dart
  /// // An example of a successful login step
  /// step(
  ///   'Login tapped should transition to loading state and trigger API call',
  ///   state: const LoginState.loading(),
  ///   effect: isA<TcaEffect<LoginAction>>(),
  ///   stepAction: ReducerStepAction.success(
  ///     action: const LoginAction.loginTapped(),
  ///     expected: const LoginAction.loginSucceeded(user),
  ///   ),
  /// );
  /// ```
  ///
  /// ---
  ///
  /// [testSequence] 내에서 각 단계를 정의하는 헬퍼 함수입니다.
  ///
  /// 단일 액션-상태-효과 전환에 대한 세부 정보를 담는 [ReducerStep] 객체를 생성합니다.
  ///
  /// **매개변수:**
  /// - [description]: 단계에 대한 설명.
  /// - [state]: 액션 처리 후 예상되는 상태.
  /// - [effect]: 리듀서가 반환할 예상 부수 효과.
  /// - [stepAction]: 액션과 예상 결과를 캡슐화하는 [ReducerStepAction] 객체.
  ///
  /// **사용 예시:**
  /// ```dart
  /// // 성공적인 로그인 단계의 예시
  /// step(
  ///   '로그인 버튼 탭은 로딩 상태로 전환하고 API 호출을 유발해야 함',
  ///   state: const LoginState.loading(),
  ///   effect: isA<TcaEffect<LoginAction>>(),
  ///   stepAction: ReducerStepAction.success(
  ///     action: const LoginAction.loginTapped(),
  ///     expected: const LoginAction.loginSucceeded(user),
  ///   ),
  /// );
  /// ```
  ReducerStep<A, S, E> step(
    String description, {
    required S state,
    required dynamic effect,
    required ReducerStepAction<A> stepAction,
  }) {
    return ReducerStep(
      description: description,
      state: state,
      effect: effect,
      stepAction: stepAction,
    );
  }
}

/// A class that represents a single step in a reducer sequence test.
///
/// It encapsulates a description, the expected resulting state, the expected effect,
/// and an [ReducerStepAction] object that defines the action and its expected outcome.
///
/// **Example:**
/// ```dart
/// // A ReducerStep for a login sequence
/// final loginStep = ReducerStep(
///   description: 'Login transition',
///   state: const LoginState.loggedIn(user),
///   effect: isA<TcaEffect<LoginAction>>(),
///   actionStep: ReducerStepAction.success(
///     action: const LoginAction.loginSucceeded(user),
///     expected: const LoginAction.mainScreenReady(),
///   ),
/// );
/// ```
///
/// ---
///
/// 리듀서 시퀀스 테스트의 단일 단계를 나타내는 클래스입니다.
///
/// 설명, 예상 결과 상태, 예상 효과, 그리고 액션과 그 예상 결과를 정의하는 [ReducerStepAction] 객체를 캡슐화합니다.
///
/// **사용 예시:**
/// ```dart
/// // 로그인 시퀀스를 위한 ReducerStep
/// final loginStep = ReducerStep(
///   description: '로그인 전환',
///   state: const LoginState.loggedIn(user),
///   effect: isA<TcaEffect<LoginAction>>(),
///   actionStep: ReducerStepAction.success(
///     action: const LoginAction.loginSucceeded(user),
///     expected: const LoginAction.mainScreenReady(),
///   ),
/// );
/// ```
final class ReducerStep<A, S, E> {
  final String description;
  final S state;
  final dynamic effect;
  final ReducerStepAction<A> stepAction;

  ReducerStep({
    required this.description,
    required this.state,
    required this.effect,
    required this.stepAction,
  });
}

/// A class that encapsulates an action and its expected outcome.
///
/// It's designed to provide a clear and declarative way to define what an action
/// should result in, whether it's a success, a failure, or a 'none' action (no follow-up).
///
/// - [action]: The action being dispatched.
/// - [expectedAction]: The action that is expected to be returned from a side effect.
/// - [isFailure]: A flag indicating if the action is expected to result in a failure.
/// - [isNone]: A flag indicating if the action is expected to result in no side effect.
///
/// The factory constructors simplify creating these steps for different scenarios:
/// - [ActionStep.success]: For actions that lead to a successful follow-up action.
/// - [ActionStep.failure]: For actions that lead to a failure follow-up action.
/// - [ActionStep.none]: For actions that have no side effects (e.g., UI actions).
///
/// ---
///
/// 액션과 그 예상 결과를 캡슐화하는 클래스입니다.
///
/// 액션이 성공, 실패 또는 '없음' (후속 조치 없음) 중 어떤 결과를 낳을지
/// 명확하고 선언적으로 정의하기 위해 설계되었습니다.
///
/// - [action]: 디스패치되는 액션.
/// - [expectedAction]: 부수 효과로부터 반환될 것으로 예상되는 액션.
/// - [isFailure]: 액션이 실패를 초래할 것으로 예상되는지 나타내는 플래그.
/// - [isNone]: 액션이 부수 효과를 초래하지 않을 것으로 예상되는지 나타내는 플래그.
///
/// 다음 팩토리 생성자들은 다양한 시나리오에 대한 단계를 쉽게 생성할 수 있도록 돕습니다:
/// - [ActionStep.success]: 성공적인 후속 액션으로 이어지는 액션용.
/// - [ActionStep.failure]: 실패 후속 액션으로 이어지는 액션용.
/// - [ActionStep.none]: 부수 효과가 없는 액션(예: UI 액션)용.
final class ReducerStepAction<A> {
  final A action;
  final A expectedAction;
  final bool isFailure;
  final bool isNone;

  const ReducerStepAction({
    required this.action,
    required this.expectedAction,
    this.isFailure = false,
    this.isNone = false,
  });

  // 성공
  factory ReducerStepAction.success({required A action, required A expected}) {
    return ReducerStepAction(action: action, expectedAction: expected);
  }

  // 실패
  factory ReducerStepAction.failure({required A action, required A expected}) {
    return ReducerStepAction(action: action, expectedAction: expected, isFailure: true);
  }

  // 없음
  factory ReducerStepAction.pure({required A action}) {
    return ReducerStepAction(action: action, expectedAction: action, isNone: true);
  }
}