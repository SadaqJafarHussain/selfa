import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfa/printing_pdf.dart';
import 'package:selfa/widgets/drawable_widget.dart';
import 'package:selfa/widgets/new_spend.dart';
import 'package:selfa/widgets/spend_card.dart';

import 'logic/provider/data_handling.dart';
import 'models/selfa.dart';
import 'models/spend.dart';

class SelfaDetails extends StatefulWidget {
  const SelfaDetails({super.key, required this.selfa, required this.userId});
  final Selfa selfa;
  final String userId;
  @override
  State<SelfaDetails> createState() => _SelfaDetailsState();
}

class _SelfaDetailsState extends State<SelfaDetails> {

  void _addNewTransaction(
    String to,
    String from,
    double txAmount,
    DateTime chosenDate,
  ) {
    final newTx = Spend(
      image: "fggfgfdgfdgf",
      to: to,
      from: from,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final _provider=Provider.of<DataHandling>(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: DrawableWidget(),
          appBar: AppBar(
            title: Text(
              widget.selfa.title, style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
            ),
            actions: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              },
                  icon: const Icon(Icons.arrow_forward))
            ],
            backgroundColor:const Color(0xfffac13c),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    end: Alignment.topRight,
                    begin: Alignment.bottomLeft,
                    colors: [
                  Color(0xfff9e7e8),
                  Color(0xffd3f6fd),
                ])),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.userId)
                  .collection("userSelaf")
                  .doc(widget.selfa.id)
                  .collection("userSpends")
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xfffac13c),
                    ),
                  );
                } else if (!snap.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'لم تقم باضافة اي سلغة ',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/spend.png'),
                                fit: BoxFit.contain)),
                      ),
                    ],
                  );
                } else {
                  List<Spend> spends = snap.data!.docs.map((doc) {
                    return Spend.fromDocumentSnapshot(doc);
                  }).toList();
                  return SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  print(spends.first.date);
                                  await generateAndPrintArabicPdf(
                                      spends, widget.selfa);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffffffff),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    side: const BorderSide(
                                        color: Color(0xfffac13c), width: 1)),
                                child:const SizedBox(
                                  width: 100,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'طباعة تقرير',
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Icon(Icons.print),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection("users").doc(_provider.firebaseUser.uid).collection("userSelaf").doc(widget.selfa.id).snapshots(),
                          builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> doc){
                            if(doc.connectionState==ConnectionState.waiting){
                              return const CircularProgressIndicator();
                            }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'مبلغ السلفه الكلي',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${doc.data!['amount']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'المبلغ المتبقي',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${doc.data!["restAmount"]}',
                                          style: const TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'المبلغ المصروف',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${doc.data!['spendAmount']} -',
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0, left: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'الصرفيات ',
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'اضافة صرفيه',
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfffac13c),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => NewSpend(
                                                    _addNewTransaction,
                                                    widget.userId,
                                                    widget.selfa.id,
                                                    widget.selfa))),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        snap.data!.docs.isNotEmpty
                            ? Expanded(
                              child: SpendCard(
                              spends: snap.data!.docs.map((spend){
                                return Spend.fromDocumentSnapshot(spend);
                                                      }).toList()),
                            )
                            : SizedBox(
                          height: 500,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'لم تقم بصرف اي مبلغ ',
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/spend.png'),
                                              fit: BoxFit.contain)),
                                    ),
                                  ],
                                ),
                            ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
