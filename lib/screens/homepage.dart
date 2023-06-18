import 'package:directory_app/screens/create_account.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar(showSearchBar: false,),
            Container(
              padding: EdgeInsets.all(20),
              margin: Responsive.isMobile(context)?EdgeInsets.all(0):EdgeInsets.fromLTRB(80,20,80,20),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(Responsive.isMobile(context)?0:20)
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  if(!Responsive.isMobile(context))
                    SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                  Text('Welcome to The\nInternet Phone Book',textAlign: TextAlign.center,style: TextStyle(fontSize: !Responsive.isMobile(context)?30:25,fontWeight: FontWeight.w900,color: Colors.white),),
                  SizedBox(height: 20,),
                  Text('Search for contacts using email, phone number, or social media handle.',textAlign: TextAlign.center,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300,color: Colors.white),),
                  SizedBox(height: 20,),
                  if(!Responsive.isMobile(context))
                    SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                  if(Responsive.isMobile(context))
                    Column(
                    children: [
                      Container(
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

                            /* List<SearchModel> search=[];

                  search=await ChatApi.getSearchData(provider.userData!.userId,pattern);*/



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
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        alignment: Alignment.center,
                        child: Text('Search',style: TextStyle(color: Colors.white),),
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
                            child: Container(
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

                                  /* List<SearchModel> search=[];

                  search=await ChatApi.getSearchData(provider.userData!.userId,pattern);*/



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
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              alignment: Alignment.center,
                              child: Text('Search',style: TextStyle(color: Colors.white),),
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
            Padding(
              padding: const EdgeInsets.all(30),
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
                      SizedBox(height: 10,),
                      Text('Verify and manage your digital identity',style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text('Stop imposters in their tracks. Verify your identity on The Internet Phone Book and link all your social media profiles. Gain control and let your connections know they\'ve found the real you.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/link.png',height: 60,fit: BoxFit.cover,),
                      SizedBox(height: 10,),
                      Text('Discover and Connect',style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text('Looking for someone specific? Our search function simplifies the process. Find friends, family, and colleagues across multiple platforms, all at once. Connect like never before.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/stats.png',height: 60,fit: BoxFit.cover,),
                      SizedBox(height: 10,),
                      Text('Keep everyone updated',style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text('Automatically update all your contacts when your information changes. Never be tied to an email or phone number again.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/lock.png',height: 60,fit: BoxFit.cover,),
                      SizedBox(height: 10,),
                      Text('Privacy comes first',style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text('We respect your privacy. Control what you share and with whom. Your data is your own and we make sure it stays that way.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/chat.png',height: 60,fit: BoxFit.cover,),
                      SizedBox(height: 10,),
                      Text('Invite and expand your network',style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text('Import your contacts seamlessly. Invite them to join The Internet Phone Book. Grow your network and enjoy the convenience of a unified online presence.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/pay.png',height: 60,fit: BoxFit.cover,),
                      SizedBox(height: 10,),
                      Text('We\'re free to use' ,style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                      Text('Yes, you read it right.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
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
                                SizedBox(height: 10,),
                                Text('Verify and manage your digital identity',style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('Stop imposters in their tracks. Verify your identity on The Internet Phone Book and link all your social media profiles. Gain control and let your connections know they\'ve found the real you.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
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
                                SizedBox(height: 10,),
                                Text('Discover and Connect',style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('Looking for someone specific? Our search function simplifies the process. Find friends, family, and colleagues across multiple platforms, all at once. Connect like never before.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
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
                                SizedBox(height: 10,),
                                Text('Keep everyone updated',style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('Automatically update all your contacts when your information changes. Never be tied to an email or phone number again.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
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
                                SizedBox(height: 10,),
                                Text('Verify and manage your digital identity',style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('Stop imposters in their tracks. Verify your identity on The Internet Phone Book and link all your social media profiles. Gain control and let your connections know they\'ve found the real you.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
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
                                SizedBox(height: 10,),
                                Text('Discover and Connect',style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('Looking for someone specific? Our search function simplifies the process. Find friends, family, and colleagues across multiple platforms, all at once. Connect like never before.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
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
                                SizedBox(height: 10,),
                                Text('Keep everyone updated',style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 5,),
                                Text('Automatically update all your contacts when your information changes. Never be tied to an email or phone number again.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                              ],
                            ),
                          ),
                        )



                      ],
                    )
                  ],
                ),
              ),
            if(Responsive.isMobile(context))
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30,left: 10),
                      child: Center(child: Text('Join us now!',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
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
                    margin: EdgeInsets.only(left: 10,right: 10),
                    width: Responsive.isMobile(context)?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.3,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(7)
                    ),
                    alignment: Alignment.center,
                    child: Text('Get started',style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Image.asset('assets/images/screen.png',height: MediaQuery.of(context).size.height*0.4,),
                ),
                SizedBox(height: 20,),
                

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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30,left: 10),
                              child: Center(child: Text('Join us now!',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
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
                            margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                            width: MediaQuery.of(context).size.width*0.1,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(7)
                            ),
                            alignment: Alignment.center,
                            child: Text('Get started',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 20,),

                        SizedBox(height: 20,),


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
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Image.asset('assets/images/people.png',height: MediaQuery.of(context).size.height*0.07,),
                  SizedBox(height: 20,),
                  Text('Got questions? ',style: TextStyle(fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('We\'ve got answers. Check out our frequently asked questions section to learn more.',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300),),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 10,right: 10),
                      width: MediaQuery.of(context).size.width*0.2,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7)
                      ),
                      alignment: Alignment.center,
                      child: Text('FAQ',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}
