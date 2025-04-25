import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with WidgetsBindingObserver {
  final _formkey = GlobalKey<FormState>();
  final _emailTextState = ObjectKey(TextFormField);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _dbService = dbService.value; 
  final _authService = AuthService();
  bool _usernameAvailable = true; 
  bool _emailAvailable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Logo or Logo Name
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
              ),
              child: Center(
                child: Text(
                  'Receiptify',
                  style: Theme.of(context).textTheme.headlineLarge
                ),
              ),
            ),
            
            //User Input fields 
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 55,right: 55),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  spacing: 15,
                  children: [

                    //Username Field
                    TextFormField( 
                      controller: _usernameController,
                      validator: 
                       MultiValidator([ 
                          RequiredValidator( 
                            errorText: 'Please enter a Username'), 
                          MinLengthValidator(8, 
                            errorText:
                              'Username must be at least 8 digits'),
                          MaxLengthValidator(16,
                            errorText:
                              'Username cannot be longer than 16 digits'), 
                          PatternValidator(r'^[a-zA-Z0-9]+$', 
                            errorText:
                              'Username cannot contain any special characters'),
                        ]).call,
                      decoration: InputDecoration( 
                        hintText: 'Username', 
                        labelText: 'Username', 
                        prefixIcon: Icon( 
                          Icons.account_circle_outlined, 
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
                
                    //Email field
                    TextFormField(
                      key: _emailTextState,
                      controller: _emailController, 
                      validator: MultiValidator([ 
                        RequiredValidator( 
                            errorText: 'Enter email address'), 
                        EmailValidator( 
                            errorText: 
                                'Please correct email field'), 
                      ]).call, 
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
                    ),
                    //Password Field
                    TextFormField( 
                      obscureText: true,
                      controller: _passwordController,
                      validator: MultiValidator([ 
                        RequiredValidator( 
                          errorText: 'Please enter a Password'), 
                        MinLengthValidator(8, 
                          errorText: 
                            'Password must be atleast 8 digits'), 
                        PatternValidator(r'(?=.*?[?#!@$%^&*-])', 
                          errorText: 
                            'Password must contain atleast one special character')
                      ]).call,
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
                    //Confirm Password field
                    TextFormField( 
                      obscureText: true,
                      validator: (val) => MatchValidator(errorText: 'Passwords do not match').validateMatch(val!, _passwordController.text),
                      decoration: InputDecoration( 
                      hintText: 'Confirm Password', 
                      labelText: 'Confirm Password', 
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
                    _usernameAvailable ? const Text("") : const Text("Username not available", style: TextStyle(color: Colors.red)),
                    _emailAvailable ? const Text("") : const Text("Email already in use", style: TextStyle(color: Colors.red))
                  ],
                ),
              ),
            ),
            //Create the Login Button
            Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 50, right: 50),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom (
                        backgroundColor: const Color.fromARGB(255, 62, 92, 118),
                        foregroundColor: const Color.fromARGB(255, 13, 19, 33), 
                      ),
                      onPressed: () async {
                        bool currUserAvail = await _dbService.availableUsername(_usernameController.text);
                        bool currEmailAvail = await _dbService.availableEmail(_emailController.text);
                        if(currUserAvail != _usernameAvailable) {
                          setState(() {_usernameAvailable = currUserAvail;});
                        }
                        if(currEmailAvail != _emailAvailable) {
                          setState(() {_emailAvailable = currEmailAvail;});
                        }
                        if(!currUserAvail || !_emailAvailable) {
                          return; 
                        }
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          try {
                            await _authService.signup(
                              email: _emailController.text, password: _passwordController.text
                            );
                            await _dbService.createUserDoc(
                              email: _emailController.text,
                              username: _usernameController.text,
                              uuid: _authService.currentUser!.uid
                            );
                            if(mounted){
                              context.pop();
                            }
                          } on FirebaseAuthException catch (e) {
                            if(e.code == 'email-already-in-use') {
                              setState(() {
                                _emailAvailable = false; 
                              });
                            }
                          }
                        }
                      },
                      child: const Text('Sign up')
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle(color: const Color.fromARGB(255, 62, 92, 118)),
                          ),
                          TextSpan(
                            text: '  Log in',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _formkey.currentState?.reset();
                                context.pop();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}