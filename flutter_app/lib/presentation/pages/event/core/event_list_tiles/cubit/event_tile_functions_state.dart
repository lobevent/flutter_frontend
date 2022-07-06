part of 'event_tile_functions_cubit.dart';

@immutable
abstract class EventTileFunctionsState {}

class EventTileFunctionsInitial extends EventTileFunctionsState {}
class EventTileUESLoading extends EventTileFunctionsState {}
class EventTileUESLoaded extends EventTileFunctionsState{}
class EventTileUESError extends EventTileFunctionsState{final NetWorkFailure failure;  EventTileUESError(this.failure);}
