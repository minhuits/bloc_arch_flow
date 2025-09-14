[한국어](CHANGELOG-ko.md) | [English](CHANGELOG.md)

---

## 1.1.0

### Feat

* **Introduce a new testing framework:** Added `BlocTestSuite` and dedicated test suite base classes (
  `MviCubitTestSuite`, `TcaBlocTestSuite`) to provide a more structured and declarative way of writing tests. This
  improves test maintainability and readability.
* **Add test utility mixin:** Introduced `TestSuiteUtilityMixin` with helper methods like `whenSuccessTask` and
  `whenFailureTask` to simplify mocking asynchronous operations in tests.
* **Implement specialized test functions:** Added pattern-specific test functions (`testCubitGroup`, `testSideEffect`,
  `testPureState` for MVI; `testReducer` for TCA) to clearly define the purpose of each test case and enhance test
  expressiveness.

### Refactor

* **Improve core architecture:** Refactored the internal structure of `BlocArchMvi` and `BlocArchTca` to better align
  with the new testing framework and upcoming 2.0.0 release changes.
* **Enhance type safety:** Applied more specific generic constraints to test suite classes to provide compile-time
  safety and prevent common type errors.
* **Deprecate old APIs:** Marked deprecated classes and methods with clear messages to guide users toward the new,
  improved APIs. This prepares for a breaking change in the next major release (2.0.0).

### Chore

* **Update dependencies:** Ensured compatibility with the latest versions of the `bloc` and `fpdart` packages.
* **Add documentation:** Improved documentation and code comments for all new classes and methods.

---

## 1.0.3

### Style

Refactored Dart code formatting for consistency.

### Docs

Fixed incorrect documentation.

## 1.0.2

### Style

- Updated Dart code formatting to ensure consistency across the project.

## 1.0.1

### Docs

- Updated documentation links.

## 1.0.0

- Initial release.
- Added MVI and TCA BLoC implementations.
- Included comprehensive test suites.