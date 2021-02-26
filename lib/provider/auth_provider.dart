
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nimbus/screens/homeScreen.dart';
import 'package:nimbus/services/user_services.dart';

class AuthProvider with ChangeNotifier{
  FirebaseAuth _auth=FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error ='';
  UserServices _userServices=UserServices();

  Future<void>verifyPhone(BuildContext context,String number)async{

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential)async{
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =(FirebaseAuthException e){
      print(e.code);
    };

    final PhoneCodeSent smsOtpSend =(String verId,int resendToken)async{
      this.verificationId=verId;

      smsOtpDialog(context,number);
    };


    try{
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId){
            this.verificationId=verId;
          },
      );

    }catch(e){
      print(e);
    }
  }
  Future<bool>smsOtpDialog(BuildContext context,String number){
    return showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          title: Column(
            children: [
              Text('Verification Code'),
              SizedBox(height: 6,),
              Text('Enter 6 digit OTP received as SMS',
                style: TextStyle(color: Colors.grey,fontSize: 12),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged:(value){
                this.smsOtp=value;
              }
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: ()async{
                try{
                  PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: smsOtp);

                  final User user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                  _createUser(id: user.uid,number: user.phoneNumber);
                  if(user!=null){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context)=>HomeScreen(),
                        )
                    );
                  }else{
                    print('Login Failed');
                  }
                }catch(e){
                  this.error='Invalid OTP';
                  print(e.toString());
                  Navigator.of(context).pop();

                }
              },
              child: Text('DONE'),
            ),
          ],
        );
      }
    );
  }
  void _createUser({String id,String number}){
    _userServices.createUserData({
      'id':id,
      'number':number,
    });
  }
}