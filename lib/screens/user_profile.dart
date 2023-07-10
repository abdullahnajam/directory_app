import 'package:cool_alert/cool_alert.dart';
import 'package:directory_app/model/user_model.dart';
import 'package:directory_app/screens/profile.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/database_api.dart';
import '../utils/constants.dart';

class UserProfile extends StatefulWidget {
  UserModel user;

  UserProfile(this.user);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  int rows=10;
  int followers=0;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    DBApi.getFollowersData(widget.user.userId).then((value){
      setState(() {
        followers=value.length;
      });
    });
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: maxWidth
            ),
            child: FutureBuilder<List<UserModel>>(
                future: DBApi.getFollowersData(widget.user.userId),
                builder: (context, AsyncSnapshot<List<UserModel>> followersShot) {
                  if (followersShot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      child: const CupertinoActivityIndicator(),
                    );
                  }
                  else {
                    if (followersShot.hasError) {
                      print("error ${followersShot.error}");
                      return Container(
                        color: primaryColor,
                        child: const Center(
                          child: Text("something went wrong"),
                        ),
                      );
                    }



                    else {
                      return Column(
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
                                  child: ProfilePicture(url: widget.user.profilePic,height: 100,width: 100,),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(top:10,right: 10),
                                  child: InkWell(
                                    onTap: (){
                                      //context.go('/user-profile/${widget.user.userId}');
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(userId:widget.user.userId)));


                                    },
                                    child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(7),
                                            border: Border.all(color: Colors.grey)
                                        ),
                                        alignment: Alignment.center,
                                        child:  Text(' View Profile ',style: TextStyle(),)
                                    ),
                                  ),
                                ),
                              ),


                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Center(child: Text('${widget.user.firstName} ${widget.user.lastName}',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),))
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Center(child: Text('${widget.user.city}, ${widget.user.country}',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),))
                          ),
                          /*SizedBox(height: 5,),
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

                      *//* List<SearchModel> search=[];

                      search=await ChatApi.getSearchData(provider.userData!.userId,pattern);*//*



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
                ),*/
                          Divider(),
                          TabBar(
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: primaryColor,
                            labelColor: primaryColor,
                            tabs: [
                              Tab(
                                text: 'Followers ${followersShot.data!.length}',
                              ),
                              Tab(
                                text: 'Following ${widget.user.following.length}',
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
                                  followingMobile()
                                else
                                  followedWeb(),

                              ],
                              controller: _tabController,
                            ),
                          ),
                        ],
                      );

                    }
                  }
                }
            ),
          ),
        ),
      ),
    );
  }
  Widget followingMobile(){
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
        FutureBuilder<List<UserModel>>(
            future: DBApi.getUserData(widget.user.following),
            builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                );
              }
              else {
                if (snapshot.hasError) {
                  print("error ${snapshot.error}");
                  return Container(
                    color: primaryColor,
                    child: Center(
                      child: Text("something went wrong"),
                    ),
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No Users'),
                  );
                }

                else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Divider(),
                            Row(

                              children: [
                                ProfilePicture(url: snapshot.data![index].profilePic,height: 40,),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                                      Text('${snapshot.data![index].country}, ${snapshot.data![index].city}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

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
                      );
                    },
                  );

                }
              }
            }
        ),
      ],
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
        FutureBuilder<List<UserModel>>(
            future: DBApi.getFollowersData(widget.user.userId),
            builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                );
              }
              else {
                if (snapshot.hasError) {
                  print("error ${snapshot.error}");
                  return Container(
                    color: primaryColor,
                    child: Center(
                      child: Text("something went wrong"),
                    ),
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No Users'),
                  );
                }

                else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index){
                      return userTile(snapshot.data![index]);
                    },
                  );

                }
              }
            }
        ),
      ],
    );
  }
  Widget userTile(UserModel userModel){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          //context.go('/user-profile/${userModel.userId}');
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(userId:userModel.userId)));

        },
        child: Column(
          children: [
            Divider(),
            Row(

              children: [
                ProfilePicture(url: userModel.profilePic,height: 40,),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${userModel.firstName} ${userModel.lastName}',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                      Text('${userModel.country}, ${userModel.city}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

                    ],
                  ),
                ),
                Row(
                  children: [
                    if(userModel.fb!='')
                      Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Image.asset('assets/images/fbIcon.png',height: 25,),
                          )
                      ),
                    if(userModel.instagram!='')
                      Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Image.asset('assets/images/instaIcon.png',height: 25,),
                          )
                      ),
                    if(userModel.mastodon!='')
                      Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: (){

                            },
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: primaryColor,
                              child: Image.asset('assets/images/mastodon_outline.png',height: 13,color: Colors.white,),
                            ),
                          )
                      ),

                    if(userModel.youtube!='')
                      Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: (){

                            },
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: primaryColor,
                              child: Image.asset('assets/images/youtube_outline.png',height: 13,color: Colors.white,),
                            ),
                          )
                      ),
                  ],
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
  Widget followersWeb(){

    return Container(
      //height: (MediaQuery.of(context).size.height*0.065)*snapshot.data!.length,
      height: (MediaQuery.of(context).size.height*0.11)*rows,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.18,right: MediaQuery.of(context).size.width*0.18),
      child: FutureBuilder<List<UserModel>>(
          future: DBApi.getFollowersData(widget.user.userId),
          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(),
              );
            }
            else {
              if (snapshot.hasError) {
                print("error ${snapshot.error}");
                return Container(
                  color: primaryColor,
                  child: Center(
                    child: Text("something went wrong"),
                  ),
                );
              }

              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No Users'),
                );
              }

              else {
                return InteractiveViewer(

                  constrained: false,
                  child: DataTable(

                      columnSpacing: 20,
                      horizontalMargin: 12,
                      columns: [
                        DataColumn(
                          label: Text('Name'),
                        ),

                        DataColumn(
                          label: Text('Phone Number'),
                        ),
                        DataColumn(
                          label: Text('Social Media'),
                        ),



                      ],
                      rows: List<DataRow>.generate(snapshot.data!.length, (index){
                        return DataRow(
                            cells: [

                              DataCell(
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.2,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserProfile(snapshot.data![index])));

                                      },
                                      child: Row(
                                        children: [
                                          ProfilePicture(url: snapshot.data![index].profilePic,height: 40,width: 40,),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                                              Text('${snapshot.data![index].country}, ${snapshot.data![index].city}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  )
                              ),


                              DataCell(
                                  Container(
                                      width: MediaQuery.of(context).size.width*0.14,
                                      child: Text(snapshot.data![index].phone)
                                  )

                              ),
                              DataCell(
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.14,
                                    child: Row(
                                      children: [
                                        if(snapshot.data![index].fb!='')
                                          Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: InkWell(
                                                onTap: (){

                                                },
                                                child: Image.asset('assets/images/fbIcon.png',height: 25,),
                                              )
                                          ),
                                        if(snapshot.data![index].instagram!='')
                                          Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: InkWell(
                                                onTap: (){

                                                },
                                                child: Image.asset('assets/images/instaIcon.png',height: 25,),
                                              )
                                          ),
                                        if(snapshot.data![index].mastodon!='')
                                          Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: InkWell(
                                                onTap: (){

                                                },
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  backgroundColor: primaryColor,
                                                  child: Image.asset('assets/images/mastodon_outline.png',height: 13,color: Colors.white,),
                                                ),
                                              )
                                          ),

                                        if(snapshot.data![index].youtube!='')
                                          Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: InkWell(
                                                onTap: ()async{
                                                  await launchUrl(Uri.parse('https://www.youtube.com/${snapshot.data![index].youtube}')).then((value){}).onError((error, stackTrace){
                                                    CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.error,
                                                      text: 'Unable to launch https://www.youtube.com/${snapshot.data![index].youtube}. Please check if this is a correct url',
                                                    );
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  backgroundColor: primaryColor,
                                                  child: Image.asset('assets/images/youtube_outline.png',height: 13,color: Colors.white,),
                                                ),
                                              )
                                          ),
                                      ],
                                    ),
                                  )
                              ),



                            ]
                        );
                      })
                  ),
                );


          }
          }
          }
      )
    );
  }

  Widget followedWeb(){

    return Container(
      //height: (MediaQuery.of(context).size.height*0.065)*snapshot.data!.length,
        height: (MediaQuery.of(context).size.height*0.11)*rows,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.18,right: MediaQuery.of(context).size.width*0.18),
        child: FutureBuilder<List<UserModel>>(
            future: DBApi.getUserData(widget.user.following),
            builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                );
              }
              else {
                if (snapshot.hasError) {
                  print("error ${snapshot.error}");
                  return Container(
                    color: primaryColor,
                    child: Center(
                      child: Text("something went wrong"),
                    ),
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No Users'),
                  );
                }

                else {
                  return InteractiveViewer(

                    constrained: false,
                    child: DataTable(

                        columnSpacing: 20,
                        horizontalMargin: 12,
                        columns: [
                          DataColumn(
                            label: Text('Name'),
                          ),

                          DataColumn(
                            label: Text('Phone Number'),
                          ),
                          DataColumn(
                            label: Text('Social Media'),
                          ),



                        ],
                        rows: List<DataRow>.generate(snapshot.data!.length, (index){
                          return DataRow(
                              cells: [

                                DataCell(
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.2,
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserProfile(snapshot.data![index])));

                                        },
                                        child: Row(
                                          children: [
                                            ProfilePicture(url: snapshot.data![index].profilePic,height: 40,width: 40,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                                                Text('${snapshot.data![index].country}, ${snapshot.data![index].city}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),

                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                ),


                                DataCell(
                                    Container(
                                        width: MediaQuery.of(context).size.width*0.14,
                                        child: Text(snapshot.data![index].phone)
                                    )

                                ),
                                DataCell(
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.14,
                                      child: Row(
                                        children: [
                                          if(snapshot.data![index].fb!='')
                                            Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: InkWell(
                                                  onTap: (){

                                                  },
                                                  child: Image.asset('assets/images/fbIcon.png',height: 25,),
                                                )
                                            ),
                                          if(snapshot.data![index].instagram!='')
                                            Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: InkWell(
                                                  onTap: (){

                                                  },
                                                  child: Image.asset('assets/images/instaIcon.png',height: 25,),
                                                )
                                            ),
                                          if(snapshot.data![index].mastodon!='')
                                            Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: InkWell(
                                                  onTap: (){

                                                  },
                                                  child: CircleAvatar(
                                                    radius: 13,
                                                    backgroundColor: primaryColor,
                                                    child: Image.asset('assets/images/mastodon_outline.png',height: 13,color: Colors.white,),
                                                  ),
                                                )
                                            ),

                                          if(snapshot.data![index].youtube!='')
                                            Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: InkWell(
                                                  onTap: ()async{
                                                    await launchUrl(Uri.parse('https://www.youtube.com/${snapshot.data![index].youtube}')).then((value){}).onError((error, stackTrace){
                                                      CoolAlert.show(
                                                        context: context,
                                                        type: CoolAlertType.error,
                                                        text: 'Unable to launch https://www.youtube.com/${snapshot.data![index].youtube}. Please check if this is a correct url',
                                                      );
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 13,
                                                    backgroundColor: primaryColor,
                                                    child: Image.asset('assets/images/youtube_outline.png',height: 13,color: Colors.white,),
                                                  ),
                                                )
                                            ),
                                        ],
                                      ),
                                    )
                                ),



                              ]
                          );
                        })
                    ),
                  );


                }
              }
            }
        )
    );
  }
}
