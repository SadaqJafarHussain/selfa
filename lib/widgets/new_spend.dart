import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../logic/provider/data_handling.dart';
import '../models/selfa.dart';

class NewSpend extends StatefulWidget {
  final Function addTx;
  final String userId;
  final String id;
  final Selfa selfa;

  NewSpend(this.addTx,this.userId,this.id,this.selfa);

  @override
  _NewSpendState createState() => _NewSpendState();
}

class _NewSpendState extends State<NewSpend> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _selectedDate;
  bool noFrom = false;
  bool noTo = false;
  bool noAmount = false;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = image != null ? XFile(image.path) : null;
    });
  }
  bool loading = false;
  String imgUrl='';
  bool pickImage=false;

  Future<void> sendData()async{
    final _provider=Provider.of<DataHandling>(context,listen: false);

    String uniqueName= DateTime.now().millisecondsSinceEpoch.toString();
    Reference refRoot=FirebaseStorage.instance.ref();
    Reference refImages=refRoot.child('images');
    Reference refImageToUpload=refImages.child(uniqueName);
    try{
      setState(() {
        loading = true;
      });
    await refImageToUpload.putFile(File(_pickedImage!.path));
   imgUrl= await refImageToUpload.getDownloadURL();
      try {
        CollectionReference selaf =
        FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('userSelaf');
        // Call the user's CollectionReference to add a new user
        await selaf.doc(widget.id).collection("userSpends").doc().set({
          'spendFrom': _fromController.text,
          'spendTo':_toController.text,
          'amount': _amountController.text,
          "date":_selectedDate,
          'image':imgUrl,
        });
        await _provider.updateAmount(id: widget.id, userId: widget.userId, spendAmount: _amountController.text, selfa: widget.selfa);
      } catch (e) {
        print('there is an error the error is $e');
      }
      setState(() {
        loading = false;
      });
    }catch(error){
      print("hello catch");
    print (error);
    }
  }

  Future<void> updateAmount()async {
    try {
      CollectionReference selaf =
      FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await selaf.doc(widget.userId).collection("userSelaf").doc(widget.id).update({
        'restAmount':widget.selfa.amount-widget.selfa.restAmount-int.parse(_amountController.text),
        'spendAmount':widget.selfa.spendAmount+int.parse(_amountController.text)
      });
      print('its doneeeeeeeeeeeeeeeeee');
    } catch (e) {
      print('there is an error the error is $e');
    }
  }

  Future<void> _captureImageFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = image != null ? XFile(image.path) : null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedDate = DateTime.now();
    super.initState();
  }

  void _submitData() async{
    final fromTitle = _fromController.text;
    final toTitle = _toController.text;
    final enteredAmount = double.tryParse(_amountController.text);
    if (_amountController.text.isEmpty || enteredAmount! <= 0) {
      setState(() {
        noAmount = true;
      });
      return;
    }

    if (fromTitle.isEmpty ) {
      setState(() {
        noFrom = true;
      });
      return;
    }
    if (toTitle.isEmpty) {
      setState(() {
        noTo = true;
      });
      return;
    }
    if(_pickedImage==null){
      setState(() {
        pickImage=false;
      });
      return;
    }else {
      setState(() {
        pickImage=true;
      });
      await sendData();
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
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Directionality(
            textDirection: TextDirection.rtl,
            child: Card(
              elevation: 5,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.topRight,
                        begin: Alignment.bottomLeft,
                        colors: [
                          Color(0xfff9e7e8),
                          Color(0xffd3f6fd),
                        ]
                    )
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الجهه المصروف لها',
                        labelStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.grey,
                        )
                      ),
                      controller: _fromController,
                      onSubmitted: (_) => _submitData(),
                      // onChanged: (val) {
                      //   titleInput = val;
                      // },
                    ),
                    noFrom? const Text('الجهه المصروف لها مطلوبه',style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),):Container(),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الغرض من الصرف',
                          labelStyle: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.grey,
                          )
                      ),
                      controller: _toController,
                      onSubmitted: (_) => _submitData(),
                      // onChanged: (val) {
                      //   titleInput = val;
                      // },
                    ),
                    noTo? const Text('الغرض مطلوب',style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),):Container(),
                    TextField(
                      decoration: const InputDecoration(labelText: 'المبلغ المصروف ',
                          labelStyle: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.grey,
                          )),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submitData(),
                      // onChanged: (val) => amountInput = val,
                    ),
                    noAmount?const Text('المبلغ المصروف مطلوب',style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),):Container(
                      height: 20,
                    ),
                  _pickedImage==null? Column(
                     children: [
                       const Text('قم برفع صورة الوصل',
                         style: TextStyle(
                             color: Colors.black54,
                             fontFamily: 'Cairo',
                             fontSize: 15,
                             fontWeight: FontWeight.bold
                         ),),
                       InkWell(
                         onTap: (){
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 title:SizedBox(
                                   child: Column(
                                     children: [
                                       const Text('اختيار صورة الوصل',style: TextStyle(
                                         fontFamily: 'Cairo',
                                         fontSize: 20,
                                       ),),
                                      const SizedBox(height: 15,),
                                       Container(
                                         height: 3,
                                         color: const Color(0xff80cbc4),
                                       ),
                                     ],
                                   ),
                                 ),
                                 content: Builder(
                                   builder: (context){
                                     return SizedBox(
                                       height: 140,
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           InkWell(
                                             onTap:(){
                                               _pickImageFromGallery();
                                               Navigator.pop(context);
                                             },
                                             child:const Row(
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 Icon(Icons.image,
                                                   size: 50,
                                                   color:  Color(0xfffac13c),),
                                                 Text('صورة من الاستوديو',
                                                   style: TextStyle(
                                                       fontFamily: 'Cairo',
                                                       color: Colors.black,
                                                       fontSize: 20
                                                   ),),
                                               ],
                                             ),
                                           ),
                                           const SizedBox(height: 10,),
                                           Container(height: 1,
                                             color: Colors.grey,),
                                           const SizedBox(height: 10,),
                                           InkWell(
                                             onTap:(){
                                               _captureImageFromCamera();
                                               Navigator.pop(context);
                                             },
                                             child:const Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               children: [
                                                 Icon(Icons.add_a_photo,
                                                   color:  Color(0xfffac13c),
                                                   size: 50,),
                                                 Text('صورة من الكاميرا',
                                                   style: TextStyle(
                                                       fontFamily: 'Cairo',
                                                       color: Colors.black,
                                                       fontSize: 20
                                                   ),),
                                               ],
                                             ),
                                           ),
                                         ],
                                       ),
                                     );
                                   },
                                 )
                               );
                             },
                           );
      
                         },
                         child: Container(
                           height: 250,
                           width: 250,
                           decoration:const BoxDecoration(
                               image: DecorationImage(
                                 image: AssetImage('assets/images/upload.png'),
                               )
                           ),
                         ),),
                     ],
                   ):Image.file(
                    File(_pickedImage!.path),
                    height: 200,
                  ),
      
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Chosen!'
                                  : 'تاريخ الصرف : ${intl.DateFormat.yMd().format(_selectedDate)}',
                              style:const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15
                              ),),
                          ),
                          IconButton(
                              onPressed:  _presentDatePicker,
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
                        child:loading?const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ): const Text(
                          'اضافة صرفيه ',
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
                  ),
          ),
      ),
    );
  }
}
