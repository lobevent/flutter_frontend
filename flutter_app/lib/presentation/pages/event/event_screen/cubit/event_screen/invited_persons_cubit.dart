import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:get_it/get_it.dart';

extension on EventScreenCubit{
  
  Future<void> revokeInvitation(Profile profile, Event event) async{
    invitationRepository.revokeInvitation(profile, event).then((value) => value.fold(
            (failure) => throw UnimplementedError(),
            (invitation){
          revokedInvitation(invitation);
        }));
  }
}