import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/cubit/main_profile_search_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widgets/pspm_activatable_textarea.dart';

class ProfileSearchPageMain extends StatelessWidget {
  const ProfileSearchPageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasicContentContainer(child_ren: right(
      BlocProvider(
          create: (context) => MainProfileSearchCubit(),
        child: BlocBuilder<MainProfileSearchCubit, MainProfileSearchState>(
          builder: (context, state){
            return Column(children: [
                ActivatableTextarea(controller: TextEditingController())
            ],);
          },
        ),
      )
    ));
  }
}
