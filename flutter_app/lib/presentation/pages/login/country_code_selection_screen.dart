import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';

import 'package:flutter_frontend/data/country_codes.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';

import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/login/widgets/country_code_list_tile.dart';

class CountryCodeSelectionScreen extends StatefulWidget {
  @override
  _CountryCodeSelectionScreenState createState() => _CountryCodeSelectionScreenState();
}

class _CountryCodeSelectionScreenState extends State<CountryCodeSelectionScreen> {

  final TextEditingController searchBarTextEditingController = TextEditingController();

  List<Map<String,String>> countryCodeListItems = [];

  @override
  void initState() {
    super.initState();

    countryCodeListItems = countryCodes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: const Text(
              AppStrings.countryCodeTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.basic,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            margin: const EdgeInsets.only(bottom: 30.0),
            child: _buildSearchBarTextField(),
          ),

          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: countryCodeListItems.length,
              itemBuilder: (context, index) => CountryCodeListTile(
                countryData: countryCodeListItems[index], 
                countryCodePressed: _handleListViewItemPressed
              ),
              separatorBuilder: (context, index) => Container(
                padding: const EdgeInsets.only(left: 15.0),
                child: const Divider(
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarTextField() {
    const TextStyle hintTextStyle = TextStyle(
      color: Colors.white,
    );
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
    );
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.white,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    return TextFormField(
      controller: searchBarTextEditingController,
      onChanged: _searchCountryCodes,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.mainIcon,
        ),
        hintText: AppStrings.countryCodeSearchBar,
        hintStyle: hintTextStyle,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        focusedBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        errorBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
      ),
      style: textStyle,
    );
  }

  void _searchCountryCodes(String searchString) {
    List<Map<String, String>> tmpSearchResults = [];

    if (searchString.isEmpty) {
      tmpSearchResults = countryCodes;
    } else {
      final String lowerCaseSearchString = searchString.toLowerCase();

      for(final Map<String, String> countryDataMap in countryCodes) {
        final String countryDataString = (
            countryDataMap[Constants.countryDataName]! +
            countryDataMap[Constants.countryDataCode]! +
            countryDataMap[Constants.countryDataDialCode]!
            ).toLowerCase();

        if (countryDataString.contains(lowerCaseSearchString)) {
          tmpSearchResults.add(countryDataMap);
        }
      }
    }
    
    setState(() {
      countryCodeListItems = tmpSearchResults;
    });
  }

  void _handleBackPress() {
    // TODO add back button
    context.router.pop();
  }

  void _handleListViewItemPressed(Map<String, String> countryData) {
    context.read<SignInFormCubit>().changeCountryCode(countryData);
  }
}
