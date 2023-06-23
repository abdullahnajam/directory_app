import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class DBApi{
  static Future<List<UserModel>> getAllUsers(String query)async{
    List<UserModel> users=[];
    await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        UserModel model=UserModel.fromMap(data, doc.reference.id);
        if(FirebaseAuth.instance.currentUser!=null){
          if(model.userId!= FirebaseAuth.instance.currentUser!.uid && '${model.firstName} ${model.lastName}'.toString().toLowerCase().contains(query.toString().toLowerCase())){
            users.add(model);
          }
        }
        else{
          if('${model.firstName} ${model.lastName}'.toString().toLowerCase().contains(query.toString().toLowerCase())){
            users.add(model);
          }
        }
      });
    });

    return users;
  }

}