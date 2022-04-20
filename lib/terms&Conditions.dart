
import 'package:flutter/material.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({Key? key}) : super(key: key);

  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Image.asset('assets/back.png'),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(

        margin: EdgeInsets.fromLTRB(20, 00, 00, 00),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,


          children: [



            Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [

                SizedBox(   height: 60,
                    width: 60,
                    child: Image.asset('assets/termsAndConditionColorful.png')),

                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text("Terms & Conditions", textAlign: TextAlign.start,  style: TextStyle(
                    color: Colors.pink, fontSize: 22, fontWeight: FontWeight.bold,
                  ),),
                )


              ],
            ),

            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text("Terms & Conditions", textAlign: TextAlign.left,  style: TextStyle(
              color: Colors.pink, fontSize: 18, fontWeight: FontWeight.bold,
            ),),

           Padding(
             padding: EdgeInsets.all(10),
           ),
            Text("Provide accurate information to Amazon and our customers at all "
                "times Act fairly and not misuse Amazon’s features or services Not attempt to damage or abuse another Seller, their listings or ratings"
               " Not attempt to influence customers’ ratings, feedback, and reviews"
              "  Not send unsolicited or inappropriate communications"
                "Not contact customers except through Buyer-Seller Messaging"
              "  Not attempt to circumvent the Amazon sales process"
                "Not operate more than one selling account on Amazon without a legitimate business need"
                "Not engage in conduct that violates price fixing laws", textAlign: TextAlign.left,  style: TextStyle(
               fontSize: 18, fontWeight: FontWeight.normal
            ),),
          ],
        ),
      ),


    );
  }
}
