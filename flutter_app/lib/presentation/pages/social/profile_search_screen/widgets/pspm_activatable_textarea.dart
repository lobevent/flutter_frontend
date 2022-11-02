import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/cubit/main_profile_search_cubit.dart';

class ActivatableTextarea extends StatefulWidget {
  final TextEditingController controller;
  const ActivatableTextarea({Key? key, required this.controller}) : super(key: key);

  @override
  State<ActivatableTextarea> createState() => _ActivatableTextareaState();
}

class _ActivatableTextareaState extends State<ActivatableTextarea> {
  
  bool searchIsTapped = false;
  //history
  static const historyLength = 5;
  //get history from commonhive
  List<String> filteredSearchHistory = [];
  String? selectedTerm;

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainProfileSearchCubit, MainProfileSearchState>(
      listener: (context, state) => filteredSearchHistory = state.filteredSearchHistory,
        builder: (context, state){
          return Column(children: [
            _searchTextField(context),
          ],);
    });
  }


  ///decides if user has tapped searchtextfield
  Widget _searchTextField(BuildContext context) {
    return Autocomplete<String>(optionsBuilder: (TextEditingValue value) => filteredSearchHistory,

      onSelected: (String selection) =>  context.read<MainProfileSearchCubit>().submitSearchTerm(selection),
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) =>
      TextField(
        // Set the tapped flag to true, so stuff can be searched
        onTap: () {setState(() {searchIsTapped = true;});},
        //filter search terms based on input
        onChanged: (value) => context.read<MainProfileSearchCubit>().changeSearchTerm(value),
        //if submitted add search term to history and commonhive and fetch from backend
        onSubmitted: (value) => context.read<MainProfileSearchCubit>().submitSearchTerm(value),
        controller: fieldTextEditingController,
        decoration: _getDecoration(),
      ));
  }
  
  InputDecoration _getDecoration(){
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: AppStrings.search,
      hintText: AppStrings.search,
      //suffixIcon: Icon(Icons.search_outlined),
      prefixIcon: searchIsTapped ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => setState(() {
          //we can go back via this button to previous search screen
          widget.controller.clear();
          searchIsTapped = false;
        }),
      ) : Icon(Icons.search_outlined),
    );
  }


}
