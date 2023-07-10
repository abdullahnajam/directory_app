import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:directory_app/provider/search_provider.dart';
import 'package:directory_app/provider/user_provider.dart';
import 'package:directory_app/screens/profile.dart';
import 'package:directory_app/screens/user_profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:directory_app/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../api/database_api.dart';
import '../model/user_model.dart';

class SearchScreen extends StatefulWidget {
  String query;


  SearchScreen(this.query);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _controller=TextEditingController();

  List<String> socialList=['All','Facebook','Youtube','Instagram','Mastodon'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text=widget.query;
  }

  /*static Future<List<UserModel>> search(BuildContext context)async{
    final provider = Provider.of<SearchProvider>(context, listen: false);

    List<UserModel> users=[];
    if(provider.filter=='Name'){
      await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          UserModel model=UserModel.fromMap(data, doc.reference.id);
          if(FirebaseAuth.instance.currentUser!=null){
            if(model.userId!= FirebaseAuth.instance.currentUser!.uid && '${model.firstName} ${model.lastName}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
              users.add(model);
            }
          }
          else{
            if('${model.firstName} ${model.lastName}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
              users.add(model);
            }
          }
        });
      });
    }
    else if(provider.filter=='Email'){
      print('email filter');
      await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) async{
        querySnapshot.docs.forEach((doc) async{
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          UserModel model=UserModel.fromMap(data, doc.reference.id);
          await FirebaseFirestore.instance.collection('users').doc(doc.reference.id).collection('emails').doc(doc.reference.id).get().then((DocumentSnapshot documentSnapshot) async{
            if (documentSnapshot.exists) {

              Map<String, dynamic> email = documentSnapshot.data()! as Map<String, dynamic>;
              print('${doc.reference.id} : email $email');
              if(FirebaseAuth.instance.currentUser!=null){
                print('${model.userId!= FirebaseAuth.instance.currentUser!.uid}  :  ${'${email['name']}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())}');
                if(model.userId!= FirebaseAuth.instance.currentUser!.uid && '${email['name']}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
                  print('adding');
                  users.add(model);
                  print('users ${users.length}');
                }
              }
              else{
                if(email['name'].toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
                  users.add(model);
                }
              }

            }


          });

        });
      });
    }
    else if(provider.filter=='Phone'){
      await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async{
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          UserModel model=UserModel.fromMap(data, doc.reference.id);

          await FirebaseFirestore.instance.collection('users').doc(doc.reference.id).collection('phone').doc(doc.reference.id).get().then((DocumentSnapshot documentSnapshot) async{
            if (documentSnapshot.exists) {
              Map<String, dynamic> phone = documentSnapshot.data()! as Map<String, dynamic>;
              if(FirebaseAuth.instance.currentUser!=null){

                if(model.userId!= FirebaseAuth.instance.currentUser!.uid && '${phone['name']}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
                  users.add(model);
                }
              }
              else{
                if(phone['name'].toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
                  users.add(model);
                }
              }

            }


          });

        });
      });
    }
    else if(provider.filter=='Social'){
      await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          UserModel model=UserModel.fromMap(data, doc.reference.id);
          if(FirebaseAuth.instance.currentUser!=null){
            if(model.userId!= FirebaseAuth.instance.currentUser!.uid && '${model.firstName} ${model.lastName}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
              users.add(model);
            }
          }
          else{
            if('${model.firstName} ${model.lastName}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
              users.add(model);
            }
          }
        });
      });
    }


    return users;
  }*/

  static Future<List<UserModel>> search(BuildContext context)async{
    final provider = Provider.of<SearchProvider>(context, listen: false);

    List<UserModel> allUsers=[];
    List<UserModel> temp=[];


    await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        UserModel model=UserModel.fromMap(data, doc.reference.id);
        if(FirebaseAuth.instance.currentUser!=null){
          if(model.userId!= FirebaseAuth.instance.currentUser!.uid){
            allUsers.add(model);
          }
        }
        else{
          allUsers.add(model);
        }
      });
    });
    print('users lenght ${allUsers.length}');
    if(provider.filter=='Name'){
      for(int i=0;i<allUsers.length;i++){
        if('${allUsers[i].firstName} ${allUsers[i].lastName}'.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
          temp.add(allUsers[i]);
        }

      }
    }
    else if(provider.filter=='Email'){
      print('email filter');
      for(int i=0;i<allUsers.length;i++){
        print('i $i - ${allUsers.length}');
        await FirebaseFirestore.instance.collection('users').doc(allUsers[i].userId).collection('emails').doc(allUsers[i].userId).get().then((DocumentSnapshot documentSnapshot) async{
          if (documentSnapshot.exists) {

            Map<String, dynamic> email = documentSnapshot.data()! as Map<String, dynamic>;
            print('${allUsers[i].userId} : email $email');
            if(email['name'].toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
              temp.add(allUsers[i]);
            }

          }


        });

      }
    }
    else if(provider.filter=='Phone'){
      for(int i=0;i<allUsers.length;i++){
        if(allUsers[i].phone.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
          temp.add(allUsers[i]);
        }
        else{
          await FirebaseFirestore.instance.collection('users').doc(allUsers[i].userId).collection('emails').doc(allUsers[i].userId).get().then((DocumentSnapshot documentSnapshot) async{
            if (documentSnapshot.exists) {

              Map<String, dynamic> email = documentSnapshot.data()! as Map<String, dynamic>;
              print('${allUsers[i].userId} : email $email');
              if(email['name'].toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
                temp.add(allUsers[i]);
              }

            }


          });

        }

      }
    }
    else if(provider.filter=='Social'){
      for(int i=0;i<allUsers.length;i++){
        if(allUsers[i].youtube.toString().toLowerCase().contains(provider.query.toString().toLowerCase())){
          temp.add(allUsers[i]);
        }

      }
    }

    List<UserModel> socialFilter=[];
    if(provider.social=='All'){
      socialFilter=temp;
    }
    else if(provider.social=='Facebook'){
      temp.forEach((element) {
        if(element.fb!=''){
          socialFilter.add(element);
        }
      });
    }
    else if(provider.social=='Youtube'){
      temp.forEach((element) {
        if(element.youtube!=''){
          socialFilter.add(element);
        }
      });
    }
    else if(provider.social=='Instagram'){
      temp.forEach((element) {
        if(element.instagram!=''){
          socialFilter.add(element);
        }
      });
    }
    else if(provider.social=='Mastodon'){
      temp.forEach((element) {
        if(element.mastodon!=''){
          socialFilter.add(element);
        }
      });
    }
    List<UserModel> locationFilter=[];
    if(provider.country==''){
      locationFilter=socialFilter;
    }
    else{
      socialFilter.forEach((element) {
        if(element.country==provider.country && element.city==provider.city){
          locationFilter.add(element);
        }
      });
    }




    return locationFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: maxWidth
            ),
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return ListView(
                  children: [
                    CustomAppBar(showSearchBar: false,),

                    Padding(
                      padding: Responsive.isMobile(context)?const EdgeInsets.all(10):const EdgeInsets.fromLTRB(40,20,40,20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Search: \"${widget.query}\"',style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 25)),

                          if(!Responsive.isMobile(context))
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(' Location',style: TextStyle(fontWeight: FontWeight.w400)),
                                    if(provider.country=='')
                                      InkWell(
                                      onTap: (){
                                        showAddCityCountryDialog(context);
                                      },
                                      child: Container(
                                        height: 40,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7)
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text('Location',style: TextStyle(fontWeight: FontWeight.w400)),

                                                Center(child: Icon(Icons.arrow_drop_down,size: 15,))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    else
                                      InkWell(
                                        onTap: (){
                                          showAddCityCountryDialog(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7)
                                            ),
                                            child:  Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text('${provider.city}, ${provider.country}',style: TextStyle(fontWeight: FontWeight.w400)),
                                                  SizedBox(width: 10,),
                                                  Center(
                                                    child: InkWell(
                                                      onTap: (){
                                                        provider.setCity('');
                                                        provider.setCountry('');
                                                      },
                                                      child: Icon(Icons.close,size: 15,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(' Social Media',style: TextStyle(fontWeight: FontWeight.w400)),
                                    Container(
                                      height: 40,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(7)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10),
                                          child: DropdownButton<String>(
                                            value: provider.social,
                                            isExpanded: false,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            elevation: 16,
                                            style: const TextStyle(color: Colors.black),
                                            underline: Container(

                                            ),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              provider.setSocial(value!);
                                            },
                                            items: socialList.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
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
                        margin: const EdgeInsets.all(10),
                        width: Responsive.getWidth(context),
                        child: Row(
                          children: [
                            Expanded(
                              flex:3,
                              child: InkWell(
                                onTap: ()async{


                                },
                                child: Container(
                                  height: 50,


                                  decoration: BoxDecoration(
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
                                controller: _controller,

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
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      provider.setQuery(_controller.text);
                                    },
                                    icon: const Icon(Icons.search,color: primaryColor,),
                                  ),
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: Responsive.getWidth(context),
                        child: FutureBuilder<List<UserModel>>(
                            future: search(context),
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
                                            //context.go('/user-profile/${snapshot.data![index].userId}');
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(userId:snapshot.data![index].userId)));

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
                                                if(FirebaseAuth.instance.currentUser!=null)
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
                );
              },
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
  Future<void> showAddCityCountryDialog(BuildContext context) async {
    List countries = await getAllCountries();
    List cities = await getAllCities();
    String countryCode='';
    var _countryController=TextEditingController();
    var _cityController=TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){

            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,

              child: Container(
                height: MediaQuery.of(context).size.height*0.65,
                padding: const EdgeInsets.all(20),
                width: Responsive.getDailogWidth(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  height: 40,

                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,6,10,10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey)
                                    ),
                                    child: const Icon(Icons.add),
                                  )
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                                child: InkWell(
                                  child: const Icon(Icons.close,color: Colors.black,size: 20,),
                                  onTap: ()=>Navigator.pop(context),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            const Text('Add City/Country',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                            const SizedBox(height: 10,),
                            const Text('Country',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                            const SizedBox(height: 10,),
                            Container(
                              height: 50,
                              child: TypeAheadField(

                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _countryController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Enter Country',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                                noItemsFoundBuilder: (context) {
                                  return const ListTile(
                                    leading: Icon(Icons.error),
                                    title: Text('No Data Found'),
                                  );
                                },
                                suggestionsCallback: (pattern) async {

                                  List<Country> search=[];


                                  countries.forEach((element) {
                                    if (element.name.toString().toLowerCase().contains(pattern.toLowerCase()))
                                      search.add(element);
                                  });

                                  return search;
                                },
                                itemBuilder: (context, Country suggestion) {
                                  return ListTile(
                                    leading: const Icon(Icons.place_outlined),
                                    title: Text(suggestion.name),
                                  );
                                },
                                onSuggestionSelected: (Country suggestion)async {
                                  _countryController.text=suggestion.name;
                                  countryCode=suggestion.isoCode;
                                  cities=await getCountryCities(suggestion.isoCode);


                                },
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Text('City',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),

                            const SizedBox(height: 10,),
                            Container(
                              height: 50,
                              child: TypeAheadField(

                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _cityController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Enter City',
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                                noItemsFoundBuilder: (context) {
                                  return const ListTile(
                                    leading: Icon(Icons.error),
                                    title: Text('No Data Found'),
                                  );
                                },
                                suggestionsCallback: (pattern) async {

                                  List<City> search=[];


                                  cities.forEach((element) {
                                    if (element.name.toString().toLowerCase().contains(pattern.toLowerCase()))
                                      search.add(element);
                                  });

                                  return search;
                                },
                                itemBuilder: (context, City suggestion) {
                                  return ListTile(
                                    leading: const Icon(Icons.place_outlined),
                                    title: Text(suggestion.name),
                                  );
                                },
                                onSuggestionSelected: (City suggestion) {
                                  _cityController.text=suggestion.name;


                                },
                              ),
                            ),

                            const SizedBox(height: 20,),

                            const SizedBox(height: 20,),
                            Row(
                              children: [

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){

                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,


                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(7)
                                        ),
                                        alignment: Alignment.center,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Text('Cancel',style: TextStyle(color: Colors.black),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: ()async{
                                        final provider = Provider.of<SearchProvider>(context, listen: false);
                                        provider.setCountry(_countryController.text.trim());
                                        provider.setCity(_cityController.text.trim());
                                        Navigator.pop(context);



                                      },
                                      child: Container(
                                        height: 50,


                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(7)
                                        ),
                                        alignment: Alignment.center,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Text('Save',style: TextStyle(color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      )



                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}
