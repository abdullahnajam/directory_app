import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/user_model.dart';

class SearchProvider extends ChangeNotifier {

  String filter='Name';
  String country='';
  String city='';
  String social='All';
  String query='';



  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }
  void setCity(String value) {
    city = value;
    notifyListeners();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setCountry(String value) {
    country = value;
    notifyListeners();
  }
  void setSocial(String value) {
    social = value;
    notifyListeners();
  }









}
