import 'package:directory_app/screens/user_profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:ListView(
          children: [
            CustomAppBar(showSearchBar: true,),

            Padding(
              padding: Responsive.isMobile(context)?EdgeInsets.all(10):EdgeInsets.fromLTRB(40,20,40,20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Search: \"Olivia Star\"',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25)),
                  if(!Responsive.isMobile(context))
                    Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' Location',style: TextStyle(fontWeight: FontWeight.w400)),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Location',style: TextStyle(fontWeight: FontWeight.w400)),

                                  Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' Social Media',style: TextStyle(fontWeight: FontWeight.w400)),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Social Media',style: TextStyle(fontWeight: FontWeight.w400)),

                                  Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),

                ],
              ),
            ),
            Center(
              child: Container(
                width: Responsive.getWidth(context),
                child: Column(
                  children: [
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
