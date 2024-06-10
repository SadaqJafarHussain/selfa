import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../models/spend.dart';

class SpendCard extends StatefulWidget {
  final List<Spend> spends ;
  const SpendCard({Key? key,required this.spends}) : super(key: key);
  @override
  State<SpendCard> createState() => _SpendCardState();
}

class _SpendCardState extends State<SpendCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _renderSteps(),
      ),
    );
  }
  Widget _renderSteps() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.spends[index].isExpanded = isExpanded;
        });
      },
      children: widget.spends.map<ExpansionPanel>((Spend _spend) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Column(
                children: [
                const  SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_left,
                        color: Colors.red,
                        size: 13,),
                        Text('قمت بصرف',
                          style: TextStyle(
                            fontSize: 10,
                            color:  Colors.red,
                          ),),
                      ],
                    ),
                  ),
                  Text(' - ${_spend.amount}',
                  style:const TextStyle(
                    fontSize: 15,
                    color:  Colors.black,

                  ),),
                ],
              ),
              title: Text(_spend.from,style:const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,),
              subtitle: Text(_spend.to,style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,),
            );
          },
          body: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Text(
                          "${_spend.from}",style:const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${_spend.to}",style:const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                        ),
                          overflow: TextOverflow.clip,
                          softWrap: true,),
                       const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "تاريخ الصرف :   ${intl.DateFormat.yMMMd().format(_spend.date)}",style:const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                          overflow: TextOverflow.clip,
                          softWrap: true,),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                     const Text(
                        "صورة الوصل ",style:const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                        overflow: TextOverflow.clip,
                        softWrap: true,),
                     const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 1
                            ),
                            image: DecorationImage(
                              image: NetworkImage(_spend.image),
                              fit: BoxFit.contain,
                            )
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          isExpanded:_spend.isExpanded,
        );
      }).toList(),
    );
  }
}