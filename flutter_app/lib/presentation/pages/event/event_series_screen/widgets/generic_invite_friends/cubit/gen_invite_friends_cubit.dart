import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../../domain/core/failures.dart';
import '../../../../../../../domain/profile/profile.dart';
import '../../../../../../../infrastructure/event_series/eventSeries_repository.dart';
import '../../../../../../../infrastructure/event_series_invitation/esi_repository.dart';
import '../../../../../../../infrastructure/profile/profile_repository.dart';
import '../gen_invite_friends_button.dart';

part 'gen_invite_friends_state.dart';

part 'gen_invite_friends_cubit.g.dart';

class GenInviteFriendsCubit extends Cubit<GenInviteFriendsState>{
  bool disableButton = false;
  final InviteFriendsButtonType inviteFriendsButtonType;

  GenInviteFriendsCubit({required this.inviteFriendsButtonType}) :
        super(GenInviteFriendsState.loading()){
      loadFriendsAndStuff();

}
  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();
  EventSeriesInvitationRepository esiRepository = GetIt.I<EventSeriesInvitationRepository>();

  Future<void> loadFriendsAndStuff() async {
    await profileRepository.getFriends(profile: null).then((value) => value.fold(
            (failure) => emit(state.copyWith(status: GenInviteFriendsStatus.error, failure: failure)),
        // compare the complete friendlist with the invitations for this event
        // set isLoadingFriends false, as they are loaded now obviously
            (friends) {
              emit(GenInviteFriendsState.loaded(friends: friends));
        }));
  }
}