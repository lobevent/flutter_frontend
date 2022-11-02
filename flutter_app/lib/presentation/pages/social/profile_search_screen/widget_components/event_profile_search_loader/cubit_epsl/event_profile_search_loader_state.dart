part of 'event_profile_search_loader_cubit.dart';

enum EpslStatus {loading, loaded, error}
@CopyWith()
class EventProfileSearchLoaderState<T> {
  /// takes an value of the [EpslStatus] enum, and controlls behavior of the screen
  final EpslStatus status;

  /// contains the loaded lists with the entities of type [T]
  final List<T> enities;

  /// is not null if an error occured
  final NetWorkFailure? failure;

  EventProfileSearchLoaderState({required this.status, this.enities = const [], this.failure});
}

