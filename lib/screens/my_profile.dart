import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/follow_users_screen.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/search_screen.dart';
import 'package:directory_app/widgets/custom_dailogs.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:directory_app/widgets/qr_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../api/auth_api.dart';
import '../api/database_api.dart';
import '../api/image_api.dart';
import '../model/user_model.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/social_icon.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Stream<User?> authStream = FirebaseAuth.instance.authStateChanges();
    authStream.listen((User? user) async{
      if (user != null) {
        print('current email ${user.email} ${user.emailVerified}');
        if (user.emailVerified) {

          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('emails').doc(FirebaseAuth.instance.currentUser!.uid).update({
            'name':user.email,
          });
          //Navigator.pop(context);
        }
      }
    });
  }
  static const String mastodonInstance = 'https://mastodon.social';

  Future<void> _login() async {
    final String redirectUri = 'urn:ietf:wg:oauth:2.0:oob';
    final String clientId = 'gejvTVCozBrtA6pXDwnTBZSUrkv-KbdNvoZTIwe1eKQ';

    final String authUrl =
        '$mastodonInstance/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=read';
    print(authUrl);
    final String result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: redirectUri,
    );
    /*final http.Response authres = await http.get(Uri.parse(authUrl));

    if(authres.statusCode==200){

    }
    else{
      print(authres.body);
    }*/


    final Map<String, String> authData = {
      'client_id': clientId,
      'client_secret': '_DOaKYWnzSCtZNNGnvgGVZZDuVWHhwP2wDPICJ-5WJk',
      'redirect_uri': redirectUri,
      'grant_type': 'authorization_code',
      //'code': Uri.parse(result).queryParameters['code']!,
    };

    final Uri tokenUri = Uri.parse('$mastodonInstance/oauth/token');
    final http.Response response = await http.post(tokenUri, body: authData);

    if (response.statusCode == 200) {
      final String accessToken = response.body;

      final Uri accountUri = Uri.parse('$mastodonInstance/api/v1/accounts/verify_credentials');
      final http.Response accountResponse =
      await http.get(accountUri, headers: {'Authorization': 'Bearer $accessToken'});

      if (accountResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(accountResponse.body);
        final String userHandle = userData['username'];
        // Use the user handle as needed
        print('User Handle: $userHandle');
      } else {
        print('Failed to retrieve user information');
      }
    } else {
      print('Authentication failed');
    }
  }
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
                          if(kIsWeb){
                            print("not null");
                            Uint8List imageData = await XFile(value.path).readAsBytes();
                            String imageUrl=await ImageHandler.uploadImageFromWeb(context, imageData);
                            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                              'profilePic':imageUrl
                            });
                            final provider = Provider.of<UserDataProvider>(context, listen: false);
                            provider.setImage(imageUrl);
                            setState(() {
                              print(imageUrl);

                            });
                          }
                          else{
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: maxWidth
            ),
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
                        /*if(!kIsWeb)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top:10,right: 10),
                            child: InkWell(
                              onTap: ()async{
                                final ProgressDialog pr = ProgressDialog(context: context);
                                pr.show(max: 100, msg: 'Syncing Contacts',barrierDismissible: true);
                                List<Contact> contacts = await ContactsService.getContacts();
                                List<UserModel> users=[];
                                List<String> invites=[];

                                for(int i=0;i<contacts.length;i++){
                                  for(int j=0;j<contacts[i].phones!.length;j++){
                                    await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                        UserModel model=UserModel.fromMap(data, doc.reference.id);
                                        if(contacts[i].phones![j].value!.isNotEmpty){
                                          if(contacts[i].phones![j].value![0]=='0'){
                                            String phone=contacts[i].phones![j].value!;
                                            String formattedNumber = phone.replaceAll(" ", "").replaceFirst("0", "");

                                            print('${model.phone} $formattedNumber');
                                            if(model.phone.contains(formattedNumber)){
                                              print('contains');
                                              bool exists=false;
                                              users.add(model);
                                              print('user l ${users.length}');
                                              users.forEach((element) {
                                                if(element.userId==model.userId){
                                                  exists==true;
                                                }
                                              });
                                              if(!exists){
                                                users.add(model);
                                              }

                                            }
                                            else{
                                              invites.add('0$formattedNumber');
                                            }
                                          }
                                        }

                                      });
                                    });
                                  }

                                }
                                pr.close();
                                print('g');
                                if(users.isEmpty){
                                  List<String> uniqueInvites = invites.toSet().toList();
                                  showInviteContantsDialog(context, uniqueInvites);
                                }
                                else{
                                  List<String> uniqueInvites = invites.toSet().toList();
                                  List<UserModel> uniquePersons = users.toSet().toList();
                                  showAvailableContactsDialog(context, uniquePersons,uniqueInvites);
                                }



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
                        ),*/

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
                      InkWell(
                        onTap: (){
                          showAddCityCountryDialog(context);
                        },
                        child:Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Center(child: Text('${provider.userData!.city}, ${provider.userData!.country}',style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 15),))
                        ),
                      ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<List<UserModel>>(
                            future: DBApi.getFollowersData(FirebaseAuth.instance.currentUser!.uid),
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
                                  return InkWell(
                                    onTap: (){
                                      List ids=[];
                                      for(int i=0;i<snapshot.data!.length;i++){
                                        ids.add(snapshot.data![i].userId);
                                      }
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FollowUserScreen(ids)));

                                    },
                                    child: Text('Followers: 0',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                                  );
                                }

                                else {
                                  return InkWell(
                                    onTap: (){
                                      List ids=[];
                                      for(int i=0;i<snapshot.data!.length;i++){
                                        ids.add(snapshot.data![i].userId);
                                      }
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FollowUserScreen(ids)));

                                    },
                                    child: Text('Followers: ${snapshot.data!.length}',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                                  );

                                }
                              }
                            }
                        ),
                        const SizedBox(width: 20,),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FollowUserScreen(provider.userData!.following)));
                          },
                          child: Text('Following: ${provider.userData!.following.length}',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
                        )
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
                                      onTap: ()async{
                                        String domain=await DBApi.getWebDomain();
                                        Share.share('$domain/${FirebaseAuth.instance.currentUser!.uid}');
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
                              ],
                            ),

                              QRWidget(qrCode: FirebaseAuth.instance.currentUser!.uid),
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

                                      return Row(
                                        children: [
                                          Expanded(
                                            child:  InkWell(
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
                                                    /*Image.asset('assets/images/flag.png',height: 15,),
                                                  const SizedBox(width: 10,),*/
                                                    Text(data['name'],style: TextStyle(color: primaryColor),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          Row(
                                            children: [
                                              const SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  showEditEmailDialog(context, data['name'],data['visibility']);
                                                },
                                                child: Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }

                                  }).toList(),
                                );
                              },
                            ),


                            const Padding(
                                padding: EdgeInsets.only(top: 20,bottom: 10),
                                child: Center(child: Text('Phone numbers',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                            ),


                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child:  InkWell(
                                      onTap: (){
                                        launchUrl(Uri.parse("tel://${provider.userData!.phone}"));
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
                                            Text(provider.userData!.phone,style: TextStyle(color: primaryColor),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                    Row(
                                      children: [
                                        const SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                            showEditMainPhoneDialog(context, provider.userData!.phone);
                                          },
                                          child: Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                        )
                                      ],
                                    )
                                ],
                              ),
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
                                            child:  InkWell(
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
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  Map<String,dynamic> phoneData={
                                                    'id':document.reference.id,
                                                    'name':data['name'],
                                                    'visibility':data['visibility'],
                                                  };
                                                  showEditPhoneDialog(context, phoneData);
                                                },
                                                child: Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                              )
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

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:  InkWell(
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
                                                    Expanded(
                                                      child: Text(data['name'],style: TextStyle(color: primaryColor),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          InkWell(
                                            onTap: (){
                                              showEditLinkDialog(context, data['name'], document.reference.id);
                                            },
                                            child:  const Text('Edit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
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
                                showAddLinkDialog(context);
                              },
                              child: const Text('+ Add link',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500)),
                            ),

                            const Padding(
                                padding: EdgeInsets.only(top: 20,bottom: 10),
                                child: Center(child: Text('Social media',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),))
                            ),
                            if(provider.userData!.instagram=="")
                              InkWell(
                                onTap: (){
                                  showAddSocialMediaDialog(context, 1, 'Instagram');
                                },
                                child: Container(
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
                                ),
                              )
                            else
                              Row(
                              children: [
                                Expanded(
                                  child:  InkWell(
                                    onTap: ()async{

                                      await launchUrl(Uri.parse(provider.userData!.instagram)).then((value){}).onError((error, stackTrace){
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: 'Unable to launch ${provider.userData!.instagram}. Please check if this is a correct url',
                                        );
                                      });
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
                                          SocialIcon(url: provider.userData!.profilePic,name: 'instagram_outline',),
                                          const SizedBox(width: 10,),
                                          Text(provider.userData!.instagram,style: TextStyle(color: primaryColor),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                InkWell(
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      'instagram':''
                                    });
                                    provider.setInstagram('');
                                  },
                                  child: Text('Disconnect',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                )
                              ],
                            ),

                            const SizedBox(height: 10,),
                            if(provider.userData!.fb=="")
                              InkWell(
                                onTap: ()async{

                                  await FacebookAuth.instance.login(permissions: ['email', 'public_profile']).then((value){
                                    print('vavlue ${value.message} : ${value.accessToken} : ${value.status}');
                                    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(value.accessToken!.token);

                                  }).onError((error, stackTrace){
                                    print('login error ${error.toString()}');
                                  });

                                 /* FacebookAuthProvider facebookProvider = FacebookAuthProvider();

                                  facebookProvider.addScope('email');
                                  facebookProvider.setCustomParameters({
                                    'display': 'popup',
                                  });
                                  await FirebaseAuth.instance.signInWithPopup(facebookProvider).then((value){
                                    print('vavlue ${value}');
                                    // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(value.accessToken!.token);

                                  }).onError((error, stackTrace){
                                    print('login error ${error.toString()}');
                                  });*/
                                  //showAddSocialMediaDialog(context, 2, 'Facebook');
                                },
                                child: Container(
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
                                ),
                              )
                            else
                              Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: ()async{

                                      await launchUrl(Uri.parse(provider.userData!.fb)).then((value){}).onError((error, stackTrace){
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: 'Unable to launch ${provider.userData!.fb}. Please check if this is a correct url',
                                        );
                                      });
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
                                          SocialIcon(name: 'facebook_outline', url: provider.userData!.profilePic),
                                          const SizedBox(width: 10,),
                                          Text(provider.userData!.fb,style: TextStyle(color: primaryColor),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                InkWell(
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      'fb':''
                                    });
                                    provider.setFacebook('');
                                  },
                                  child: Text('Disconnect',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            if(provider.userData!.mastodon=="")
                              InkWell(
                              onTap: (){
                                _login();
                              },
                              child: Container(
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
                            )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: ()async{

                                        await launchUrl(Uri.parse(provider.userData!.mastodon)).then((value){}).onError((error, stackTrace){
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: 'Unable to launch ${provider.userData!.mastodon}. Please check if this is a correct url',
                                          );
                                        });
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
                                            SocialIcon(name: 'mastodon_outline', url: provider.userData!.profilePic),
                                            const SizedBox(width: 10,),
                                            Text(provider.userData!.mastodon,style: TextStyle(color: primaryColor),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'mastodon':''
                                      });
                                      provider.setMastedon('');
                                    },
                                    child: Text('Disconnect',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                  )
                                ],
                              ),
                            const SizedBox(height: 10,),
                           /* Container(
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
                            const SizedBox(height: 10,),*/
                            if(provider.userData!.youtube=='')
                              InkWell(
                              onTap: ()async{
                                AuthenticationApi api=AuthenticationApi();
                                api.loginWithYouTube(context).then((value){
                                  print('youtube done');
                                }).onError((error, stackTrace){
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });
                                //showAddSocialMediaDialog(context, 4, 'Youtube');

                              },
                              child: Container(
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
                            )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: ()async{

                                        await launchUrl(Uri.parse('https://www.youtube.com/${provider.userData!.youtube}')).then((value){}).onError((error, stackTrace){
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: 'Unable to launch https://www.youtube.com/${provider.userData!.youtube}. Please check if this is a correct url',
                                          );
                                        });
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
                                            SocialIcon(name: 'youtube_outline', url: provider.userData!.profilePic),
                                            const SizedBox(width: 10,),
                                            Text(provider.userData!.youtube,style: TextStyle(color: primaryColor),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'youtube':''
                                      });
                                      provider.setYoutube('');
                                    },
                                    child: Text('Disconnect',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w700)),
                                  )
                                ],
                              ),


                            const SizedBox(height: 20,),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  FirebaseAuth.instance.signOut().then((value){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Homepage()));

                                  });
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
                                      Icon(Icons.logout,color: primaryColor,),
                                      const SizedBox(width: 10,),
                                      const Text('Logout',style: TextStyle(color: primaryColor),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
