import 'package:flutter/material.dart';

class CountryCodeSelectionScreen extends StatefulWidget {
  @override
  _CountryCodeSelectionScreenState createState() => _CountryCodeSelectionScreenState();
}

class _CountryCodeSelectionScreenState extends State<CountryCodeSelectionScreen> {

  final TextEditingController searchBarTextEditingController = TextEditingController();

  List<Widget> countryCodeListItems = [];
  
  @override
  void initState() {
    super.initState();

    countryCodeListItems = _buildListItemsFromCountryList(countryCodes);

    searchBarTextEditingController.addListener(() {
      final String searchText = searchBarTextEditingController.text;
      if (searchText.isNotEmpty) {
        setState(() {
          countryCodeListItems.clear();
          countryCodeListItems = _buildListItemsFromCountryList(_searchCountryCodes(searchText));
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final appBar = _buildAppBar();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              gradient: loginBackgroundGradient,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    translate("login.countryCode.title"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  margin: const EdgeInsets.only(bottom: 30.0),
                  child: _buildSearchBarTextField(),
                ),

                Expanded(
                  child: _buildCountryCodeListView(context),
                ),
              ],
            ),
          ),


          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: appBar,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: lightGrey,
          size: 35.0,
        ),
        onPressed: _handleBackPress,
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
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        hintText: translate("login.countryCode.searchBarHint"),
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

  Widget _buildCountryCodeListView(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: countryCodeListItems,
      ),
    );
  }

  List<Widget> _buildListItemsFromCountryList(List<Map<String, String>> countryCodes) {
    final List<Widget> tmpListItems = [];
    for(final Map<String, String> countryMap in countryCodes) {
      if (countryMap == countryCodes.last) {
        tmpListItems.add(_buildListItem(countryMap, true));
      } else {
        tmpListItems.add(_buildListItem(countryMap, false));
      }
    }
    return tmpListItems;
  }

  Widget _buildListItem(Map<String, String> countryData, bool lastItem) {
    const TextStyle listItemTextStyle = TextStyle(
        color: Colors.white
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
          onPressed: () => _handleListViewItemPressed(countryData),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${countryData['name']} (${countryData['code']})",
                    textAlign: TextAlign.left,
                    style: listItemTextStyle,
                  ),
                ),
                Text(
                  countryData['dial_code'],
                  textAlign: TextAlign.right,
                  style: listItemTextStyle,
                )
              ],
            ),
          ),
        ),

        lastItem ? null : Container(
          padding: EdgeInsets.only(left: 15.0),
          child: Divider(
            color: darkGrey,
          ),
        ),
      ].where((widget) => widget != null).toList(),
    );
  }
  
  List<Map<String, String>> _searchCountryCodes(String searchString) {
    final List<Map<String, String>> searchResults = [];
    final String lowerCaseSearchString = searchString.toLowerCase();

    for(final Map<String, String> countryDataMap in countryCodes) {
      final String countryDataString =
          "${countryDataMap['name']} ${countryDataMap['code']} ${countryDataMap['dial_code']}".toLowerCase();
      if (countryDataString.contains(lowerCaseSearchString)) {
        searchResults.add(countryDataMap);
      }
    }
    return searchResults;
  }
  
  void _handleBackPress() {
    print("Back pressed");
    Navigator.of(context).pop(null);
    // TODO implement
  }

  void _handleListViewItemPressed(Map<String, String> countryData) {
    Navigator.of(context).pop(countryData);
  }
}
