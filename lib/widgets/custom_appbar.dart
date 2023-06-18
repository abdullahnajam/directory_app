import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/my_profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomAppBar extends StatefulWidget {
  bool showSearchBar;


  CustomAppBar({required this.showSearchBar});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.isMobile(context)?EdgeInsets.all(10):EdgeInsets.fromLTRB(20,10,30,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Homepage()));
            },
            child: Image.asset('assets/images/logo.png',height: 25,fit: BoxFit.cover,),
          ),
          if(!Responsive.isMobile(context) && widget.showSearchBar)
            Container(
              height: 50,
              width: 300,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(


                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0.5
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search,color: primaryColor,),
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                noItemsFoundBuilder: (context) {
                  return ListTile(
                    leading: Icon(Icons.error),
                    title: Text('No Data Found'),
                  );
                },
                suggestionsCallback: (pattern) async {

                 /* List<SearchModel> search=[];

                  search=await ChatApi.getSearchData(provider.userData!.userId,pattern);*/



                  return [];
                },
                itemBuilder: (context, var suggestion) {
                  return ListTile(
                    onTap: (){

                    },

                    title: Text(suggestion.name),
                    trailing: Text(suggestion.group?'Group':''),
                  );
                },
                onSuggestionSelected: (var suggestion) {
                  //_countryController.text=suggestion.name;
                  Navigator.pop(context);

                },
              ),
            ),
          if(!Responsive.isMobile(context))
            Row(
              children: [
                Text('My Contacts',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));

                  },
                  child: Image.asset('assets/images/profile.png',height: 25,fit: BoxFit.cover,),
                )
              ],
            )
          else
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));

              },
              child: Image.asset('assets/images/menu.png',height: 18,fit: BoxFit.cover,),
            )
        ],
      ),
    );
  }
}
