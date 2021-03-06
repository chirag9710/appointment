import 'dart:convert';
import 'dart:io';
import 'package:appointment/home/Home.dart';
import 'package:appointment/utils/DBProvider.dart';
import 'package:appointment/utils/RoundShapeButton.dart';
import 'package:appointment/utils/values/Constant.dart';
import 'package:appointment/utils/values/Dimen.dart';
import 'package:appointment/utils/values/Strings/Strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

SharedPreferences _sharedPreferences;

class _LoginState extends State<Login> with SingleTickerProviderStateMixin{
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // checkIfLogin();
    super.initState();
      setValue();
  }
  var _value;
  String text;
  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child:  Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(right:19,top: 35),
          alignment: Alignment.topRight,
          child:  GestureDetector(
            child: Container(
              width: 86,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(text??"",textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    child: Icon(Icons.language,color: Colors.black.withOpacity(0.7),),
                  ),
                ],
              ),
            ),
            onTap: () {
              _showPopupMenu(context);
            },
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: Dimen().dp_20,right: Dimen().dp_20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: Image.asset('images/appointment.png',height: 100,width: 100,),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Text(Resources.from(context,Constant.languageCode).strings.title,
                          textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'poppins_regular',fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50,),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text( Resources.from(context,Constant.languageCode).strings.signInText,style: TextStyle(
                            fontSize: 16,fontFamily: 'poppins_medium'
                        ),),
                      ),
                      Center(
                        child: Container(
                            width: 200,
                            height: 40,
                            child:RoundShapeButton(
                              onPressed: () async {
                                try {
                                  final result = await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                    signInWithGoogle();
                                  }
                                } on SocketException catch (_) {
                                  Constant.showToast(Resources.from(context, Constant.languageCode).strings.checkInternet, Toast.LENGTH_SHORT);
                                }

                              },
                              width: 1,
                              color: Colors.white,
                              text: Resources.from(context,Constant.languageCode).strings.googleBtnText,radius: 25,
                              icon: Image.asset('images/search.png',width: 20,height: 20,),)
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 200,
                        height: 40,
                        child:RoundShapeButton(text: Resources.from(context,Constant.languageCode).strings.outLookBtnText,
                          width: 1,
                          color: Colors.white,
                          onPressed: (){
                            // Navigator.pushReplacement(context, MaterialPageRoute(
                            //   builder: (_) => Home(),
                            // ));
                            // toast.overLay = false;
                            // toast.showOverLay("Coming Soon!", Colors.white, Colors.black54, context);

                          },radius: 25,
                          icon: Image.asset('images/outlook.png',height: 20,width: 20),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width, 45, 0, 00),
      items: [
        PopupMenuItem(
          value: 0,
          child: Container(
            alignment: Alignment.center,
            child: Text('English',style: TextStyle(fontSize: 12,color: text =="English"?Colors.blue:Colors.black),),
          ),
          // enabled: enable1,
        ),
        PopupMenuItem(
          value: 1,
          child: Container(
              alignment: Alignment.center,
              child: Text("हिन्दी",style: TextStyle(fontSize: 12,color: text =="हिन्दी"?Colors.blue:Colors.black))),
          // enabled: enable2,
        ),
        PopupMenuItem(
          value: 2,
          child: Container(
              alignment: Alignment.center,
              child: Text("ગુજરાતી",style: TextStyle(fontSize: 12,color: text =="ગુજરાતી"?Colors.blue:Colors.black))),
          // enabled: enable3,
        ),
      ],
      elevation: 8.0,
    ).then((value){
      if(value!=null)
        print(value);
      if(value == 0){
        setState(() {
          text = "English";
          Constant.languageCode = 'en';
          languageCode(code: Constant.languageCode);
        });
      }
      if(value == 1){
        setState(() {
          text = "हिन्दी";
          Constant.languageCode = 'hi';
          languageCode(code: Constant.languageCode);
        });
      }
      if(value == 2){
        setState(() {
          text = "ગુજરાતી";
          Constant.languageCode = 'gu';
          languageCode(code: Constant.languageCode);
        });
      }
    });
  }

  Future<void> languageCode({String code})async{
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(Constant().languageKey, code);
  }

  setValue()async{
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      switch(_sharedPreferences.getString(Constant().languageKey)){
        case 'gu':
        // setState(() {
        //   text = "ગુજરાતી";
        //   selectedIndex =2;
        // });
        //  break;
          return text = "ગુજરાતી";
        case 'hi':
        // text = "हिन्दी";
        // selectedIndex = 1;
        // break;
          return text = "हिन्दी";
        default:
        // text = "English";
        // selectedIndex = 0;
        // break;
          return text = "English";
      }
    });
  }

  // checkIfLogin()async{
  //   _sharedPreferences = await SharedPreferences.getInstance();
  //   if(_sharedPreferences.getBool('isLogin')==true){
  //     Navigator.pushReplacement(context, MaterialPageRoute(
  //         builder: (_) => Home()
  //     ));
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ["email","https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/calendar"],
    clientId: "721999277841-t1gh7nmsj7ild9f1gvmrfiubvtmto6oi.apps.googleusercontent.com",
  );

  static Map<String, dynamic> parseJwt(String token) {
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final idToken = googleSignInAuthentication.idToken;

    Map<String, dynamic> idMap = parseJwt(idToken);

    final String firstName = idMap["given_name"];
    final String lastName = idMap["family_name"];

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    print("Access Token ==> ${googleSignInAuthentication.accessToken}");
    print("Id Token ==> ${googleSignInAuthentication.idToken}");


    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    if(user!=null){
      Constant.email = user.email;
      Constant.token = googleSignInAuthentication.accessToken;
      _sharedPreferences.setBool('isLogin',true);
      update(firstName, lastName, user.email, 'Google', googleSignInAuthentication.idToken, googleSignInAuthentication.accessToken,user.displayName,user.photoUrl);
    }
    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();
    print("User Sign Out");
  }

  void update(String fName,String lName,String email,String loginType,String idToken,String accessToken,String name,String photoUrl) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnfName: fName,
      DatabaseHelper.columnlName: lName,
      DatabaseHelper.columnEmail: email,
      DatabaseHelper.columnIsLoginWith: loginType,
      DatabaseHelper.columnAccessToken : accessToken,
      DatabaseHelper.columnIdToken : idToken,
      DatabaseHelper.columnPhotoUrl : photoUrl
    };

    final data = await dbHelper.select(email);

    if (data.length != 0) {
      dbHelper.update(row, data[0]['_id']);

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => Home()
      ));
    }
    else {
      insertWithSocial(fName, lName, email, loginType,idToken,accessToken,photoUrl);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => Home()
      ));
    }
  }

  void insertWithSocial(String fName,String lName,String email,String loginType,String idToken,String accessToken,
      String photoUrl){
    Map<String, dynamic> row = {
      DatabaseHelper.columnfName : fName,
      DatabaseHelper.columnlName : lName,
      DatabaseHelper.columnEmail : email,
      DatabaseHelper.columnIsLoginWith : loginType,
      DatabaseHelper.columnAccessToken : accessToken,
      DatabaseHelper.columnIdToken : idToken,
      DatabaseHelper.columnPhotoUrl : photoUrl
    };
    dbHelper.insert(row);
  }

}