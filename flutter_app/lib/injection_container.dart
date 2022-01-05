import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/auth/current_login.dart';
import 'package:flutter_frontend/infrastructure/auth/firebase_auth_facade.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
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

import 'infrastructure/auth/symfonyLogin.dart';
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

    // register Token Service for retrieving login tokens
    getIt.registerLazySingleton(() => AuthTokenService());



    getIt.registerLazySingleton<FirebaseAuthFacade>(() => FirebaseAuthFacade(
        FirebaseAuth.instance,
        GoogleSignIn.standard(scopes: ["email", "profile"])));

    getIt.registerLazySingleton(
        () => SignInFormCubit(authFacade: getIt<FirebaseAuthFacade>()));

    getIt.registerLazySingleton(() => EventRepository(
        EventRemoteService(communicator: communicator), EventLocalService()));

    getIt.registerLazySingleton(() => PostRepository(
        PostRemoteService(communicator: communicator)));

    getIt.registerLazySingleton(
      () => TodoRepository(
        ItemRemoteService(communicator: communicator),
        TodoRemoteService(communicator: communicator),
      ),
    );

    getIt.registerLazySingleton(
      () => CommentRepository(
        CommentRemoteService(communicator: communicator),
      ),
    );

    getIt
        .registerLazySingleton(() => ProfileRepository(ProfileRemoteService()));
  }
}
