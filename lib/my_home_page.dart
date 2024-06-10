import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfa/widgets/drawable_widget.dart';
import 'package:selfa/widgets/new_selfa.dart';
import 'package:selfa/widgets/selfa_card.dart';
import 'logic/auth_class.dart';
import 'logic/provider/data_handling.dart';
import 'models/selfa.dart';

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final authHandler = Auth();

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewSelfa(Provider.of<DataHandling>(context).firebaseUser.uid),
        );
      },
    );
  }
  String mail='';
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    Provider.of<DataHandling>(context,listen: false).getUser();
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  var _provider=Provider.of<DataHandling>(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: DrawableWidget(),
          appBar: AppBar(
            title: const Text(
              'سلفة الحسابات', style: TextStyle(
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       const Text('السلف',style:const TextStyle(fontFamily: 'Cairo',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                       Row(
                         children: [
                           const Text('اضافة سلفه',
                             style: TextStyle(
                                 fontFamily: 'Cairo',
                                 fontSize: 15,
                                 fontWeight: FontWeight.bold
                             ),),
                           Container(
                             margin:const EdgeInsets.all(5),
                             decoration: BoxDecoration(
                                 color:const Color(0xff80cbc4),
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: IconButton(
                               icon: const Icon(Icons.add),
                               onPressed: () => _startAddNewTransaction(context),
                             ),
                           ),
                         ],
                       )
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(_provider.firebaseUser.uid).collection("userSelaf").where('isOff',isEqualTo: false).snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snap){
                    if(snap.connectionState==ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xfffac13c),
                        ),
                      );
                    }else if (!snap.hasData||snap.data==null||snap.data!.docs.isEmpty){
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         const Text('لم تقم باضافة اي سلفة ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                          ),),
                          Container(
                            height: 200,
                            width: 200,
                            decoration:const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/selfa.png'),
                                fit: BoxFit.contain
                              )
                            ),
                          ),
                        ],
                      );
                    }else if(snap.hasData){
                      return Expanded(
                        child: ListView(
                          children: snap.data!.docs.map((doc) {
                            return SelfaCard(Selfa.fromDocumentSnapshot(doc),_provider.firebaseUser.uid,false);
                          }).toList(),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
