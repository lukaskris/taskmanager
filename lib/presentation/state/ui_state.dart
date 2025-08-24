import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_state.freezed.dart';

@freezed
class UIState<T> with _$UIState<T> {
  const factory UIState.initial() = _Initial<T>;
  const factory UIState.loading() = _Loading<T>;
  const factory UIState.success(T data) = _Success<T>;
  const factory UIState.failure(String error) = _Failure<T>;
}
