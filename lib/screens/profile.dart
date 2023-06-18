import 'package:directory_app/screens/search_screen.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top:10,right: 10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SearchScreen()));

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
                        child:  Text(' Find Contacts ',style: TextStyle(),)
                      ),
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Followers: 261',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                SizedBox(width: 20,),
                Text('Followed: 158',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
              ],
            ),
            Center(
              child: Container(
                width: Responsive.getProfileScreenWidth(context),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                              },
                              child: Container(
                                height: 50,


                                decoration: BoxDecoration(
                                    color: lightColor,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/report.png',height: 15,),
                                    SizedBox(width: 10,),
                                    Text('Send Code',style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                              },
                              child: Container(
                                height: 50,


                                decoration: BoxDecoration(
                                    color: lightColor,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/share.png',height: 15,),
                                    SizedBox(width: 10,),
                                    Text('Share',style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));

                              },
                              child: Container(
                                height: 50,


                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/add.png',height: 15,color: Colors.white),
                                    SizedBox(width: 10,),
                                    Text('Follow',style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(!Responsive.isMobile(context))
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Image.asset('assets/images/qr.png',height: 100,),
                      ),
                    Padding(
                        padding: EdgeInsets.only(top: 20,bottom: 10),
                        child: Center(child: Text('Emails',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                    ),
                    Container(
                      height: 50,


                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text('Anika@Levin.com',style: TextStyle(color: primaryColor),)
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20,bottom: 10),
                        child: Center(child: Text('Phone numbers',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                    ),
                    Container(
                      height: 50,


                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/flag.png',height: 15,),
                          SizedBox(width: 10,),
                          Text('+1 123 456 798',style: TextStyle(color: primaryColor),)
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20,bottom: 10),
                        child: Center(child: Text('Links',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                    ),
                    Container(
                      height: 50,


                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/linkIcon.png',height: 15,),
                          SizedBox(width: 10,),
                          Text('www.Levin.com',style: TextStyle(color: primaryColor),)
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20,bottom: 10),
                        child: Center(child: Text('Social media',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                    ),
                    Container(
                      height: 50,


                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/instaUser.png',height: 15,),
                          SizedBox(width: 10,),
                          Text('@AnikaLevin1234',style: TextStyle(color: primaryColor),)
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 50,


                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/fbUser.png',height: 15,),
                          SizedBox(width: 10,),
                          Text('@AnikaLevin1234 ',style: TextStyle(color: primaryColor),)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    if(Responsive.isMobile(context))
                      Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Image.asset('assets/images/qr.png',height: 100,),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
