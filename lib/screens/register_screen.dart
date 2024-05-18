import 'package:drivers/screens/Disclaimer.dart';
import 'package:drivers/screens/car_info_screen.dart';
import 'package:drivers/screens/login_screen.dart';
import 'package:drivers/screens/main_screen.dart';
import 'package:drivers/screens/new_trip_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../global/global.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();
  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();
  final carColorTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();


  void _submit() async {
    // validate all the form fields
    if(_formKey.currentState!.validate()) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        if(currentUser != null){
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
            "status": "offline",
            "ratings": "5.0",
            "rid": "free",
            "blockStatus": "no",
            "notesAdmin": "",
            "ratingsCancel": "5",
            "deposit":"0",
          };


          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");
          userRef.child(currentUser!.uid).set(userMap);



        }
        await Fluttertoast.showToast(msg: "Successfully Registered");
        //_savecar();

        Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all field are valid");
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: darkTheme ? Colors.black : Color(0xFFA0BFE0),
          body: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Column(
                children: [
                  Image.asset(darkTheme ? 'images/logo1.png' : 'images/logo1.png'),

                  SizedBox(height: 20,),

                  Text(
                    'REGISTER',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.solid,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2)),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return 'Name can\'t be empty';
                                  }
                                  if(text.length < 2) {
                                    return "Please enter a valid name";
                                  }
                                  if(text.length > 49){
                                    return "Name can\'t be more than 50";
                                  }
                                },
                                onChanged: (text) => setState(() {
                                  nameTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 20,),

                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.solid,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.email, color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2)),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return 'Email can\'t be empty';
                                  }
                                  if(EmailValidator.validate(text) == true){
                                    return null;
                                  }
                                  if(text.length < 2) {
                                    return "Please enter a valid email";
                                  }
                                  if(text.length > 99){
                                    return "Email can\'t be more than 100";
                                  }
                                },
                                onChanged: (text) => setState(() {
                                  emailTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 20,),

                              IntlPhoneField(
                                showCountryFlag: false,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Phone",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.solid,
                                      )
                                  ),
                                ),
                                initialCountryCode: 'PH',
                                onChanged: (text) => setState(() {
                                  phoneTextEditingController.text = text.completeNumber;
                                }),
                              ),

                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Address",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.solid,
                                      )
                                  ),
                                  prefixIcon: Icon(Icons.location_city_outlined, color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2)),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return 'Address can\'t be empty';
                                  }
                                  if(text.length < 2) {
                                    return "Please enter a valid address";
                                  }
                                  if(text.length > 99){
                                    return "Address can\'t be more than 100";
                                  }
                                },
                                onChanged: (text) => setState(() {
                                  addressTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 20,),

                              TextFormField(
                                obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.solid,
                                        )
                                    ),
                                    prefixIcon: Icon(Icons.lock, color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2),
                                      ),
                                      onPressed: () {
                                        // update the state i.e toggle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return 'Password can\'t be empty';
                                  }
                                  if(text.length < 6) {
                                    return "Please enter a valid password";
                                  }
                                  if(text.length > 49){
                                    return "Password can\'t be more than 50";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  passwordTextEditingController.text = text;
                                }),
                              ),

                              SizedBox(height: 20,),

                              TextFormField(
                                obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.solid,
                                        )
                                    ),
                                    prefixIcon: Icon(Icons.lock, color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2),
                                      ),
                                      onPressed: () {
                                        // update the state i.e toggle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return 'Confirm Password can\'t be empty';
                                  }
                                  if(text != passwordTextEditingController.text){
                                    return "Password do not match";
                                  }
                                  if(text.length < 6) {
                                    return "Please enter a valid password";
                                  }
                                  if(text.length > 49){
                                    return "Password can\'t be more than 50";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  confirmTextEditingController.text = text;
                                }),
                              ),


                              SizedBox(height: 20,),




                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: darkTheme ? Colors.amber.shade400 : Color(0xFF4A55A2),
                                    onPrimary: darkTheme ? Colors.black : Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  onPressed: () {
                                    _submit();
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                              ),

                              SizedBox(height: 20,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Have an account?",
                                    style: TextStyle(
                                      color: Color(0xFF1679AB),
                                      fontSize: 15,
                                    ),
                                  ),

                                  SizedBox(width: 5,),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                                    },
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: darkTheme ? Colors.amber.shade400 : Color(0xFF1C1678),
                                      ),
                                    ),
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ), onWillPop: ()=> _onBackButtonPressed(context),);
  }
}

Future<bool> _onBackButtonPressed(BuildContext context) async {
  bool? exitApp= await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Really??"),
          content: const Text("Do you want to close the apps??"),
          actions:<Widget> [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop(false);
              }, child: const Text("No"),
            ),
            TextButton(
              onPressed: (){
                //Navigator.pop(context);
                SystemNavigator.pop();
                // Navigator.of(context).pop(true);
              }, child: const Text("Yes"),
            )
          ],
        );
      }
  );
  return exitApp ?? false;
}
















