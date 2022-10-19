part of 'event_tile_functions_cubit.dart';

@immutable
abstract class EventTileFunctionsState {late final EventStatus? status; EventTileFunctionsState(this.status);}

class EventTileFunctionsInitial extends EventTileFunctionsState {EventTileFunctionsInitial(EventStatus? status):super(status); }
class EventTileUESLoading extends EventTileFunctionsState {EventTileUESLoading(EventStatus? status):super(status);}
class EventTileUESLoaded extends EventTileFunctionsState{EventTileUESLoaded(EventStatus? status):super(status); }
class EventTileUESError extends EventTileFunctionsState{ final NetWorkFailure failure;  EventTileUESError(this.failure, EventStatus? status):super(status);}
class EventTileDeletionError extends EventTileFunctionsState{ final NetWorkFailure failure;  EventTileDeletionError({required this.failure, EventStatus? status}):super(status);}
class EventTileDeletionSuccess extends EventTileFunctionsState{ EventTileDeletionSuccess({EventStatus? status}):super(status);}
