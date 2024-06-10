import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;


class NewSelfa extends StatefulWidget {
final String uid;
  NewSelfa(this.uid);

  @override
  _NewSelfaState createState() => _NewSelfaState();
}

class _NewSelfaState extends State<NewSelfa> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _selectedDate;
  bool noName = false;
  bool noAmount = false;
  bool isOff=false;
  @override
  void initState() {
    // TODO: implement initState
    _selectedDate = DateTime.now();
    super.initState();
  }

  addToFirebase(String txTitle, double txAmount, DateTime chosenDate,String uid,)async{
    try {
      CollectionReference selaf =
      FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await selaf.doc(uid).collection("userSelaf").doc().set({
        'title': txTitle,
        'amount': txAmount,
        "date":chosenDate,
        'isOff':isOff,
        'restAmount':txAmount,
        'spendAmount':0
      });
    } catch (e) {
      print('there is an error the error is $e');
    }
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);
    if (_amountController.text.isEmpty|| enteredAmount! <= 0) {
      setState(() {
        noAmount = true;
      });
      return;
    }
    else if (enteredTitle.isEmpty ) {
      setState(() {
        noName = true;
      });
      return;
    }
    else{
      addToFirebase(_titleController.text, double.parse(_amountController.text),
          _selectedDate, widget.uid);
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                    labelText: 'اسم السلفة',
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.grey,
                    )
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              noName? const Text('عنوان السلفه مطلوب',style: TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),):Container(),
              TextField(
                decoration: const InputDecoration(labelText: 'مبلغ السلفة ',
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.grey,
                    )),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              noAmount?const Text('مبلغ السلفه مطلوب',style: TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),):Container(),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'تاريخ الانشاء : ${intl.DateFormat.yMd().format(_selectedDate)}',
                      style:const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15
                      ),),
                    ),
                   IconButton(
                       onPressed: _presentDatePicker,
                       icon: const Icon(Icons.date_range,
                       size: 40,
                       color: Color(0xff80cbc4),)),
                  ],
                ),
              ),
             const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xfffac13c)),
                  ),
                  child: const Text(
                    'اضافة السلفة ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: Colors.black,
                        fontFamily: 'Cairo'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
