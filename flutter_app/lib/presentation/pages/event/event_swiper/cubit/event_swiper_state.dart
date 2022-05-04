part of 'event_swiper_cubit.dart';

@freezed
class EventSwiperState with _$EventSwiperState {
  const factory EventSwiperState({required List<Event> eventsList}) =
      _EventSwiperState;

  factory EventSwiperState.initial() = _Initial;

  factory EventSwiperState.loading() = _Loading;

  factory EventSwiperState.loaded({required List<Event> eventsList}) = _Loaded;

  factory EventSwiperState.error({required String error}) = _Error;
}
