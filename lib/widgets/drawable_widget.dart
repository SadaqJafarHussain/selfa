
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dead_selaf.dart';
import '../logic/auth_class.dart';
import '../logic/provider/data_handling.dart';
import '../my_home_page.dart';
class DrawableWidget extends StatelessWidget {
   DrawableWidget({super.key});
  final authHandler = Auth();
  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<DataHandling>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 100,
              decoration:const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/user.png'),
                    fit: BoxFit.contain,
                  )
              ),
            ),
            Text(_provider.firebaseUser.email!,style:const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=> MyHomePage()));},
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=> MyHomePage()));},
                        icon:const Icon(Icons.attach_money_rounded,color: Colors.green,)),
                    const Text('السلف المضافه',style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=>const DeadSelaf()));},
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>const DeadSelaf()));},
                        icon:const Icon(Icons.attach_money,color: Colors.red,)),
                    const Text('السلف المعطله',style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){ },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){}, icon:const Icon(Icons.account_box_outlined,color: Colors.black,size: 28,)),
                    const Text('انشاء حساب مشاهد',style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){ authHandler.signOut();},
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){authHandler.signOut();}, icon:const Icon(Icons.exit_to_app,color: Colors.red,size: 28,)),
                    const Text('تسجيل خروج',style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
