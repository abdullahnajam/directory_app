import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_picker/country_list_picker.dart';
import 'package:directory_app/screens/auth/login_screen.dart';
import 'package:directory_app/screens/privacy_page.dart';
import 'package:directory_app/screens/profile.dart';
import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/widgets/custom_appbar.dart';
import 'package:directory_app/widgets/custom_dailogs.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../../api/auth_api.dart';
import '../../model/user_model.dart';
import '../../provider/user_provider.dart';
import '../../utils/responsive.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var firstNameController=TextEditingController();
  var lastNameController=TextEditingController();
  var phoneController=TextEditingController();
  String phone='+92';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAppBar(showSearchBar: true,),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: Responsive.getWidth(context),
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Create an account',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)
                            ),
                            const SizedBox(height: 30,),
                            const Row(
                              children: [
                                Text('First Name*',style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: firstNameController,
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
                                hintText: 'Enter your name',
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),

                            const SizedBox(height: 20,),
                            const Row(
                              children: [
                                Text('Last Name*',style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: lastNameController,

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
                                hintText: 'Enter your name',
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Row(
                              children: [
                                Text('Phone number*',style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                  child: CountryListPicker(
                                    isShowDownIcon:false,
                                    isShowCountryName: false,
                                    isShowInputField: false,
                                    border: InputBorder.none,
                                    flagSize: Size (30,30),
                                    initialCountry: Countries.United_States,
                                    diallingCodeStyle: TextStyle(fontSize: 15),
                                    onCountryChanged: ((value) {
                                      print('${value.dialing_code}');
                                      phone='${value.dialing_code}';
                                    }),
                                    /*onChanged: (value) {
                                      phone='$value';
                                    },*/
                                  ),
                                ),
                                Expanded(
                                  child:  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
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
                                      hintText: 'Enter your phone number',
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            /*InternationalPhoneNumberInput(
                              onInputChanged: (value){
                                phone=value.phoneNumber!;
                                print(phone);
                              },

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              //countries: ["JO",'PK'],
                              inputDecoration: InputDecoration(
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
                                hintText: 'Enter your phone number',
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),*/
                            const SizedBox(height: 20,),
                            Wrap(

                              runAlignment: WrapAlignment.start,
                              alignment: WrapAlignment.start,
                              children: [
                                Text('To learn more, see  ',style: TextStyle(color: Colors.grey),),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  PrivacyPage(isPrivacyPolicy: false)));

                                  },
                                  child: Text('Terms of Service',style: TextStyle(color: primaryColor),)
                                ),
                                Text(' and ',style: TextStyle(color: Colors.grey),),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  PrivacyPage(isPrivacyPolicy: true)));

                                  },
                                  child: Text('Privacy Policy.',style: TextStyle(color: primaryColor),),
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            const Text('By continuing your mobile number, you agree to receive SMS for verification.',textAlign: TextAlign.left,),
                            const SizedBox(height: 20,),
                            Center(
                              child: InkWell(
                                onTap: ()async{
                                  if(_formKey.currentState!.validate()){
                                    final ProgressDialog pr = ProgressDialog(context: context);
                                    pr.show(max: 100, msg: 'Please Wait',barrierDismissible: true);
                                    final provider = Provider.of<UserDataProvider>(context, listen: false);
                                    UserModel model=UserModel.fromMap(
                                        {
                                          'phone':'$phone${phoneController.text.trim()}',
                                          'status':'Approved',
                                          'token':'',
                                          'firstName':firstNameController.text.trim(),
                                          'lastName':lastNameController.text.trim(),
                                          'profilePic':'',
                                        },
                                        ''
                                    );
                                    provider.setUserData(model);
                                    AuthenticationApi authApi=AuthenticationApi();
                                    bool exists=false;
                                    await FirebaseFirestore.instance.collection('users').where("phone",isEqualTo: phone).get().then((QuerySnapshot querySnapshot) {
                                      querySnapshot.docs.forEach((doc) {
                                        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                        exists=true;
                                      });
                                    });
                                    pr.close();
                                    if(exists){
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: 'User already registered',
                                      );
                                    }
                                    else{
                                      authApi.verifyPhoneNumber('$phone${phoneController.text.trim()}', context, 2,null);

                                    }

                                  }


                                },
                                child: Container(
                                  height: 50,

                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(7)
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('Send Code',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?',style: TextStyle(color: Colors.grey),),
                                InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));

                                  },
                                  child: const Text(' Log in',style: TextStyle(color: primaryColor),),
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
