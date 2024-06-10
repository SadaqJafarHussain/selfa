import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'log_in.dart';
import 'logic/provider/data_handling.dart';
import 'my_home_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DataHandling()),
        ],
        child:  MyApp(),
      ));}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool isLogedIn=false;
  @override
  void initState() {
    var user = FirebaseAuth.instance.currentUser;
    //print(' user idddddddddd ::::::::::${user!.uid}');
   if(user==null){
      setState(() {
        isLogedIn=false;
      });
    }else{
      setState(() {
        isLogedIn=true;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      home:isLogedIn?MyHomePage():SignIn(),
    );
  }
}

