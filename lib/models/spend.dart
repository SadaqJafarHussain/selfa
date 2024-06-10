
import 'package:cloud_firestore/cloud_firestore.dart';

class Spend {
  final String id;
  final String from;
  final String to;
  final double amount;
  final DateTime date;
  final String image;
  bool isExpanded=false;

  Spend({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.date,
    required this.image,
  });
  factory Spend.fromDocumentSnapshot(QueryDocumentSnapshot doc)=>Spend(
      image: doc['image'],
      id: doc.id,
      from: doc['spendFrom'],
      to: doc['spendTo'],
      amount: double.parse( doc['amount'].toString()),
      date: doc['date'].toDate()
  );

}