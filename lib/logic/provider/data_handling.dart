

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../models/selfa.dart';

class DataHandling with ChangeNotifier{
  double spendAmount=0;
  double restAmount=0;
   User firebaseUser= FirebaseAuth.instance.currentUser!;

  getUser(){
    var user = FirebaseAuth.instance.currentUser;
      firebaseUser=user!;
      notifyListeners();
     }

  Future<void> updateSelfa(Selfa sel)async{
    try {
      CollectionReference selaf =
      FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await selaf.doc(firebaseUser.uid).collection("userSelaf").doc(sel.id).update({
        'title': sel.title,
        'amount': sel.amount,
        "date":sel.date,
        'isOff':false,
        'restAmount':sel.restAmount,
        'spendAmount':sel.spendAmount
      });
      print('its doneeeeeeeeeeeeeeeeee');
      notifyListeners();
    } catch (e) {
      print('there is an error the error is $e');
    }

  }

  Future<void> deletSelfa(Selfa selfa)async{
    try {
      CollectionReference selaf =
      FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await selaf.doc(firebaseUser.uid).collection("userSelaf").doc(selfa.id).delete();
      print('its doneeeeeeeeeeeeeeeeee');
      notifyListeners();
    } catch (e) {
      print('there is an error the error is $e');
    }
  }

  Future<void> updateAmount({required String id, required String userId,required String spendAmount,required Selfa selfa})async {
    restAmount=selfa.amount-int.parse(spendAmount);
    this.spendAmount=double.parse(selfa.spendAmount.toString())+double.parse(spendAmount.toString());
    try {
      CollectionReference selaf =
      FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await selaf.doc(userId).collection("userSelaf").doc(id).update({
        'restAmount':restAmount,
        'spendAmount':this.spendAmount
      });
      print('its doneeeeeeeeeeeeeeeeee');
      notifyListeners();
    } catch (e) {
      print('there is an error the error is $e');
    }
  }
}