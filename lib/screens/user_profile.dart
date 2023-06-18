import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../utils/constants.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  int rows=10;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(showSearchBar: true,),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width,
                  color: primaryColor,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
                    child: Image.asset('assets/images/profile.png',height: 100,),
                  ),
                ),


              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(child: Text('Anika Levin',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),))
            ),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(child: Text('Australia, Melbourne',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),))
            ),
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.all(20),
              height: 50,
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
                    fillColor: Colors.white,
                    suffixIcon: Icon(Icons.search),
                    hintText: 'Search',
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
            Divider(),
            TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              tabs: [
                Tab(
                  text: 'Followers 13',
                ),
                Tab(
                  text: 'Followed 13',
                  //child: Text('Followed 16',style: TextStyle,),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  if(Responsive.isMobile(context))
                    followersMobile()
                  else
                    followersWeb(),
                  if(Responsive.isMobile(context))
                    followersMobile()
                  else
                    followersWeb(),

                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget followersMobile(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,fontSize: 17)),
              Text('Social Media',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,fontSize: 17)),

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Divider(),
              Row(

                children: [
                  Image.asset('assets/images/profile.png',height: 40,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                        Text('Australia, Melbourne',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/fbIcon.png',height: 25,),
                      SizedBox(width: 10,),
                      Image.asset('assets/images/instaIcon.png',height: 25,),
                    ],
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Divider(),
              Row(

                children: [
                  Image.asset('assets/images/profile.png',height: 40,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                        Text('Australia, Melbourne',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/fbIcon.png',height: 25,),
                      SizedBox(width: 10,),
                      Image.asset('assets/images/instaIcon.png',height: 25,),
                    ],
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
  Widget followersWeb(){
    return Container(
      //height: (MediaQuery.of(context).size.height*0.065)*snapshot.data!.length,
      height: (MediaQuery.of(context).size.height*0.11)*rows,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.18,right: MediaQuery.of(context).size.width*0.18),
      child: InteractiveViewer(

        constrained: false,
        child: DataTable(

            columnSpacing: 20,
            horizontalMargin: 12,
            columns: [
              DataColumn(
                label: Text('Name'),
              ),
              DataColumn(
                label: Text('Email'),
              ),
              DataColumn(
                label: Text('Phone Number'),
              ),
              DataColumn(
                label: Text('Social Media'),
              ),



            ],
            rows: List<DataRow>.generate(rows, (index){
              return DataRow(
                  cells: [

                    DataCell(
                        Container(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Row(
                            children: [
                              Image.asset('assets/images/profile.png',height: 40,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                                  Text('Australia, Melbourne',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

                                ],
                              )
                            ],
                          ),
                        )
                    ),
                    DataCell(
                        Container(
                          width: MediaQuery.of(context).size.width*0.14,
                          child: Text('Anika@Levin.com'),
                        )
                    ),

                    DataCell(
                        Container(
                            width: MediaQuery.of(context).size.width*0.14,
                            child: Text('+1 123 456 798')
                        )

                    ),
                    DataCell(
                        Container(
                          width: MediaQuery.of(context).size.width*0.14,
                          child: Row(
                            children: [
                              Image.asset('assets/images/fbIcon.png',height: 25,),
                              SizedBox(width: 10,),
                              Image.asset('assets/images/instaIcon.png',height: 25,),
                            ],
                          ),
                        )
                    ),



                  ]
              );
            })
        ),
      ),
    );
  }
}
