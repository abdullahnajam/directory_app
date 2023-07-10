import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/user_profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/database_api.dart';
import '../model/user_model.dart';

class FollowUserScreen extends StatefulWidget {
  List userIds;


  FollowUserScreen(this.userIds);

  @override
  State<FollowUserScreen> createState() => _FollowUserScreenState();
}

class _FollowUserScreenState extends State<FollowUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: maxWidth
            ),
            child: ListView(
              children: [
                CustomAppBar(showSearchBar: true,),

                Center(
                  child: Container(
                    width: Responsive.getWidth(context),
                    child: FutureBuilder<List<UserModel>>(
                        future: DBApi.getUserData(widget.userIds),
                        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              alignment: Alignment.center,
                              child: const CupertinoActivityIndicator(),
                            );
                          }
                          else {
                            if (snapshot.hasError) {
                              print("error ${snapshot.error}");
                              return Container(
                                color: primaryColor,
                                child: const Center(
                                  child: Text("something went wrong"),
                                ),
                              );
                            }

                            if (snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No Users'),
                              );
                            }

                            else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index){
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserProfile(snapshot.data![index])));

                                      },
                                      child: Card(
                                        color: Colors.grey[100],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        child:Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: ProfilePicture(url: snapshot.data![index].profilePic,height: 70,width: 70,),
                                            ),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}',style: const TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                                                  Text('${snapshot.data![index].city}, ${snapshot.data![index].country}',style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),
                                                ],
                                              ),
                                            ),
                                            Consumer<UserDataProvider>(
                                              builder: (context, provider, child) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: (){
                                                      if(provider.userData!.following.contains(snapshot.data![index].userId)){
                                                        provider.unFollowUser(snapshot.data![index].userId);
                                                      }
                                                      else{
                                                        provider.followUser(snapshot.data![index].userId);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.all(10),

                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius: BorderRadius.circular(7)
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          if(!Responsive.isMobile(context) && !provider.userData!.following.contains(snapshot.data![index].userId))
                                                            Image.asset('assets/images/add.png',height: 15,color: Colors.white),
                                                          if(!Responsive.isMobile(context) && !provider.userData!.following.contains(snapshot.data![index].userId))
                                                            const SizedBox(width: 10,),
                                                          Text(provider.userData!.following.contains(snapshot.data![index].userId)?'Unfollow':'Follow',style: const TextStyle(color: Colors.white),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                            }
                          }
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget searchUI(){
    return const Column(
      children: [
        /*Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const UserProfile()));

            },
            child: Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child:Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/profile.png',height: 70,),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                        Text('Australia, Melbourne',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(7)
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(!Responsive.isMobile(context))
                              Image.asset('assets/images/add.png',height: 15,color: Colors.white),
                            if(!Responsive.isMobile(context))
                              SizedBox(width: 10,),
                            Text('Follow',style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const UserProfile()));

            },
            child: Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child:Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/profile.png',height: 70,),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                        Text('Australia, Melbourne',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(7)
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(!Responsive.isMobile(context))
                              Image.asset('assets/images/add.png',height: 15,color: Colors.white),
                            if(!Responsive.isMobile(context))
                              SizedBox(width: 10,),
                            Text('Follow',style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const UserProfile()));

            },
            child: Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child:Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assets/images/profile.png',height: 70,),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 18)),
                              Text('Australia, Melbourne',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 15)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(!Responsive.isMobile(context))
                                    Image.asset('assets/images/add.png',height: 15,color: Colors.white),
                                  if(!Responsive.isMobile(context))
                                    SizedBox(width: 10,),
                                  Text('Follow',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('  Social media',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                        ListTile(
                          leading: Image.asset('assets/images/fbUser.png',height: 40,),
                          title: Text('Olivia Star',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w300,fontSize: 15)),
                          subtitle: Text('@olivia1234',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 14)),

                        )
                      ],
                    )
                  ],
                )
            ),
          ),
        )*/
      ],
    );
  }
}
