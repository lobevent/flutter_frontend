import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/cubit__eop_single_tab_distances/eop_single_tab_distances_cubit.dart';

class EOPTabBarViewDistanceBar extends StatefulWidget {
  const EOPTabBarViewDistanceBar({Key? key}) : super(key: key);

  @override
  State<EOPTabBarViewDistanceBar> createState() => _EOPTabBarViewDistanceBarState();
}

class _EOPTabBarViewDistanceBarState extends State<EOPTabBarViewDistanceBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        elevation: 10.0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        pinned: true,
        //lat 37.4219983 long -122.084
        bottom: PreferredSize(
          preferredSize: const Size(90, 70),
          child: Slider.adaptive(
              value: context.read<EopSingleTabDistancesCubit>().getSearchDistatnce(),
              min: 0,
              max: 50,
              divisions: 50,
              label: context.read<EopSingleTabDistancesCubit>().getSearchDistatnce().toString(),
              onChangeEnd: (newRating) {
                  context.read<EopSingleTabDistancesCubit>().setSearchDistanceAndUpdate(newRating);
                },
              onChanged: (newRating) {
                setState(() {
                  context.read<EopSingleTabDistancesCubit>().setSearchDistance(newRating);
                });
              }),
        )
    );
  }
}
