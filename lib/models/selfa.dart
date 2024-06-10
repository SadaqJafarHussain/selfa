import 'package:cloud_firestore/cloud_firestore.dart';

class Selfa {
  final String title;
  final double amount;
  double restAmount;
  double spendAmount;
  final DateTime date;
  final String id;
  bool isOff;

  Selfa({
    required this.restAmount,
    required this.spendAmount,
    required this.isOff,
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
  factory Selfa.fromDocumentSnapshot(QueryDocumentSnapshot doc)=>Selfa(
    spendAmount:double.parse(doc['spendAmount'].toString()),
    restAmount:double.parse(doc['restAmount'].toString()),
    isOff: doc['isOff'],
    id: doc.id,
    title: doc['title'],
    amount: double.parse(doc['amount'].toString()),
    date: doc['date'].toDate()
  );
}
