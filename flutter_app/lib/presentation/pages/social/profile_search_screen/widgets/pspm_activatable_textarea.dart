import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/cubit/main_profile_search_cubit.dart';

class ActivatableTextarea extends StatefulWidget {
  const ActivatableTextarea({Key? key}) : super(key: key);

  @override
  State<ActivatableTextarea> createState() => _ActivatableTextareaState();
}

class _ActivatableTextareaState extends State<ActivatableTextarea> {
  TextEditingController controller = TextEditingController();
  
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
            SuggestionsList(context)
          ],);
    });
  }




  /// displayes the text field and decides wheter it is focused or not
  /// takes [BuildContext] with [MainProfileSearchCubit] in it
  ///
  Widget _searchTextField(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => hasFocus == false ? _leaveSearch(context) : _enterSearch(context),
      child: TextField(

          // Set the tapped flag to true, so stuff can be searched
          onTap: () {_enterSearch(context);},
          //filter search terms based on input
          onChanged: (value) => context.read<MainProfileSearchCubit>().changeSearchTerm(value),
          //if submitted add search term to history and commonhive and fetch from backend
          onSubmitted: (value) => context.read<MainProfileSearchCubit>().submitSearchTerm(value),
          controller: controller,
          decoration: _getDecoration(),
        ),
    );
  }

  /// builds ListView of the Items with the search history
  /// the [searchIsTapped] flag determines whether to show the list, or to hide it
  /// the items are clickable and activate the submitted event
  Widget SuggestionsList(BuildContext context){
    return Visibility(
      visible: searchIsTapped,
      child: Container(
        decoration: BoxDecoration(color: AppColors.darkGrey),
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index){
              return InkWell(
                child: Center(
                    child: SizedBox(
                      height: 40,
                        width: 100,
                        child: Align(alignment: Alignment.centerLeft, child: Text(filteredSearchHistory[index])))),
                onTap: (){
                  controller.text = filteredSearchHistory[index];
                  FocusScope.of(context).unfocus();
                  context.read<MainProfileSearchCubit>().changeSearchTerm(filteredSearchHistory[index]);
                  context.read<MainProfileSearchCubit>().submitSearchTerm(filteredSearchHistory[index]);
                  _leaveSearch(context);

                },);
        },
            separatorBuilder:
                (context, index) => Divider(height: 1.1, thickness: 1.2,),
            itemCount: this.filteredSearchHistory.length
        ),
      ),
    );
  }


  /// determines what decoration the textfield should have
  /// it depends on the [searchIsTapped] Flag
  /// changes prefix icon depending on it
  InputDecoration _getDecoration(){
    return InputDecoration(
      filled: true,
      fillColor: AppColors.darkGrey,
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder().copyWith(borderSide: const BorderSide(color: AppColors.appBarCollor)),
      //labelText: AppStrings.search,
      hintText: AppStrings.search,
      //suffixIcon: Icon(Icons.search_outlined),
      prefixIcon: searchIsTapped ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => setState(() {
          //we can go back via this button to previous search screen
          //controller.clear();
          _leaveSearch(context);
          setState(() {});
          FocusScope.of(context).unfocus();
        }),
      ) : Icon(Icons.search_outlined),
    );
  }

  /// private function that calls the cubit and sets the local variable [searchIsTapped]
  /// called when the search is entered
  _enterSearch(BuildContext context){
    context.read<MainProfileSearchCubit>().enterSearch();
    setState(() {searchIsTapped = true;});
  }

  /// private function that calls the cubit and sets the local variable [searchIsTapped]
  /// called when the search is left
  _leaveSearch(BuildContext context){
    context.read<MainProfileSearchCubit>().leaveSearch();
    setState(() {searchIsTapped = false;});
  }


}
