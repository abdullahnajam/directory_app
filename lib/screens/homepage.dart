import 'package:directory_app/screens/auth/create_account.dart';
import 'package:directory_app/screens/search_screen.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/auth_api.dart';
import '../provider/search_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedFilter=filter.first;
  var _searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 1440,
            ),
            child: ListView(
              children: [
                CustomAppBar(showSearchBar: false,),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: Responsive.isMobile(context)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(130,20,130,20),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(Responsive.isMobile(context)?0:20)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      /*ElevatedButton(
                        onPressed: ()async{
                          print('tap fb');
                          FacebookAuthProvider facebookProvider = FacebookAuthProvider();

                          facebookProvider.addScope('email');
                          facebookProvider.setCustomParameters({
                            'display': 'popup',
                          });
                          await FirebaseAuth.instance.signInWithPopup(facebookProvider).then((value){
                            print('vavlue ${value}');
                           // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(value.accessToken!.token);

                          }).onError((error, stackTrace){
                            print('login error ${error.toString()}');
                          });
                          *//*await FacebookAuth.instance.login(permissions: ['email', 'public_profile']).then((value){
                            print('vavlue ${value.message} : ${value.accessToken} : ${value.status}');
                            final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(value.accessToken!.token);

                          }).onError((error, stackTrace){
                            print('login error ${error.toString()}');
                          });*//*
                          *//*final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
                          print('login status ${loginResult.status}');
                          final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);*//*
                          *//*AuthenticationApi api=AuthenticationApi();
                          api.loginWithYouTube();*//*
                        },
                        child: Text('test'),
                      ),*/
                      if(!Responsive.isMobile(context))
                        SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                      Text('Welcome to The\nInternet Phone Book',textAlign: TextAlign.center,style: TextStyle(fontSize: !Responsive.isMobile(context)?30:25,fontWeight: FontWeight.w900,color: Colors.white),),
                      const SizedBox(height: 20,),
                      const Text('Search for contacts using email, phone number, or social media handle.',textAlign: TextAlign.center,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300,color: Colors.white),),
                      const SizedBox(height: 20,),
                      if(!Responsive.isMobile(context))
                        SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      if(Responsive.isMobile(context))
                        Column(
                        children: [
                          Consumer<SearchProvider>(
                            builder: (context, provider, child) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex:3,
                                    child: InkWell(
                                      onTap: ()async{


                                      },
                                      child: Container(
                                        height: 48,



                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7),
                                            )
                                        ),
                                        alignment: Alignment.center,
                                        child: DropdownButton<String>(
                                          value: provider.filter,
                                          isExpanded: false,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.black),
                                          underline: Container(

                                          ),
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            provider.setFilter(value!);
                                          },
                                          items: filter.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex:7,
                                    child: TextFormField(
                                      controller: _searchController,

                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },

                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(15),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7),
                                          ),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.5
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 0.5,
                                          ),
                                        ),
                                        hintText: 'Search',
                                        filled: true,
                                        fillColor: Colors.white,
                                        // If  you are using latest version of flutter then lable text and hint text shown like this
                                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              final provider = Provider.of<SearchProvider>(context, listen: false);
                              provider.setQuery(_searchController.text.trim());
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  SearchScreen(_searchController.text.trim())));

                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Text('Search',style: TextStyle(color: Colors.white),),
                            ),
                          )
                        ],
                      )
                      else
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Consumer<SearchProvider>(
                                  builder: (context, provider, child) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          flex:3,
                                          child: InkWell(
                                            onTap: ()async{


                                            },
                                            child: Container(
                                              height: 48,



                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.grey.shade300),
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(7),
                                                    bottomLeft: Radius.circular(7),
                                                  )
                                              ),
                                              alignment: Alignment.center,
                                              child: DropdownButton<String>(
                                                value: provider.filter,
                                                isExpanded: false,
                                                icon: const Icon(Icons.arrow_drop_down),
                                                elevation: 16,
                                                style: const TextStyle(color: Colors.black),
                                                underline: Container(

                                                ),
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  provider.setFilter(value!);
                                                },
                                                items: filter.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex:7,
                                          child: TextFormField(
                                            controller: _searchController,

                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },

                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(15),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(7),
                                                  bottomRight: Radius.circular(7),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(7),
                                                  bottomRight: Radius.circular(7),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 0.5
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(7),
                                                  bottomRight: Radius.circular(7),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 0.5,
                                                ),
                                              ),
                                              hintText: 'Search',
                                              filled: true,
                                              fillColor: Colors.white,
                                              // If  you are using latest version of flutter then lable text and hint text shown like this
                                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                          ),
                                        ),

                                      ],
                                    );
                                  },
                                ),
                              ),
                              /*Expanded(
                                flex: 8,
                                child: TextFormField(
                                  controller: _searchController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },

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
                                    hintText: 'Search',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),*/
                              const SizedBox(width: 10,),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: (){
                                    final provider = Provider.of<SearchProvider>(context, listen: false);
                                    provider.setQuery(_searchController.text.trim());
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  SearchScreen(_searchController.text.trim())));

                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('Search',style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                      if(!Responsive.isMobile(context))
                        SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: Text('Features',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)),
                ),
                if(Responsive.isMobile(context))
                  Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/verified.png',height: 60,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          const Text('Verify and manage your digital identity',style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          const Text('Stop imposters in their tracks. Verify your identity on The Internet Phone Book and link all your social media profiles. Gain control and let your connections know they\'ve found the real you.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/link.png',height: 60,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          const Text('Discover and Connect',style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          const Text('Looking for someone specific? Our search function simplifies the process. Find friends, family, and colleagues across multiple platforms, all at once. Connect like never before.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/stats.png',height: 60,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          const Text('Keep everyone updated',style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          const Text('Automatically update all your contacts when your information changes. Never be tied to an email or phone number again.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/lock.png',height: 60,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          const Text('Privacy comes first',style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          const Text('We respect your privacy. Control what you share and with whom. Your data is your own and we make sure it stays that way.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/chat.png',height: 60,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          const Text('Invite and expand your network',style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          const Text('Import your contacts seamlessly. Invite them to join The Internet Phone Book. Grow your network and enjoy the convenience of a unified online presence.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/pay.png',height: 60,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          const Text('We\'re free to use' ,style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          const Text('Yes, you read it right.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                        ],
                      ),
                    ),
                  ],
                )
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child:  Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/verified.png',height: 60,fit: BoxFit.cover,),
                                    const SizedBox(height: 10,),
                                    const Text('Verify and manage your digital identity',style: TextStyle(fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    const Text('Stop imposters in their tracks. Verify your identity on The Internet Phone Book and link all your social media profiles. Gain control and let your connections know they\'ve found the real you.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child:   Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/link.png',height: 60,fit: BoxFit.cover,),
                                    const SizedBox(height: 10,),
                                    const Text('Discover and Connect',style: TextStyle(fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    const Text('Looking for someone specific? Our search function simplifies the process. Find friends, family, and colleagues across multiple platforms, all at once. Connect like never before.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child:  Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/stats.png',height: 60,fit: BoxFit.cover,),
                                    const SizedBox(height: 10,),
                                    const Text('Keep everyone updated',style: TextStyle(fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    const Text('Automatically update all your contacts when your information changes. Never be tied to an email or phone number again.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            )



                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child:   Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/verified.png',height: 60,fit: BoxFit.cover,),
                                    const SizedBox(height: 10,),
                                    const Text('Verify and manage your digital identity',style: TextStyle(fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    const Text('Stop imposters in their tracks. Verify your identity on The Internet Phone Book and link all your social media profiles. Gain control and let your connections know they\'ve found the real you.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child:   Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/link.png',height: 60,fit: BoxFit.cover,),
                                    const SizedBox(height: 10,),
                                    const Text('Discover and Connect',style: TextStyle(fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    const Text('Looking for someone specific? Our search function simplifies the process. Find friends, family, and colleagues across multiple platforms, all at once. Connect like never before.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/stats.png',height: 60,fit: BoxFit.cover,),
                                    const SizedBox(height: 10,),
                                    const Text('Keep everyone updated',style: TextStyle(fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    const Text('Automatically update all your contacts when your information changes. Never be tied to an email or phone number again.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            )



                          ],
                        )
                      ],
                    ),
                  ),
                if(FirebaseAuth.instance.currentUser==null)
                Column(
                  children: [
                    if(Responsive.isMobile(context))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 30,left: 10),
                                child: Center(child: Text('Join us now!',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)),
                              ),
                            ],
                          ),
                          const Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Ready to simplify your digital life? Sign up now and take the first step towards a unified, verifiable online presence.',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w300),),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));

                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              width: Responsive.isMobile(context)?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.3,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: const Text('Get started',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Center(
                            child: Image.asset('assets/images/screen.png',height: MediaQuery.of(context).size.height*0.4,),
                          ),
                          const SizedBox(height: 20,),


                        ],
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 80,right: 80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 30,left: 10),
                                      child: Center(child: Text('Join us now!',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                const Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text('Ready to simplify your digital life? Sign up now and take\nthe first step towards a unified, verifiable online presence.',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w300),),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: (){

                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));

                                  },
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 10,right: 10,top: 20),
                                    width: MediaQuery.of(context).size.width*0.1,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('Get started',style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                const SizedBox(height: 20,),

                                const SizedBox(height: 20,),


                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Center(
                              child: Image.asset('assets/images/screen.png',height: MediaQuery.of(context).size.height*0.4,),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Image.asset('assets/images/people.png',height: MediaQuery.of(context).size.height*0.07,),
                      const SizedBox(height: 20,),
                      const Text('Got questions? ',style: TextStyle(fontWeight: FontWeight.w500),),
                      const SizedBox(height: 10,),
                      const Text('We\'ve got answers. Check out our frequently asked questions section to learn more.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                      const SizedBox(height: 20,),
                      InkWell(
                        onTap: (){

                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          width: MediaQuery.of(context).size.width*0.2,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(7)
                          ),
                          alignment: Alignment.center,
                          child: const Text('FAQ',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
                /*Container(
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30,left: 10),
                        child: Center(child: Text('Connect With Us',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Stay updated. Follow us on our social media channels and join the conversation. Your online presence, simplified. Welcome to the future, welcome to The Internet Phone Book.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/fb.png',height: 25,fit: BoxFit.cover,),
                            Image.asset('assets/images/instagram.png',height: 25,fit: BoxFit.cover,),
                            Image.asset('assets/images/mastedon.png',height: 25,fit: BoxFit.cover,),
                            Image.asset('assets/images/wallet.png',height: 25,fit: BoxFit.cover,),
                            Image.asset('assets/images/youtube.png',height: 25,fit: BoxFit.cover,),

                          ],
                        ),
                      )
                    ],
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
