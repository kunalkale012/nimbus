import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nimbus/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:nimbus/provider/auth_provider.dart';

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

     final auth=Provider.of<AuthProvider>(context);
    bool _validPhoneNumber=false;
    var _phoneNumberController=TextEditingController();

    void showBottomSheet(context){
      showModalBottomSheet(
        context:context,
        builder:(context)=>StatefulBuilder(
          builder: (context,StateSetter myState){
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOGIN',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text('Enter Your Phone Number to Process',style: TextStyle(fontSize: 12,color: Colors.grey),),
                      SizedBox(height: 20,),
                      TextField(
                        decoration: InputDecoration(
                          prefixText: '+91',
                          labelText: '10 digit mobile number',
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _phoneNumberController,
                        onChanged: (value){
                          if(value.length==10){
                            myState((){
                              _validPhoneNumber=true;
                            });
                          }else{
                            myState((){
                              _validPhoneNumber=false;
                            });

                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: _validPhoneNumber ? false : true,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                color: _validPhoneNumber ? Theme.of(context).primaryColor : Colors.grey,
                                child: Text(_validPhoneNumber ? 'CONTINUE':'ENTER PHONE NUMBER',style: TextStyle(color: Colors.white),),
                                onPressed: (){
                                  String number='+91${_phoneNumberController.text}';
                                  auth.verifyPhone(context, number);
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              // ignore: deprecated_member_use
              child: FlatButton(
                child: Text('SKIP',style: TextStyle(color: Colors.deepOrangeAccent),),
                onPressed: (){},
              ),
            ),
            Column(
              children: [
                Expanded(child: OnBoardScreen(),),
                Text('Ready to Order from your nearest Shop?',style: TextStyle(color: Colors.grey),),
                SizedBox(height: 20,),
                // ignore: deprecated_member_use
                FlatButton(
                  color: Colors.deepOrangeAccent,
                  child: Text('Set Delivery Location',style: TextStyle(color: Colors.white),),
                  onPressed:(){} ,
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: RichText(text: TextSpan(
                    text: 'Already a Customer?',style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          text: 'Login', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                      ),
                    ],
                  ),
                  ),
                  onPressed: (){
                    showBottomSheet(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
