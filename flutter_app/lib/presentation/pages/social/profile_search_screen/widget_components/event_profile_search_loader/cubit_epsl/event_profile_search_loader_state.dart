part of 'event_profile_search_loader_cubit.dart';

enum EpslStatus {loading, loaded, error}
@CopyWith()
class EventProfileSearchLoaderState<T> {
  final EpslStatus status;
  final List<T> enities;
  final NetWorkFailure? failure;

  EventProfileSearchLoaderState({required this.status, this.enities = const [], this.failure});
}

