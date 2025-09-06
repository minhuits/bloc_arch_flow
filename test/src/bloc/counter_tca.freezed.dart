// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_tca.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CounterActions {
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is CounterActions);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterActions()';
  }
}

/// @nodoc
class $CounterActionsCopyWith<$Res> {
  $CounterActionsCopyWith(CounterActions _, $Res Function(CounterActions) __);
}

/// Adds pattern-matching-related methods to [CounterActions].
extension CounterActionsPatterns on CounterActions {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncrementTCA value)? increment,

    TResult

  Function

  (

  DecrementTCA

  value

  )

  ?

  decrement

  ,

    TResult Function(IncrementAsyncTCA value)? incrementAsync,

    TResult

  Function

  (

  ResetTCA

  value

  )

  ?

  reset

  ,

    TResult Function(AsyncIncrementSuccess value)? success,

    TResult

  Function

  (

  AsyncIncrementFailed

  value

  )

  ?

  failed

  ,

    TResult Function(NoneTCA value)? none,

    required

  TResult

  orElse

  (

  )

  ,
}) {
final _that = this;
switch (_that) {
case IncrementTCA() when increment != null:
return increment(_that);
case DecrementTCA() when decrement != null:
return decrement(_that);
case IncrementAsyncTCA() when incrementAsync != null:
return incrementAsync(_that);
case ResetTCA() when reset != null:
return reset(_that);
case AsyncIncrementSuccess() when success != null:
return success(_that);
case AsyncIncrementFailed() when failed != null:
return failed(_that);
case NoneTCA() when none != null:
return none(_that);
case _:
return orElse();
}
}

/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncrementTCA value) increment,
    required TResult Function(DecrementTCA value) decrement,
    required TResult Function(IncrementAsyncTCA value) incrementAsync,
    required TResult Function(ResetTCA value) reset,
    required TResult Function(AsyncIncrementSuccess value) success,
    required TResult Function(AsyncIncrementFailed value) failed,
    required TResult Function(NoneTCA value) none,
  }) {
    final _that = this;
    switch (_that) {
      case IncrementTCA():
        return increment(_that);
      case DecrementTCA():
        return decrement(_that);
      case IncrementAsyncTCA():
        return incrementAsync(_that);
      case ResetTCA():
        return reset(_that);
      case AsyncIncrementSuccess():
        return success(_that);
      case AsyncIncrementFailed():
        return failed(_that);
      case NoneTCA():
        return none(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(IncrementTCA value)? increment,
    TResult? Function(DecrementTCA value)? decrement,
    TResult? Function(IncrementAsyncTCA value)? incrementAsync,
    TResult? Function(ResetTCA value)? reset,
    TResult? Function(AsyncIncrementSuccess value)? success,
    TResult? Function(AsyncIncrementFailed value)? failed,
    TResult? Function(NoneTCA value)? none,
  }) {
    final _that = this;
    switch (_that) {
      case IncrementTCA() when increment != null:
        return increment(_that);
      case DecrementTCA() when decrement != null:
        return decrement(_that);
      case IncrementAsyncTCA() when incrementAsync != null:
        return incrementAsync(_that);
      case ResetTCA() when reset != null:
        return reset(_that);
      case AsyncIncrementSuccess() when success != null:
        return success(_that);
      case AsyncIncrementFailed() when failed != null:
        return failed(_that);
      case NoneTCA() when none != null:
        return none(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? increment,
    TResult Function()? decrement,
    TResult Function()? incrementAsync,
    TResult Function()? reset,
    TResult Function(int newCount)? success,
    TResult Function(String error)? failed,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case IncrementTCA() when increment != null:
        return increment();
      case DecrementTCA() when decrement != null:
        return decrement();
      case IncrementAsyncTCA() when incrementAsync != null:
        return incrementAsync();
      case ResetTCA() when reset != null:
        return reset();
      case AsyncIncrementSuccess() when success != null:
        return success(_that.newCount);
      case AsyncIncrementFailed() when failed != null:
        return failed(_that.error);
      case NoneTCA() when none != null:
        return none();
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
TResult when<TResult extends Object?>({
required TResult Function() increment,
required TResult Function() decrement,
required TResult Function() incrementAsync,
required TResult Function() reset,
required TResult Function(int newCount) success,
required TResult Function(String error) failed,
required TResult Function() none,
}) {
final _that = this;
switch (_that) {
case IncrementTCA():
return increment();
case DecrementTCA():
return decrement();
case IncrementAsyncTCA():
return incrementAsync();
case ResetTCA():
return reset();
case AsyncIncrementSuccess():
return success(_that.newCount);
case AsyncIncrementFailed():
return failed(_that.error);
case NoneTCA():
return none();
}
}

/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? increment,
    TResult? Function()? decrement,
    TResult? Function()? incrementAsync,
    TResult? Function()? reset,
    TResult? Function(int newCount)? success,
    TResult? Function(String error)? failed,
    TResult? Function()? none,
  }) {
    final _that = this;
    switch (_that) {
      case IncrementTCA() when increment != null:
        return increment();
      case DecrementTCA() when decrement != null:
        return decrement();
      case IncrementAsyncTCA() when incrementAsync != null:
        return incrementAsync();
      case ResetTCA() when reset != null:
        return reset();
      case AsyncIncrementSuccess() when success != null:
        return success(_that.newCount);
      case AsyncIncrementFailed() when failed != null:
        return failed(_that.error);
      case NoneTCA() when none != null:
        return none();
      case _:
        return null;
    }
  }
}

/// @nodoc

class IncrementTCA implements CounterActions {
  const IncrementTCA();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is IncrementTCA);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterActions.increment()';
  }
}

/// @nodoc

class DecrementTCA implements CounterActions {
  const DecrementTCA();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is DecrementTCA);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterActions.decrement()';
  }
}

/// @nodoc

class IncrementAsyncTCA implements CounterActions {
  const IncrementAsyncTCA();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is IncrementAsyncTCA);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterActions.incrementAsync()';
  }
}

/// @nodoc

class ResetTCA implements CounterActions {
  const ResetTCA();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is ResetTCA);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterActions.reset()';
  }
}

/// @nodoc

class AsyncIncrementSuccess implements CounterActions {
  const AsyncIncrementSuccess(this.newCount);

  final int newCount;

  /// Create a copy of CounterActions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AsyncIncrementSuccessCopyWith<AsyncIncrementSuccess> get copyWith =>
      _$AsyncIncrementSuccessCopyWithImpl<AsyncIncrementSuccess>(this, _$identity);

  @override
bool operator ==(Object other) {
return identical(this, other) ||
(other.runtimeType == runtimeType &&
other is AsyncIncrementSuccess &&
(identical(other.newCount, newCount) || other.newCount == newCount));
}

  @override
  int get hashCode => Object.hash(runtimeType, newCount);

  @override
String toString() {
return 'CounterActions.success(newCount: $newCount)';
}
}

/// @nodoc
abstract mixin class $AsyncIncrementSuccessCopyWith<$Res> implements $CounterActionsCopyWith<$Res> {
  factory $AsyncIncrementSuccessCopyWith(
    AsyncIncrementSuccess value,
    $Res Function(AsyncIncrementSuccess) _then,
  ) = _$AsyncIncrementSuccessCopyWithImpl;
  @useResult
  $Res call({int newCount});
}

/// @nodoc
class _$AsyncIncrementSuccessCopyWithImpl<$Res> implements $AsyncIncrementSuccessCopyWith<$Res> {
  _$AsyncIncrementSuccessCopyWithImpl(this._self, this._then);

  final AsyncIncrementSuccess _self;
  final $Res Function(AsyncIncrementSuccess) _then;

  /// Create a copy of CounterActions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline')
$Res call({Object? newCount = null}) {
return _then(
AsyncIncrementSuccess(
null == newCount
? _self.newCount
    : newCount // ignore: cast_nullable_to_non_nullable
as int,
),
);
}
}

/// @nodoc

class AsyncIncrementFailed implements CounterActions {
  const AsyncIncrementFailed(this.error);

  final String error;

  /// Create a copy of CounterActions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AsyncIncrementFailedCopyWith<AsyncIncrementFailed> get copyWith =>
      _$AsyncIncrementFailedCopyWithImpl<AsyncIncrementFailed>(this, _$identity);

  @override
bool operator ==(Object other) {
return identical(this, other) ||
(other.runtimeType == runtimeType &&
other is AsyncIncrementFailed &&
(identical(other.error, error) || other.error == error));
}

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
String toString() {
return 'CounterActions.failed(error: $error)';
}
}

/// @nodoc
abstract mixin class $AsyncIncrementFailedCopyWith<$Res> implements $CounterActionsCopyWith<$Res> {
  factory $AsyncIncrementFailedCopyWith(
    AsyncIncrementFailed value,
    $Res Function(AsyncIncrementFailed) _then,
  ) = _$AsyncIncrementFailedCopyWithImpl;
  @useResult
  $Res call({String error});
}

/// @nodoc
class _$AsyncIncrementFailedCopyWithImpl<$Res> implements $AsyncIncrementFailedCopyWith<$Res> {
  _$AsyncIncrementFailedCopyWithImpl(this._self, this._then);

  final AsyncIncrementFailed _self;
  final $Res Function(AsyncIncrementFailed) _then;

  /// Create a copy of CounterActions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline')
$Res call({Object? error = null}) {
return _then(
AsyncIncrementFailed(
null == error
? _self.error
    : error // ignore: cast_nullable_to_non_nullable
as String,
),
);
}
}

/// @nodoc

class NoneTCA implements CounterActions {
  const NoneTCA();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is NoneTCA);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterActions.none()';
  }
}