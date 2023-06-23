import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/search_screen.dart';
import 'package:directory_app/widgets/custom_dailogs.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/image_api.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/custom_appbar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  Future imageModalBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: Text('Upload Picture'),
                    onTap: () => {
                      ImageHandler.chooseGallery().then((value) async{
                        if(value!=null){
                          print("not null");
                          String imageUrl=await ImageHandler.uploadImageToFirebase(context, value);
                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                            'profilePic':imageUrl
                          });
                          final provider = Provider.of<UserDataProvider>(context, listen: false);
                          provider.setImage(imageUrl);
                          setState(() {
                            print(imageUrl);

                          });

                        }
                        Navigator.pop(context);
                      })
                    }),
                if(!kIsWeb)
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text('Take a photo'),
                  onTap: () => {
                    ImageHandler.chooseCamera().then((value) async{
                      if(value!=null){
                        String imageUrl=await ImageHandler.uploadImageToFirebase(context, value);

                        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                          'profilePic':imageUrl
                        });
                        final provider = Provider.of<UserDataProvider>(context, listen: false);
                        provider.setImage(imageUrl);
                        setState(() {

                        });
                      }

                      Navigator.pop(context);
                    })
                  },
                ),
              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Consumer<UserDataProvider>(
          builder: (context, provider, child) {
            return ListView(
              children: [
                CustomAppBar(showSearchBar: true,),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      width: MediaQuery.of(context).size.width,
                      color: primaryColor,
                    ),
                    Stack(
                      children: [
                        Center(
                          child: Padding(
                              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
                              child: ProfilePicture(url: provider.userData!.profilePic,height: 100,width: 100,)
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: (){
                                imageModalBottomSheet(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.13),
                                child: Image.asset('assets/images/camera.png',height: 50,),
                              ),
                            )
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top:10,right: 10),
                        child: InkWell(
                          onTap: (){
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SearchScreen()));

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
                              child:  const Text(' Find Contacts ',style: TextStyle(),)
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(child: Text('${provider.userData!.firstName} ${provider.userData!.lastName}',style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 25),))
                ),
                if(provider.userData!.city=="" && provider.userData!.city=="")
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: InkWell(
                        onTap: (){
                          showAddCityCountryDialog(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add your city/country',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                            SizedBox(width: 10,),
                            Icon(Icons.edit,color: primaryColor,size: 15,)
                          ],
                        ),
                      )
                  )
                else
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(child: Text('${provider.userData!.city}, ${provider.userData!.country}',style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 15),))
                  ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Followers: 261',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                    const SizedBox(width: 20,),
                    Text('Followed: ${provider.userData!.following.length}',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                  ],
                ),
                Center(
                  child: Container(
                    width: Responsive.getProfileScreenWidth(context),
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      physics: const NeverScrollableScrollPhysics(),
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
                                        const SizedBox(width: 10,),
                                        const Text('Send Code',style: TextStyle(color: primaryColor),)
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
                                        const SizedBox(width: 10,),
                                        const Text('Share',style: TextStyle(color: primaryColor),)
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
                                        const SizedBox(width: 10,),
                                        const Text('Follow',style: TextStyle(color: Colors.white),)
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
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Image.asset('assets/images/qr.png',height: 100,),
                          ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Center(child: Text('Emails',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('emails').snapshots(),
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

                                return Row(
                                  children: [
                                    Expanded(
                                      child:  Container(
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
                                    ),

                                      Row(
                                        children: [
                                          const SizedBox(width: 10,),
                                          const Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                        ],
                                      )
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),

                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            showAddEmailDialog(context);
                          },
                          child: const Text('+ Add email',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500)),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Center(child: Text('Phone numbers',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('phone').snapshots(),
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
                                    Text('No Phone Numbers',style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              );

                            }

                            return ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:  Container(
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
                                      ),
                                      if(data['name']!=provider.userData!.phone)
                                        Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            const Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                          ],
                                        )
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),



                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            showAddPhoneDialog(context);
                          },
                          child: const Text('+ Add phone number',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500)),
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Center(child: Text('Links',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('links').snapshots(),
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

                                return Row(
                                  children: [
                                    Expanded(
                                      child:  Container(
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
                                            const SizedBox(width: 10,),
                                            const Text('www.Levin.com',style: TextStyle(color: primaryColor),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),


                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            showAddLinkDialog(context);
                          },
                          child: const Text('+ Add link',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500)),
                        ),

                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child: Center(child: Text('Social media',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                        ),
                        if(provider.userData!.instagram=="")
                          Container(
                            height: 50,


                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(7)
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/instagram.png',height: 15,),
                                const SizedBox(width: 10,),
                                const Text('Connect with Instagram',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                              ],
                            ),
                          )
                        else
                          Row(
                          children: [
                            Expanded(
                              child:  Container(
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
                                    const SizedBox(width: 10,),
                                    const Text('@AnikaLevin1234',style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Text('Disconnect',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                          ],
                        ),

                        const SizedBox(height: 10,),
                        if(provider.userData!.fb=="")
                          Container(
                            height: 50,


                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(7)
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/fb.png',height: 15,),
                                const SizedBox(width: 10,),
                                const Text('Connect with facebook',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                              ],
                            ),
                          )
                        else
                          Row(
                          children: [
                            Expanded(
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
                                    Image.asset('assets/images/fbUser.png',height: 15,),
                                    const SizedBox(width: 10,),
                                    const Text('@AnikaLevin1234 ',style: TextStyle(color: primaryColor),)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Text('Disconnect',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 50,


                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/mastedon.png',height: 15,),
                              const SizedBox(width: 10,),
                              const Text('Connect with Mastodon',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 50,


                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/wallet.png',height: 15,),
                              const SizedBox(width: 10,),
                              const Text('Connect with Wallet',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 50,


                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/youtube.png',height: 15,),
                              const SizedBox(width: 10,),
                              const Text('Connect with youtube',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),

                        const SizedBox(height: 20,),
                        if(Responsive.isMobile(context))
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(30),
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
            );
          },
        ),
      ),
    );
  }
}
