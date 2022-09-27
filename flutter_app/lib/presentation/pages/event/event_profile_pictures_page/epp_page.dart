import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_profile_pictures_page/cubit/epp_page_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_profile_pictures_page/widgets/epp_page_grid_tile.dart';

///
/// Page to display Profile Event Images
///
class EPPPage extends StatelessWidget {

  /// [event] is the event from which the pics are loaded
  final Event event;
  const EPPPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // ---- bloc stuff
    return BlocProvider(
        create: (context) => EppPageCubit(event), 
      child: BlocBuilder<EppPageCubit, EppPageState>(



        // ----- builder --------
        builder: (context, state) =>  BasicContentContainer(
          isLoading: state is EppPLoading,
          child_ren: state.maybeMap(loaded:(lstate) => right(
            // ----------- gridview -----------
              GridView.count(
                mainAxisSpacing: 3.0,
                crossAxisSpacing: 3.0,
                padding: EdgeInsets.all(9.0),
                crossAxisCount: (MediaQuery.of(context).size.width ~/ 100).toInt(),
                children: lstate.epps.map((e) => EppGridListTile(epp: e,)).toList(),

        )), orElse: () { return right(Text("bklaa"));}),
        ),
      ),
    );
  }
}
