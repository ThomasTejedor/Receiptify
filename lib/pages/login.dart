import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _formkey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _invalidEntry = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  void movePage() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if(mounted) {
      context.pop();
    }
  }
  Widget _buildUI() {
    String _email = '';
    String _password = '';
    if(_authService.currentUser != null) {
      movePage();
    }
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          //Logo or Logo Name
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Center(
              child: const Text(
                'Receiptify',
                style: TextStyle( 
                  color: Color.fromARGB(255, 240, 235, 216),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
          ),
          //Area for user input and login button
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 50
            ),
            child: Form(
              key: _formkey,
              child: Column(
                
                children: [
                  //Create the email user text input
                  Padding( 
                    padding: const EdgeInsets.all(12.0), 
                    child: TextFormField( 
                      validator: MultiValidator([ 
                        RequiredValidator( 
                            errorText: 'Enter email address'), 
                        EmailValidator( 
                            errorText: 
                                'Please correct email field'), 
                      ]).call,
                      //Saves the user inputted email into the variable _email
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration( 
                        hintText: 'Email', 
                        labelText: 'Email', 
                        prefixIcon: Icon( 
                          Icons.email, 
                          //color: Colors.green, 
                        ), 
                        errorStyle: TextStyle(fontSize: 10.0), 
                        border: OutlineInputBorder( 
                          borderSide: 
                            BorderSide(color: Colors.red), 
                          borderRadius: BorderRadius.all( 
                            Radius.circular(9.0)
                          )
                        )
                      )
                    )
                  ),
                  //Create the password user input field
                  Container( 
                    padding: const EdgeInsets.all(12.0), 
                    color: Color(0x00000000),
                    child: TextFormField( 
                      obscureText: true,
                      validator: MultiValidator([ 
                        RequiredValidator( 
                          errorText: 'Please enter a Password') 
                      ]).call,
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration( 
                        hintText: 'Password', 
                        labelText: 'Password', 
                        prefixIcon: Icon( 
                          Icons.key, 
                        ), 
                        errorStyle: TextStyle(fontSize: 10.0), 
                        border: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.red), 
                          borderRadius: 
                            BorderRadius.all(
                              Radius.circular(9.0)
                            )
                        ), 
                      ), 
                    ), 
                  ),
                  _invalidEntry
                  ? Text("Invalid username or password", style: TextStyle(color: Colors.red))
                  : Text(""),
                  //Create the Login Button
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom (
                          backgroundColor: const Color.fromARGB(255, 62, 92, 118),
                          foregroundColor: const Color.fromARGB(255, 13, 19, 33),
                          
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            try {
                              await _authService.login(email: _email, password: _password); 
                              setState(() {_invalidEntry = false;});
                            } on FirebaseAuthException catch (e) {
                              if(e.code == 'invalid-credential'){
                                setState(() {_invalidEntry = true;});
                              }
                            }
                          }
                        },
                        child: const Text('Login')
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dont have an account?',
                            style: TextStyle(color: const Color.fromARGB(255, 62, 92, 118)),
                          ),
                          TextSpan(
                            text: '  Sign up',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _formkey.currentState?.reset();
                                context.push('/signup').whenComplete(() {
                                  setState(() {});
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ]
      ),
    );

  }
  
}