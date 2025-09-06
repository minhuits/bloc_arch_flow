// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_mvi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CounterIntent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is CounterIntent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
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

    TResult

  Function

  (

  Decrement

  value

  )

  ?

  decrement

  ,

    TResult Function(IncrementAsync value)? incrementAsync,

    TResult

  Function

  (

  Reset

  value

  )

  ?

  reset

  ,

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
TResult maybeWhen
<
TResult extends Object?>(
{
TResult
Function
(
)
?
increment
,
TResult
Function
(
)
?
decrement
,
TResult
Function
(
)
?
incrementAsync
,
TResult
Function
(
)
?
reset
,
required
TResult
orElse(),
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

class Increment implements CounterIntent {
  const Increment();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is Increment);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterIntent.increment()';
  }
}

/// @nodoc

class Decrement implements CounterIntent {
  const Decrement();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is Decrement);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterIntent.decrement()';
  }
}

/// @nodoc

class IncrementAsync implements CounterIntent {
  const IncrementAsync();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is IncrementAsync);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterIntent.incrementAsync()';
  }
}

/// @nodoc

class Reset implements CounterIntent {
  const Reset();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is Reset);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CounterIntent.reset()';
  }
}

/// @nodoc
mixin _$CounterEffect {
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is CounterEffect);
  }

  @override
int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
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

class ShowToast implements CounterEffect {
  const ShowToast(this.message);

  final String message;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShowToastCopyWith<ShowToast> get copyWith =>
      _$ShowToastCopyWithImpl<ShowToast>(this, _$identity);

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
String toString() {
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

class NavigateTo implements CounterEffect {
  const NavigateTo(this.route);

  final String route;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NavigateToCopyWith<NavigateTo> get copyWith =>
      _$NavigateToCopyWithImpl<NavigateTo>(this, _$identity);

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
String toString() {
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

class PlaySound implements CounterEffect {
  const PlaySound(this.soundAsset);

  final String soundAsset;

  /// Create a copy of CounterEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaySoundCopyWith<PlaySound> get copyWith =>
      _$PlaySoundCopyWithImpl<PlaySound>(this, _$identity);

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
String toString() {
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