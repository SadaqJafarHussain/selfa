import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'models/selfa.dart';
import 'models/spend.dart';

Future<void> generateAndPrintArabicPdf(List<Spend> spend,Selfa selfa) async {
  final Document pdf = Document();

  var arabicFont =
      Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  pdf.addPage(Page(
      theme: ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.roll80,
      build: (Context context) {
        return Center(
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Center(
                        child: Text(' ${selfa.restAmount}  ',
                            style: const TextStyle(
                              fontSize: 10,
                            )))),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Center(
                        child:  Text('مبلغ السلفه المتبقي : ',
                            style:const TextStyle(
                              fontSize: 10,
                            )))),
              ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Text('  ${selfa.amount}  ',
                        style: const TextStyle(
                          fontSize: 10,
                        )))),
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child:  Text('مبلغ السلفه الكلي : ',
                        style:const TextStyle(
                          fontSize: 10,
                        )))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Text('  ${selfa.title}',
                        style:const TextStyle(
                          fontSize: 10,
                        )))),
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Text('عنوان السلفه : ',
                        style:const TextStyle(
                          fontSize: 10,
                        )))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Text(' ${selfa.date}',
                        style:const TextStyle(
                          fontSize: 10,
                        )))),
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Text('تاريخ انشاء السلفه : ',
                        style:const TextStyle(
                          fontSize: 10,
                        )))),
          ]),
          Directionality(
              textDirection: TextDirection.rtl,
              child: Text('المصروفات', style:const TextStyle(fontSize: 10))),
          ListView.builder(
            itemCount: spend.length,
            itemBuilder: (context,index){
              return Container(
                  margin: const EdgeInsets.fromLTRB(22, 6, 22, 5),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Table.fromTextArray(
                      headerStyle:const TextStyle(fontSize: 6),
                      headers: <dynamic>['تاريخ الصرف', 'الغرض من الصرف', 'سبب الصرف', 'المبلغ المصروف'],
                      cellAlignment: Alignment.center,
                      cellStyle:const TextStyle(fontSize: 5),
                      data: <List<dynamic>>[
                        <dynamic>['${spend[index].date}', spend[index].to, spend[index].from, '${spend[index].amount}'],
                      ],
                    ),
                  ),
                );
            }
          )
        ]));
      }));
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/1.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}
