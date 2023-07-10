import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_picker/country_list_picker.dart';
import 'package:directory_app/screens/auth/create_account.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../api/auth_api.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_dailogs.dart';
import '../privacy_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var phoneController=TextEditingController();
  String phone='+92';
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
                                child: Text('Login to your account',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)
                            ),
                            const SizedBox(height: 30,),

                            const Row(
                              children: [
                                Text('Phone number*',style: TextStyle(fontWeight: FontWeight.w500),),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                /*CountryPickerDropdown(
                                  initialValue: 'US',
                                  selectedItemBuilder: (Country country){
                                    return Container(
                                      width: 500,
                                      child: Row(
                                        children: <Widget>[
                                          CountryPickerUtils.getDefaultFlagImage(country),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text("+${country.phoneCode}"),
                                        ],
                                      ),
                                    );
                                  },
                                  itemBuilder: (Country country){
                                    return Container(
                                      child: Row(
                                        children: <Widget>[
                                          CountryPickerUtils.getDefaultFlagImage(country),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text("+${country.phoneCode}(${country.name})"),
                                        ],
                                      ),
                                    );
                                  },
                                  //itemFilter:  ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                                  priorityList:[
                                    CountryPickerUtils.getCountryByIsoCode('US'),
                                    CountryPickerUtils.getCountryByIsoCode('PK'),
                                  ],
                                  sortComparator: (Country a, Country b) => a.name.compareTo(b.name),
                                  onValuePicked: (Country country) {
                                    print("${country.name}");
                                  },
                                ),*/
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
                                /*picker.CountryListPick(

                                    appBar: AppBar(
                                      backgroundColor: Colors.blue,
                                      title: Text('Choisir un pays'),
                                    ),

                                    // if you need custome picker use this
                                     *//*pickerBuilder: (BuildContext context, CountryCode? countryCode){
                                       return Row(
                                         children: [
                                           Image.asset(
                                             countryCode.flagUri,
                                             package: 'country_list_pick',
                                           ),
                                           Text(countryCode.code),
                                           Text(countryCode.dialCode),
                                         ],
                                       );
                                     },*//*

                                    // To disable option set to false
                                    theme: picker.CountryTheme(
                                      isShowFlag: true,
                                      isShowTitle: true,
                                      isShowCode: true,
                                    ),
                                    // Set default value
                                    initialSelection: '+62',
                                    // or
                                    // initialSelection: 'US'
                                    onChanged: (picker.CountryCode? code) {
                                      print(code!.name);
                                      print(code.code);
                                      print(code.dialCode);
                                      print(code.flagUri);
                                    },
                                    // Whether to allow the widget to set a custom UI overlay
                                    useUiOverlay: true,
                                    // Whether the country list should be wrapped in a SafeArea
                                    useSafeArea: false
                                ),*/
                                /*CountryCodePicker(
                                  onChanged: (value){
                                    phone='$value';
                                    print('code $phone');
                                  },
                                  comparator: (a, b){
                                    return b.name!.compareTo(a.name!);
                                  },
                                  initialSelection: 'US',
                                  favorite: ['+92','PK','+1','US'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),*/
                                Expanded(
                                  child:  TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller: phoneController,

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
                                    print('phone $phone${phoneController.text.trim()}');
                                    await AuthenticationApi.login('$phone${phoneController.text.trim()}').then((value){
                                      pr.close();
                                      if(value){
                                        AuthenticationApi authApi=AuthenticationApi();
                                        authApi. verifyPhoneNumber('$phone${phoneController.text.trim()}', context, 1,null);
                                      }
                                      else{
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: 'User does not exists',
                                        );
                                      }
                                    }).onError((error, stackTrace) {
                                      pr.close();
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: error.toString(),
                                      );
                                    });

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
                                const Text('Don\'t have an account?',style: TextStyle(color: Colors.grey),),
                                InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const CreateAccount()));
                                  },
                                  child: const Text(' Sign Up',style: TextStyle(color: primaryColor),),
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
