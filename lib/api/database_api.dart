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
  static Future<List<UserModel>> findFollowersUsers(String query,String userId)async{
    List<UserModel> users=[];
    users=await getFollowersData(userId);
    for(int i=0;i<users.length;i++){
      if('${users[i].firstName} ${users[i].lastName}'.toString().toLowerCase().contains(query.toString().toLowerCase())){
        users.add(users[i]);
      }
    }

    return users;
  }

  static Future<UserModel?> getUserDetails(String id)async{
    UserModel? user;
    await FirebaseFirestore.instance.collection('users').doc(id).get().then((DocumentSnapshot documentSnapshot) async{
      if (documentSnapshot.exists) {

        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        user=UserModel.fromMap(data,documentSnapshot.reference.id);

      }

    });

    return user;
  }

  static Future<List<UserModel>> getUserData(List ids)async{
    List<UserModel> users=[];
    for(int i=0;i<ids.length;i++){
      print('fid ${ids[i]}');
      await FirebaseFirestore.instance.collection('users').doc(ids[i]).get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {

          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          users.add(UserModel.fromMap(data,documentSnapshot.reference.id));
          print(data);
        }
        else{
          print('${ids[i]} does not exists');
        }

      });

    }

    return users;
  }

  static Future<String> getWebDomain()async{
      String domain='';
      await FirebaseFirestore.instance.collection('info').doc('app_info').get().then((DocumentSnapshot documentSnapshot) async{
        if (documentSnapshot.exists) {

          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          domain=data['domain'];
          print(data);
        }

      });



    return domain;
  }

  static Future<List<UserModel>> getFollowersData(String userId)async{
    List<UserModel> users=[];
    await FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        UserModel model=UserModel.fromMap(data, doc.reference.id);
        if(model.following.contains(userId)){
          users.add(model);
        }
        /*if(FirebaseAuth.instance.currentUser!=null){
          //print('${model.userId!= FirebaseAuth.instance.currentUser!.uid} ${model.following.contains(userId)}');
          if(model.following.contains(userId)){
            users.add(model);
          }
        }
        else {
          if(model.following.contains(userId)){
              users.add(model);
          }
        }*/
      });
    });

    return users;
  }

}