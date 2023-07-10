import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:directory_app/model/user_model.dart';
import 'package:directory_app/screens/search_screen.dart';
import 'package:directory_app/screens/user_profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:directory_app/widgets/custom_dailogs.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:directory_app/widgets/qr_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/database_api.dart';
import '../provider/user_provider.dart';
import '../widgets/social_icon.dart';

class ProfileScreen extends StatefulWidget {
  String userId;


  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: maxWidth
            ),
            child: ListView(
              children: [
                CustomAppBar(showSearchBar: true,),
                FutureBuilder<UserModel?>(
                    future: DBApi.getUserDetails(widget.userId),
                    builder: (context, AsyncSnapshot<UserModel?> usersnap) {
                      if (usersnap.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      else {
                        if (usersnap.hasError) {
                          print("error ${usersnap.error}");
                          return Container(
                            color: primaryColor,
                            child: Center(
                              child: Text("something went wrong"),
                            ),
                          );
                        }

                        if (usersnap.data==null) {
                          print("error ${usersnap.error}");
                          return Container(
                            child: Center(
                              child: Text("something went wrong"),
                            ),
                          );
                        }



                        else {
                          return Column(
                            children: [
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
                                      child: ProfilePicture(url: usersnap.data!.profilePic,height: 100,width: 100,),
                                    ),
                                  ),
                                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top:10,right: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  UserProfile(usersnap.data!)));

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
                                  child: Center(child: Text('${usersnap.data!.firstName} ${usersnap.data!.lastName}',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),))
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Center(child: Text('${usersnap.data!.country}, ${usersnap.data!.city}',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),))
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<List<UserModel>>(
                                      future: DBApi.getFollowersData(usersnap.data!.userId),
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
                                            return Text('Followers: 0',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),);
                                          }

                                          else {
                                            return InkWell(
                                              onTap: (){
                                                List ids=[];
                                                for(int i=0;i<snapshot.data!.length;i++){
                                                  ids.add(snapshot.data![i].userId);
                                                }
                                                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FollowUserScreen(ids)));

                                              },
                                              child: Text('Followers: ${snapshot.data!.length}',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                                            );

                                          }
                                        }
                                      }
                                  ),
                                  SizedBox(width: 20,),
                                  Text('Followed: ${usersnap.data!.following.length}',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
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
                                                  showReportDialog(context);

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
                                                      Text('Report',style: TextStyle(color: primaryColor),)
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
                                                onTap: ()async{
                                                  String domain=await DBApi.getWebDomain();
                                                  Share.share('$domain/${widget.userId}');
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
                                          if(FirebaseAuth.instance.currentUser!=null)
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Consumer<UserDataProvider>(
                                                  builder: (context, provider, child) {
                                                    return InkWell(
                                                      onTap: (){
                                                        if(provider.userData!.following.contains(usersnap.data!.userId)){
                                                          provider.unFollowUser(usersnap.data!.userId);
                                                        }
                                                        else{
                                                          provider.followUser(usersnap.data!.userId);
                                                        }

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
                                                            if(!Responsive.isMobile(context) && !provider.userData!.following.contains(usersnap.data!.userId))
                                                              Image.asset('assets/images/add.png',height: 15,color: Colors.white),
                                                            if(!Responsive.isMobile(context) && !provider.userData!.following.contains(usersnap.data!.userId))
                                                              SizedBox(width: 10,),
                                                            Text(provider.userData!.following.contains(usersnap.data!.userId)?'Unfollow':'Follow',style: TextStyle(color: Colors.white),)

                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),

                                        QRWidget(qrCode: usersnap.data!.userId),
                                      Padding(
                                          padding: EdgeInsets.only(top: 20,bottom: 10),
                                          child: Center(child: Text('Emails',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('users').doc(usersnap.data!.userId)
                                            .collection('emails').where('visibility',isNotEqualTo:'No').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Column(
                                                children: [
                                                  const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                ],
                                              ),
                                            );
                                          }

                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.data!.size==0){
                                            return Container(
                                              height: 50,


                                              decoration: BoxDecoration(
                                                  color: lightColor,
                                                  borderRadius: BorderRadius.circular(7)
                                              ),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  /*Image.asset('assets/images/flag.png',height: 15,),
                                            const SizedBox(width: 10,),*/
                                                  Text('No Emails',style: TextStyle(color: primaryColor),)
                                                ],
                                              ),
                                            );

                                          }

                                          return ListView(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                              if(data['name']==null){
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
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
                                                          /*Image.asset('assets/images/flag.png',height: 15,),
                                                const SizedBox(width: 10,),*/
                                                          Text('No Emails',style: TextStyle(color: primaryColor),)
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    InkWell(
                                                      onTap: (){
                                                        showAddEmailDialog(context);
                                                      },
                                                      child: const Text('+ Add email',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500)),
                                                    ),
                                                  ],
                                                );
                                              }
                                              else{
                                                if(data['visibility']=='People I follow'){
                                                  if(FirebaseAuth.instance.currentUser!=null){
                                                    if(usersnap.data!.following.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                      return InkWell(
                                                        onTap: ()async{



                                                          if(kIsWeb){
                                                            FlutterClipboard.copy(data['name']).then(( value ){
                                                              Fluttertoast.showToast(
                                                                  msg: "Email Copied",
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.red,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            });

                                                          }
                                                          else{
                                                            final mailtoLink = Mailto(
                                                              to: [data['name']],
                                                              subject: '',
                                                              body: '',
                                                            );
                                                            // Convert the Mailto instance into a string.
                                                            // Use either Dart's string interpolation
                                                            // or the toString() method.
                                                            await launch('$mailtoLink');
                                                          }

                                                          /* String? encodeQueryParameters(Map<String, String> params) {
                                                    return params.entries
                                                        .map((MapEntry<String, String> e) =>
                                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                        .join('&');
                                                  }
// ···
                                                  final Uri emailLaunchUri = Uri(
                                                    scheme: 'mailto',
                                                    path: data['name'],
                                                    query: encodeQueryParameters(<String, String>{
                                                      'subject': 'Example Subject & Symbols are allowed!',
                                                    }),
                                                  );

                                                  launchUrl(emailLaunchUri);*/

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

                                                              Text(data['name'],style: TextStyle(color: primaryColor),)
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    else{
                                                      return InkWell(
                                                        onTap: ()async{



                                                          if(kIsWeb){
                                                            FlutterClipboard.copy(data['name']).then(( value ){
                                                              Fluttertoast.showToast(
                                                                  msg: "Email Copied",
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.red,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            });

                                                          }
                                                          else{
                                                            final mailtoLink = Mailto(
                                                              to: [data['name']],
                                                              subject: '',
                                                              body: '',
                                                            );
                                                            // Convert the Mailto instance into a string.
                                                            // Use either Dart's string interpolation
                                                            // or the toString() method.
                                                            await launch('$mailtoLink');
                                                          }

                                                          /* String? encodeQueryParameters(Map<String, String> params) {
                                                    return params.entries
                                                        .map((MapEntry<String, String> e) =>
                                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                        .join('&');
                                                  }
// ···
                                                  final Uri emailLaunchUri = Uri(
                                                    scheme: 'mailto',
                                                    path: data['name'],
                                                    query: encodeQueryParameters(<String, String>{
                                                      'subject': 'Example Subject & Symbols are allowed!',
                                                    }),
                                                  );

                                                  launchUrl(emailLaunchUri);*/

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

                                                              Text(data['name'],style: TextStyle(color: primaryColor),)
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  else{
                                                    return hidden();
                                                  }


                                                }
                                                else{
                                                  return InkWell(
                                                    onTap: ()async{



                                                      if(kIsWeb){
                                                        FlutterClipboard.copy(data['name']).then(( value ){
                                                          Fluttertoast.showToast(
                                                              msg: "Email Copied",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.red,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0
                                                          );
                                                        });

                                                      }
                                                      else{
                                                        final mailtoLink = Mailto(
                                                          to: [data['name']],
                                                          subject: '',
                                                          body: '',
                                                        );
                                                        // Convert the Mailto instance into a string.
                                                        // Use either Dart's string interpolation
                                                        // or the toString() method.
                                                        await launch('$mailtoLink');
                                                      }

                                                      /* String? encodeQueryParameters(Map<String, String> params) {
                                                    return params.entries
                                                        .map((MapEntry<String, String> e) =>
                                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                        .join('&');
                                                  }
// ···
                                                  final Uri emailLaunchUri = Uri(
                                                    scheme: 'mailto',
                                                    path: data['name'],
                                                    query: encodeQueryParameters(<String, String>{
                                                      'subject': 'Example Subject & Symbols are allowed!',
                                                    }),
                                                  );

                                                  launchUrl(emailLaunchUri);*/

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

                                                          Text(data['name'],style: TextStyle(color: primaryColor),)
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }).toList(),
                                          );
                                        },
                                      ),

                                      Padding(
                                          padding: EdgeInsets.only(top: 20,bottom: 10),
                                          child: Center(child: Text('Phone numbers',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                                      ),
                                      InkWell(
                                        onTap: (){
                                          launchUrl(Uri.parse("tel://${usersnap.data!.phone}"));
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
                                              /*Image.asset('assets/images/flag.png',height: 15,),
                                              const SizedBox(width: 10,),*/
                                              Text(usersnap.data!.phone,style: TextStyle(color: primaryColor),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('users').doc(usersnap.data!.userId)
                                            .collection('phone').where('visibility',isNotEqualTo:'No').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Column(
                                                children: [
                                                  const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                ],
                                              ),
                                            );
                                          }

                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }


                                          return ListView(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                              if(data['visibility']=='People I follow'){
                                                if(FirebaseAuth.instance.currentUser!=null){
                                                  if(usersnap.data!.following.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                    return InkWell(
                                                      onTap: (){
                                                        launchUrl(Uri.parse("tel://${data['name']}"));
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
                                                            /*Image.asset('assets/images/flag.png',height: 15,),
                                                const SizedBox(width: 10,),*/
                                                            Text(data['name'],style: TextStyle(color: primaryColor),)
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  else{
                                                    return InkWell(
                                                      onTap: (){
                                                        launchUrl(Uri.parse("tel://${data['name']}"));
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
                                                            /*Image.asset('assets/images/flag.png',height: 15,),
                                                const SizedBox(width: 10,),*/
                                                            Text(data['name'],style: TextStyle(color: primaryColor),)
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                                else{
                                                  return hidden();
                                                }


                                              }
                                              else{
                                                return InkWell(
                                                  onTap: (){
                                                    launchUrl(Uri.parse("tel://${data['name']}"));
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
                                                        /*Image.asset('assets/images/flag.png',height: 15,),
                                                const SizedBox(width: 10,),*/
                                                        Text(data['name'],style: TextStyle(color: primaryColor),)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }


                                            }).toList(),
                                          );
                                        },
                                      ),

                                      Padding(
                                          padding: EdgeInsets.only(top: 20,bottom: 10),
                                          child: Center(child: Text('Links',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('users').doc(usersnap.data!.userId)
                                            .collection('links').where('visibility',isNotEqualTo:'No').snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Column(
                                                children: [
                                                  const Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                ],
                                              ),
                                            );
                                          }

                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.data!.size==0){
                                            return Container(
                                              height: 50,


                                              decoration: BoxDecoration(
                                                  color: lightColor,
                                                  borderRadius: BorderRadius.circular(7)
                                              ),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  /*Image.asset('assets/images/flag.png',height: 15,),
                                            const SizedBox(width: 10,),*/
                                                  Text('No Links',style: TextStyle(color: primaryColor),)
                                                ],
                                              ),
                                            );

                                          }

                                          return ListView(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                              if(data['visibility']=='People I follow'){
                                                if(FirebaseAuth.instance.currentUser!=null){
                                                  if(usersnap.data!.following.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                    return InkWell(
                                                      onTap: ()async{

                                                        await launchUrl(Uri.parse(data['name'])).then((value){}).onError((error, stackTrace){
                                                          CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.error,
                                                            text: 'Unable to launch ${data['name']}. Please check if this is a correct url',
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        margin: EdgeInsets.only(bottom: 5),


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
                                                            Text(data['name'],style: TextStyle(color: primaryColor),)
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  else{
                                                    return InkWell(
                                                      onTap: ()async{

                                                        await launchUrl(Uri.parse(data['name'])).then((value){}).onError((error, stackTrace){
                                                          CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.error,
                                                            text: 'Unable to launch ${data['name']}. Please check if this is a correct url',
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        margin: EdgeInsets.only(bottom: 5),


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
                                                            Text(data['name'],style: TextStyle(color: primaryColor),)
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                                else{
                                                  return hidden();
                                                }


                                              }
                                              else{
                                                return InkWell(
                                                  onTap: ()async{

                                                    await launchUrl(Uri.parse(data['name'])).then((value){}).onError((error, stackTrace){
                                                      CoolAlert.show(
                                                        context: context,
                                                        type: CoolAlertType.error,
                                                        text: 'Unable to launch ${data['name']}. Please check if this is a correct url',
                                                      );
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    margin: EdgeInsets.only(bottom: 5),


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
                                                        Text(data['name'],style: TextStyle(color: primaryColor),)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            }).toList(),
                                          );
                                        },
                                      ),

                                      Padding(
                                          padding: EdgeInsets.only(top: 20,bottom: 10),
                                          child: Center(child: Text('Social media',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                                      ),
                                      if(usersnap.data!.fb!='')
                                        InkWell(
                                          onTap: ()async{

                                            await launchUrl(Uri.parse(usersnap.data!.fb)).then((value){}).onError((error, stackTrace){
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: 'Unable to launch ${usersnap.data!.fb}. Please check if this is a correct url',
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                                color: lightColor,
                                                borderRadius: BorderRadius.circular(7)
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SocialIcon(name: 'facebook_outline', url: usersnap.data!.profilePic),
                                                const SizedBox(width: 10,),
                                                Text(usersnap.data!.fb,style: TextStyle(color: primaryColor),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      if(usersnap.data!.instagram!='')
                                        InkWell(
                                          onTap: ()async{

                                            await launchUrl(Uri.parse(usersnap.data!.instagram)).then((value){}).onError((error, stackTrace){
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: 'Unable to launch ${usersnap.data!.instagram}. Please check if this is a correct url',
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(bottom: 10),

                                            decoration: BoxDecoration(
                                                color: lightColor,
                                                borderRadius: BorderRadius.circular(7)
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SocialIcon(name: 'instagram_outline', url: usersnap.data!.profilePic),
                                                const SizedBox(width: 10,),
                                                Text(usersnap.data!.instagram,style: TextStyle(color: primaryColor),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      if(usersnap.data!.mastodon!='')
                                        InkWell(
                                          onTap: ()async{

                                            await launchUrl(Uri.parse(usersnap.data!.mastodon)).then((value){}).onError((error, stackTrace){
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: 'Unable to launch ${usersnap.data!.mastodon}. Please check if this is a correct url',
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(bottom: 10),

                                            decoration: BoxDecoration(
                                                color: lightColor,
                                                borderRadius: BorderRadius.circular(7)
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SocialIcon(name: 'mastodon_outline', url: usersnap.data!.profilePic),
                                                const SizedBox(width: 10,),
                                                Text(usersnap.data!.mastodon,style: TextStyle(color: primaryColor),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      if(usersnap.data!.youtube!='')
                                        InkWell(
                                          onTap: ()async{

                                            await launchUrl(Uri.parse('https://www.youtube.com/${usersnap.data!.youtube}')).then((value){}).onError((error, stackTrace){
                                              CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: 'Unable to launch https://www.youtube.com/${usersnap.data!.youtube}. Please check if this is a correct url',
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 50,

                                            margin: EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                                color: lightColor,
                                                borderRadius: BorderRadius.circular(7)
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SocialIcon(name: 'youtube_outline', url: usersnap.data!.profilePic),
                                                const SizedBox(width: 10,),
                                                Text(usersnap.data!.youtube,style: TextStyle(color: primaryColor),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 20,),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );

                        }
                      }
                    }
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget hidden(){
    return Container(
      height: 50,


      decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(7)
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*Image.asset('assets/images/flag.png',height: 15,),
                                        const SizedBox(width: 10,),*/
          Text('Hidden by user',style: TextStyle(color: primaryColor),)
        ],
      ),
    );
  }
}
