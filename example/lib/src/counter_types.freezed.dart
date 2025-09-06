// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CounterActions implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterActions'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is CounterActions);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
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

    TResult Function(DecrementTCA value)? decrement,

    TResult Function(IncrementAsyncTCA value)? incrementAsync,

    TResult Function(ResetTCA value)? reset,

    TResult Function(AsyncIncrementSuccess value)? success,

    TResult Function(AsyncIncrementFailed value)? failed,

    TResult Function(NoneTCA value)? none,

    required TResult orElse(),
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

class IncrementTCA with DiagnosticableTreeMixin implements CounterActions {
  const IncrementTCA();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterActions.increment'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is IncrementTCA);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterActions.increment()';
  }
}

/// @nodoc

class DecrementTCA with DiagnosticableTreeMixin implements CounterActions {
  const DecrementTCA();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterActions.decrement'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is DecrementTCA);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterActions.decrement()';
  }
}

/// @nodoc

class IncrementAsyncTCA with DiagnosticableTreeMixin implements CounterActions {
  const IncrementAsyncTCA();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterActions.incrementAsync'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is IncrementAsyncTCA);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterActions.incrementAsync()';
  }
}

/// @nodoc

class ResetTCA with DiagnosticableTreeMixin implements CounterActions {
  const ResetTCA();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterActions.reset'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is ResetTCA);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterActions.reset()';
  }
}

/// @nodoc

class AsyncIncrementSuccess with DiagnosticableTreeMixin implements CounterActions {
  const AsyncIncrementSuccess(this.newCount);

  final int newCount;

  /// Create a copy of CounterActions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AsyncIncrementSuccessCopyWith<AsyncIncrementSuccess> get copyWith =>
      _$AsyncIncrementSuccessCopyWithImpl<AsyncIncrementSuccess>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterActions.success'))
      ..add(DiagnosticsProperty('newCount', newCount));
  }

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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
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

class AsyncIncrementFailed with DiagnosticableTreeMixin implements CounterActions {
  const AsyncIncrementFailed(this.error);

  final String error;

  /// Create a copy of CounterActions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AsyncIncrementFailedCopyWith<AsyncIncrementFailed> get copyWith =>
      _$AsyncIncrementFailedCopyWithImpl<AsyncIncrementFailed>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterActions.failed'))
      ..add(DiagnosticsProperty('error', error));
  }

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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
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

class NoneTCA with DiagnosticableTreeMixin implements CounterActions {
  const NoneTCA();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterActions.none'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is NoneTCA);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterActions.none()';
  }
}

/// @nodoc
mixin _$CounterIntent implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterIntent'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is CounterIntent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterIntent()';
  }
}

/// @nodoc
class $CounterIntentCopyWith<$Res> {
  $CounterIntentCopyWith(CounterIntent _, $Res Function(CounterIntent) __);
}

/// Adds pattern-matching-related methods to [CounterIntent].
extension CounterIntentPatterns on CounterIntent {
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
    TResult Function(Increment value)? increment,
    TResult Function(Decrement value)? decrement,
    TResult Function(IncrementAsync value)? incrementAsync,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case Increment() when increment != null:
        return increment(_that);
      case Decrement() when decrement != null:
        return decrement(_that);
      case IncrementAsync() when incrementAsync != null:
        return incrementAsync(_that);
      case Reset() when reset != null:
        return reset(_that);
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
    required TResult Function(Increment value) increment,
    required TResult Function(Decrement value) decrement,
    required TResult Function(IncrementAsync value) incrementAsync,
    required TResult Function(Reset value) reset,
  }) {
    final _that = this;
    switch (_that) {
      case Increment():
        return increment(_that);
      case Decrement():
        return decrement(_that);
      case IncrementAsync():
        return incrementAsync(_that);
      case Reset():
        return reset(_that);
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
    TResult? Function(Increment value)? increment,
    TResult? Function(Decrement value)? decrement,
    TResult? Function(IncrementAsync value)? incrementAsync,
    TResult? Function(Reset value)? reset,
  }) {
    final _that = this;
    switch (_that) {
      case Increment() when increment != null:
        return increment(_that);
      case Decrement() when decrement != null:
        return decrement(_that);
      case IncrementAsync() when incrementAsync != null:
        return incrementAsync(_that);
      case Reset() when reset != null:
        return reset(_that);
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
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case Increment() when increment != null:
        return increment();
      case Decrement() when decrement != null:
        return decrement();
      case IncrementAsync() when incrementAsync != null:
        return incrementAsync();
      case Reset() when reset != null:
        return reset();
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
  }) {
    final _that = this;
    switch (_that) {
      case Increment():
        return increment();
      case Decrement():
        return decrement();
      case IncrementAsync():
        return incrementAsync();
      case Reset():
        return reset();
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
  }) {
    final _that = this;
    switch (_that) {
      case Increment() when increment != null:
        return increment();
      case Decrement() when decrement != null:
        return decrement();
      case IncrementAsync() when incrementAsync != null:
        return incrementAsync();
      case Reset() when reset != null:
        return reset();
      case _:
        return null;
    }
  }
}

/// @nodoc

class Increment with DiagnosticableTreeMixin implements CounterIntent {
  const Increment();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterIntent.increment'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is Increment);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterIntent.increment()';
  }
}

/// @nodoc

class Decrement with DiagnosticableTreeMixin implements CounterIntent {
  const Decrement();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterIntent.decrement'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is Decrement);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterIntent.decrement()';
  }
}

/// @nodoc

class IncrementAsync with DiagnosticableTreeMixin implements CounterIntent {
  const IncrementAsync();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterIntent.incrementAsync'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is IncrementAsync);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterIntent.incrementAsync()';
  }
}

/// @nodoc

class Reset with DiagnosticableTreeMixin implements CounterIntent {
  const Reset();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterIntent.reset'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is Reset);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterIntent.reset()';
  }
}

/// @nodoc
mixin _$CounterEffect implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'CounterEffect'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is CounterEffect);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterEffect()';
  }
}

/// @nodoc
class $CounterEffectCopyWith<$Res> {
  $CounterEffectCopyWith(CounterEffect _, $Res Function(CounterEffect) __);
}

/// Adds pattern-matching-related methods to [CounterEffect].
extension CounterEffectPatterns on CounterEffect {
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
    TResult Function(ShowToast value)? showToast,
    TResult Function(NavigateTo value)? navigateTo,
    TResult Function(PlaySound value)? playSound,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ShowToast() when showToast != null:
        return showToast(_that);
      case NavigateTo() when navigateTo != null:
        return navigateTo(_that);
      case PlaySound() when playSound != null:
        return playSound(_that);
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
    required TResult Function(ShowToast value) showToast,
    required TResult Function(NavigateTo value) navigateTo,
    required TResult Function(PlaySound value) playSound,
  }) {
    final _that = this;
    switch (_that) {
      case ShowToast():
        return showToast(_that);
      case NavigateTo():
        return navigateTo(_that);
      case PlaySound():
        return playSound(_that);
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
    TResult? Function(ShowToast value)? showToast,
    TResult? Function(NavigateTo value)? navigateTo,
    TResult? Function(PlaySound value)? playSound,
  }) {
    final _that = this;
    switch (_that) {
      case ShowToast() when showToast != null:
        return showToast(_that);
      case NavigateTo() when navigateTo != null:
        return navigateTo(_that);
      case PlaySound() when playSound != null:
        return playSound(_that);
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
    TResult Function(String message)? showToast,
    TResult Function(String route)? navigateTo,
    TResult Function(String soundAsset)? playSound,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ShowToast() when showToast != null:
        return showToast(_that.message);
      case NavigateTo() when navigateTo != null:
        return navigateTo(_that.route);
      case PlaySound() when playSound != null:
        return playSound(_that.soundAsset);
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
    required TResult Function(String message) showToast,
    required TResult Function(String route) navigateTo,
    required TResult Function(String soundAsset) playSound,
  }) {
    final _that = this;
    switch (_that) {
      case ShowToast():
        return showToast(_that.message);
      case NavigateTo():
        return navigateTo(_that.route);
      case PlaySound():
        return playSound(_that.soundAsset);
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
    TResult? Function(String message)? showToast,
    TResult? Function(String route)? navigateTo,
    TResult? Function(String soundAsset)? playSound,
  }) {
    final _that = this;
    switch (_that) {
      case ShowToast() when showToast != null:
        return showToast(_that.message);
      case NavigateTo() when navigateTo != null:
        return navigateTo(_that.route);
      case PlaySound() when playSound != null:
        return playSound(_that.soundAsset);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ShowToast with DiagnosticableTreeMixin implements CounterEffect {
  const ShowToast(this.message);

  final String message;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShowToastCopyWith<ShowToast> get copyWith =>
      _$ShowToastCopyWithImpl<ShowToast>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterEffect.showToast'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShowToast &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterEffect.showToast(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ShowToastCopyWith<$Res> implements $CounterEffectCopyWith<$Res> {
  factory $ShowToastCopyWith(ShowToast value, $Res Function(ShowToast) _then) =
      _$ShowToastCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ShowToastCopyWithImpl<$Res> implements $ShowToastCopyWith<$Res> {
  _$ShowToastCopyWithImpl(this._self, this._then);

  final ShowToast _self;
  final $Res Function(ShowToast) _then;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? message = null}) {
    return _then(
      ShowToast(
        null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class NavigateTo with DiagnosticableTreeMixin implements CounterEffect {
  const NavigateTo(this.route);

  final String route;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavigateToCopyWith<NavigateTo> get copyWith =>
      _$NavigateToCopyWithImpl<NavigateTo>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterEffect.navigateTo'))
      ..add(DiagnosticsProperty('route', route));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NavigateTo &&
            (identical(other.route, route) || other.route == route));
  }

  @override
  int get hashCode => Object.hash(runtimeType, route);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterEffect.navigateTo(route: $route)';
  }
}

/// @nodoc
abstract mixin class $NavigateToCopyWith<$Res> implements $CounterEffectCopyWith<$Res> {
  factory $NavigateToCopyWith(NavigateTo value, $Res Function(NavigateTo) _then) =
      _$NavigateToCopyWithImpl;
  @useResult
  $Res call({String route});
}

/// @nodoc
class _$NavigateToCopyWithImpl<$Res> implements $NavigateToCopyWith<$Res> {
  _$NavigateToCopyWithImpl(this._self, this._then);

  final NavigateTo _self;
  final $Res Function(NavigateTo) _then;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? route = null}) {
    return _then(
      NavigateTo(
        null == route
            ? _self.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class PlaySound with DiagnosticableTreeMixin implements CounterEffect {
  const PlaySound(this.soundAsset);

  final String soundAsset;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaySoundCopyWith<PlaySound> get copyWith =>
      _$PlaySoundCopyWithImpl<PlaySound>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterEffect.playSound'))
      ..add(DiagnosticsProperty('soundAsset', soundAsset));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlaySound &&
            (identical(other.soundAsset, soundAsset) || other.soundAsset == soundAsset));
  }

  @override
  int get hashCode => Object.hash(runtimeType, soundAsset);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterEffect.playSound(soundAsset: $soundAsset)';
  }
}

/// @nodoc
abstract mixin class $PlaySoundCopyWith<$Res> implements $CounterEffectCopyWith<$Res> {
  factory $PlaySoundCopyWith(PlaySound value, $Res Function(PlaySound) _then) =
      _$PlaySoundCopyWithImpl;
  @useResult
  $Res call({String soundAsset});
}

/// @nodoc
class _$PlaySoundCopyWithImpl<$Res> implements $PlaySoundCopyWith<$Res> {
  _$PlaySoundCopyWithImpl(this._self, this._then);

  final PlaySound _self;
  final $Res Function(PlaySound) _then;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({Object? soundAsset = null}) {
    return _then(
      PlaySound(
        null == soundAsset
            ? _self.soundAsset
            : soundAsset // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$CounterState implements DiagnosticableTreeMixin {
  int get count;
  bool get isLoading;
  String? get error;

  /// Create a copy of CounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CounterStateCopyWith<CounterState> get copyWith =>
      _$CounterStateCopyWithImpl<CounterState>(this as CounterState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterState'))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CounterState &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, isLoading, error);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterState(count: $count, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $CounterStateCopyWith<$Res> {
  factory $CounterStateCopyWith(CounterState value, $Res Function(CounterState) _then) =
      _$CounterStateCopyWithImpl;
  @useResult
  $Res call({int count, bool isLoading, String? error});
}

/// @nodoc
class _$CounterStateCopyWithImpl<$Res> implements $CounterStateCopyWith<$Res> {
  _$CounterStateCopyWithImpl(this._self, this._then);

  final CounterState _self;
  final $Res Function(CounterState) _then;

  /// Create a copy of CounterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null, Object? isLoading = null, Object? error = freezed}) {
    return _then(
      _self.copyWith(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _self.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [CounterState].
extension CounterStatePatterns on CounterState {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CounterState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CounterState() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(TResult Function(_CounterState value) $default) {
    final _that = this;
    switch (_that) {
      case _CounterState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(TResult? Function(_CounterState value)? $default) {
    final _that = this;
    switch (_that) {
      case _CounterState() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int count, bool isLoading, String? error)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CounterState() when $default != null:
        return $default(_that.count, _that.isLoading, _that.error);
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
  TResult when<TResult extends Object?>(
    TResult Function(int count, bool isLoading, String? error) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CounterState():
        return $default(_that.count, _that.isLoading, _that.error);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int count, bool isLoading, String? error)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CounterState() when $default != null:
        return $default(_that.count, _that.isLoading, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CounterState with DiagnosticableTreeMixin implements CounterState {
  const _CounterState({this.count = 0, this.isLoading = false, this.error});

  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  /// Create a copy of CounterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CounterStateCopyWith<_CounterState> get copyWith =>
      __$CounterStateCopyWithImpl<_CounterState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CounterState'))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CounterState &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, isLoading, error);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CounterState(count: $count, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$CounterStateCopyWith<$Res> implements $CounterStateCopyWith<$Res> {
  factory _$CounterStateCopyWith(_CounterState value, $Res Function(_CounterState) _then) =
      __$CounterStateCopyWithImpl;
  @override
  @useResult
  $Res call({int count, bool isLoading, String? error});
}

/// @nodoc
class __$CounterStateCopyWithImpl<$Res> implements _$CounterStateCopyWith<$Res> {
  __$CounterStateCopyWithImpl(this._self, this._then);

  final _CounterState _self;
  final $Res Function(_CounterState) _then;

  /// Create a copy of CounterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? count = null, Object? isLoading = null, Object? error = freezed}) {
    return _then(
      _CounterState(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _self.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}