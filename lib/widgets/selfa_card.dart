import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/provider/data_handling.dart';
import '../models/selfa.dart';
import 'package:intl/intl.dart' as intl;

import '../selfa_details.dart';

enum Option {
  first,
  second,
}



class SelfaCard extends StatelessWidget {
  final Selfa transaction;
  final String userId;
  final bool isOff;

  String str(Option option) {
    switch (option) {
      case Option.first:
        return isOff? "حذف السلفه" :'تعديل السلفه';
      case Option.second:
        return isOff? 'تفعيل السلفة':'تعطيل السلفه';
    }
  }
  SelfaCard(this.transaction,this.userId,this.isOff);

 Future<void> updateSelfa() async {
   try {
     CollectionReference selaf =
     FirebaseFirestore.instance.collection('users');
     // Call the user's CollectionReference to add a new user
     await selaf.doc(userId).collection("userSelaf").doc(transaction.id).update({
       'isOff':!isOff,
     });
     print('its doneeeeeeeeeeeeeeeeee');
   } catch (e) {
     print('there is an error the error is $e');
   }
  }
   Option? _option;

  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<DataHandling>(context);
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: Card(
          color:isOff?Colors.red : const Color(0xffffffff),
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: InkWell(
                onTap:isOff? null :() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              SelfaDetails(selfa: transaction,userId: userId,)));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(transaction.title,style:const TextStyle(fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                          PopupMenuButton<Option>(
                            onSelected: (o)async{
                              if(o==Option.first){
                                if(isOff){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: AlertDialog(
                                          title: const Text('حذف السلفه',style: TextStyle(
                                            fontFamily: 'Cairo'
                                          ),),
                                          content: const Text('هل انت متأكد من حذف هذه السلفه لن تتمكن من استرجاعها بعد ذلك ؟',style:TextStyle(
                                              fontFamily: 'Cairo'
                                          ),),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('الغاء',style:TextStyle(
                                                  fontFamily: 'Cairo'
                                              ),),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('حذف',style:TextStyle(
                                                  fontFamily: 'Cairo'
                                              ),),
                                              onPressed: () async{
                                                await _provider.deletSelfa(transaction);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                                else{

                                }
                              }else if(o==Option.second){
                                updateSelfa();
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                for (final option in Option.values)
                                  PopupMenuItem(
                                    value: option,
                                    child: Text(str(option),style:const TextStyle(
                                      fontFamily: 'Cairo'
                                    ),),
                                  ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('مبلغ السلفه الكلي',style: TextStyle(fontFamily: 'Cairo',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${transaction.amount}',style:const TextStyle(fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  const  SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('مبلغ السلفه المتبقي',style: TextStyle(fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(' ${transaction.restAmount}',style: TextStyle(fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:isOff? Colors.white:Colors.green),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('مبلغ السلفه المصروف',style: TextStyle(fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(' - ${transaction.spendAmount}',style: TextStyle(fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:isOff? Colors.amberAccent:Colors.deepOrange),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('تاريخ انشاء السلفه',style: TextStyle(fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(' ${intl.DateFormat.yMMMd().format(transaction.date)}',style:const TextStyle(fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert Dialog Title'),
          content: const Text('This is the content of the alert dialog.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Handle the confirm action
              },
            ),
          ],
        );
      },
    );
  }

}
