import 'package:directory_app/utils/constants.dart';
import 'package:directory_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  bool isPrivacyPolicy;

  PrivacyPage({required this.isPrivacyPolicy});


  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: maxWidth
            ),
            width: Responsive.getWidth(context),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back,color: primaryColor,),
                        ),
                      )
                    ),
                    SizedBox(width: 10,),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(widget.isPrivacyPolicy?'Privacy Policy':'Terms of Service',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 25),)
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                if(widget.isPrivacyPolicy)
                  Text('Thank you for visiting our website. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you interact with our website and services. We are committed to protecting your privacy and ensuring the security of your personal information. By using our website, you consent to the practices described in this Privacy Policy.\n\nWhen you use our website, we may collect personal information that you provide to us, such as your name, email address, and social media contacts (including usernames and profile information). We only collect personal information that is necessary for providing our services and improving your user experience. Additionally, we may automatically collect certain information about your usage of our website, such as your IP address, browser type, operating system, device information, and website activity logs. This information is collected through the use of cookies and similar technologies.\n\nWe use your personal information to provide you with our services, including facilitating the import, export, and management of your social media contacts. We may also use your personal information to communicate with you, respond to your inquiries, and provide customer support. Additionally, we may use the information we collect to analyze trends, monitor the effectiveness of our website and services, and make improvements based on user preferences.\n\nWe are committed to safeguarding your personal information and take appropriate security measures to protect it from unauthorized access, disclosure, alteration, or destruction. We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except in cases where it is necessary to provide our services, comply with legal obligations, or protect our rights and interests.\n\nPlease note that while we strive to protect your personal information, no method of transmission or storage is completely secure. Therefore, we cannot guarantee the absolute security of your personal information.\n\nOur website may contain links to third-party websites or services that are not controlled or operated by us. This Privacy Policy does not apply to those third-party websites or services, and we are not responsible for their privacy practices. We encourage you to review the privacy policies of those third parties before providing any personal information.\n\nIf you have any questions, concerns, or requests regarding our Privacy Policy or the handling of your personal information, please contact us using the information provided below. We will endeavor to respond to your inquiries in a timely manner.\n\nWe may update this Privacy Policy from time to time. Any changes will be effective immediately upon posting the revised Privacy Policy on our website. We encourage you to review this Privacy Policy periodically to stay informed about how we collect, use, and protect your personal information.\n\nThank you for your trust in our services and for reviewing our Privacy Policy.')
                else
                  Text('Welcome to our website. These Terms of Service govern your use of our website and services. By accessing or using our website, you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, please refrain from using our website.\n\nOur website provides services that enable the import, export, and management of social media contacts. You understand and acknowledge that the use of these services may require you to provide access to your social media accounts and authorize us to retrieve, store, and process your social media contacts.\n\nYou agree to provide accurate and up-to-date information when using our services and to comply with all applicable laws and regulations. You are solely responsible for any content you upload, import, or share through our website and for any consequences arising from such content. You must not use our website for any unlawful or unauthorized purposes, including but not limited to violating the intellectual property rights of others, distributing spam, or engaging in any fraudulent activity.\n\nWhile we strive to provide a reliable and secure platform, we cannot guarantee the uninterrupted availability or error-free nature of our website and services. We reserve the right to modify, suspend, or discontinue any aspect of our website without prior notice. We will not be liable for any damages or losses resulting from the unavailability or termination of our website or services.\n\nOur website may contain links to third-party websites or services that are not controlled or operated by us. We do not endorse or assume any responsibility for the content, privacy practices, or actions of these third parties. Your interactions with third-party websites are solely between you and the third party, and we are not liable for any damages or losses arising from such interactions.\n\nWe respect the privacy of our users and handle personal information in accordance with our Privacy Policy. By using our website, you consent to the collection, use, and disclosure of your personal information as described in our Privacy Policy.\n\nWe retain all intellectual property rights in our website, including but not limited to trademarks, logos, and copyrighted material. You may not copy, modify, distribute, or create derivative works based on our website or its content without our prior written consent.\n\nThese Terms of Service constitute the entire agreement between you and us regarding your use of our website and services and supersede any prior agreements or understandings. These terms are governed by the laws of [Insert Jurisdiction] without regard to its conflict of law provisions.\n\nIf any provision of these Terms of Service is found to be invalid or unenforceable, that provision will be enforced to the maximum extent permissible, and the remaining provisions will remain in full force and effect.\n\nIf you have any questions or concerns regarding these Terms of Service, please contact us using the information provided below.\n\nThank you for reviewing our Terms of Service. By using our website, you agree to comply with these terms and conditions.')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
