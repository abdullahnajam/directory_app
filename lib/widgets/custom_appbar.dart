import 'package:directory_app/provider/search_provider.dart';
import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/auth/create_account.dart';
import 'package:directory_app/screens/auth/login_screen.dart';
import 'package:directory_app/screens/homepage.dart';
import 'package:directory_app/screens/my_profile.dart';
import 'package:directory_app/screens/user_profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/search_screen.dart';

class CustomAppBar extends StatefulWidget {
  bool showSearchBar;


  CustomAppBar({required this.showSearchBar});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  var controller=TextEditingController();
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
                          controller: controller,



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
                            suffixIcon: InkWell(
                              onTap: (){
                                final provider = Provider.of<SearchProvider>(context, listen: false);
                                provider.setQuery(controller.text.trim());
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  SearchScreen(controller.text.trim())));

                              },
                              child: Icon(Icons.search_outlined,color: primaryColor,),
                            ),
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
          if(!Responsive.isMobile(context))
            Row(
              children: [
                if(FirebaseAuth.instance.currentUser!=null)
                  Row(
                  children: [
                    InkWell(
                      onTap: (){
                        if(FirebaseAuth.instance.currentUser!=null){
                          final provider = Provider.of<UserDataProvider>(context, listen: false);

                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserProfile(provider.userData!)));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));
                        }
                      },
                      child: Text('My Contacts',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        if(FirebaseAuth.instance.currentUser!=null){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));
                        }


                      },
                      child: FirebaseAuth.instance.currentUser==null?
                      Image.asset('assets/images/profile.png',height: 25,fit: BoxFit.cover,):
                      Consumer<UserDataProvider>(
                        builder: (context, provider, child) {
                          return ProfilePicture(url: provider.userData!.profilePic,height: 25,width: 25,);
                        },
                      ),
                    ),
                  ],
                )
                else
                  InkWell(
                    onTap: ()async{
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  LoginScreen()));

                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: const Text('Login',style: TextStyle(color: Colors.white),),
                    ),
                  ),
              ],
            )
          else
            InkWell(
              onTap: (){
                if(FirebaseAuth.instance.currentUser!=null){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyProfile()));
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
                }

              },
              child: Image.asset('assets/images/menu.png',height: 18,fit: BoxFit.cover,),
            )
        ],
      ),
    );
  }
}
