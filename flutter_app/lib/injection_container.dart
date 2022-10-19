import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/auth/current_login.dart';
import 'package:flutter_frontend/infrastructure/auth/firebase_auth_facade.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/epp_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/epp_repository.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_remote_service.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_repository.dart';
import 'package:flutter_frontend/infrastructure/post/comment_remote_service.dart';
import 'package:flutter_frontend/infrastructure/post/comment_repository.dart';
import 'package:flutter_frontend/infrastructure/post/post_remote_service.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:flutter_frontend/infrastructure/todo/item_remote_service.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_remote_service.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import 'infrastructure/core/local/common_hive/common_hive.dart';
import 'infrastructure/auth/symfonyLogin.dart';
import 'infrastructure/invitation/invitation_remote_service.dart';
import 'infrastructure/profile/profile_remote_service.dart';
import 'infrastructure/profile/profile_repository.dart';

// ignore: avoid_classes_with_only_static_members
class InjectionContainer {
  // get an instance of the GetIt singleton to use for injection
  static final GetIt getIt = GetIt.I; // equal to: GetIt.instance;

  static Future<void> injectDependencies() async {
    AuthTokenService tokenService = AuthTokenService();
    String token = await tokenService.retrieveToken() ?? '';

    SymfonyCommunicator communicator =
        SymfonyCommunicator(jwt: token, client: Client());

    getIt.registerLazySingleton(() => communicator);

    // register Token Service for retrieving login tokens
    getIt.registerLazySingleton(() => AuthTokenService());

    getIt.registerLazySingleton<FirebaseAuthFacade>(() => FirebaseAuthFacade(
        FirebaseAuth.instance,
        GoogleSignIn.standard(scopes: ["email", "profile"])));

    getIt.registerLazySingleton(
        () => SignInFormCubit(authFacade: getIt<FirebaseAuthFacade>()));

    getIt.registerLazySingleton(() => EventRepository(
        EventRemoteService(communicator: GetIt.I<SymfonyCommunicator>()),
        EventLocalService()));

    getIt.registerLazySingleton(() => PostRepository(
        PostRemoteService(communicator: GetIt.I<SymfonyCommunicator>())));

    getIt.registerLazySingleton(() => EventSeriesRepository(
        remoteService: EventSeriesRemoteService(
            communicator: GetIt.I<SymfonyCommunicator>())));

    getIt.registerLazySingleton(() => InvitationRepository(
        remoteService: InvitationRemoteService(
            communicator: GetIt.I<SymfonyCommunicator>())));

    getIt.registerLazySingleton(() => MyLocationRepository(
        remoteService: MyLocationRemoteService(
            communicator: GetIt.I<SymfonyCommunicator>())));

    getIt.registerLazySingleton(() => EventProfilePictureRepository(
        remoteService: EventProfilePictureRemoteService(
            communicator: GetIt.I<SymfonyCommunicator>())));

    getIt.registerLazySingleton(
      () => TodoRepository(
        ItemRemoteService(communicator: GetIt.I<SymfonyCommunicator>()),
        TodoRemoteService(communicator: GetIt.I<SymfonyCommunicator>()),
      ),
    );

    getIt.registerLazySingleton(
      () => CommentRepository(
        CommentRemoteService(communicator: GetIt.I<SymfonyCommunicator>()),
      ),
    );

    getIt.registerLazySingleton(() => ProfileRepository(
        ProfileRemoteService(communicator: GetIt.I<SymfonyCommunicator>())));
  }

  /// This loads async stuff for the Container
  /// IMPORTANT NOTE: this has to be called AFTER [InjectionContainer.injectDependencies()] !!!!!!!
  static Future<void> loadNecessities() async {
    CommonHive.safeOwnProfileIdAndPic();
    //GetIt.I<StorageShared>().safeOwnProfile();
  }
}
