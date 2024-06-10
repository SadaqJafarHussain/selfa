import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfa/widgets/selfa_card.dart';

import 'logic/provider/data_handling.dart';
import 'models/selfa.dart';

class DeadSelaf extends StatelessWidget {
  const DeadSelaf({super.key});




  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<DataHandling>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'السلف المعطله', style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        ),
        backgroundColor:const Color(0xfffac13c),
      ),
      body: Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.topRight,
                begin: Alignment.bottomLeft,
                colors: [
                  Color(0xfff9e7e8),
                  Color(0xffd3f6fd),
                ]
            )
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(_provider.firebaseUser.uid).collection("userSelaf").where('isOff',isEqualTo: true).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snap){
            if(snap.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xfffac13c),
                ),
              );
            }else if (!snap.hasData||snap.data==null||snap.data!.docs.isEmpty){
              return  SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('لم تقم بتعطيل اي سلفة ',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),),
                   const SizedBox(height: 40,),
                    Container(
                      height: 200,
                      width: 200,
                      decoration:const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/waiting.png'),
                              fit: BoxFit.contain
                          )
                      ),
                    ),
                  ],
                ),
              );
            }else {
              return ListView(
                children: snap.data!.docs.map((doc) {
                  return SelfaCard(Selfa.fromDocumentSnapshot(doc),_provider.firebaseUser.uid,true);
                }).toList(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
