import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
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
              child: Text(
                'Receiptify',
                style: Theme.of(context).textTheme.headlineLarge
              ),
            ),
          ),
          //Area for user input and Signup button
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 50
            ),
            child: Form(
              key: _formkey,
              child: Column(
                
                children: [
                  Container( 
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0), 
                    color: Color(0x00000000),
                    child: TextFormField( 
                      controller: _usernameController,
                      validator: MultiValidator([ 
                        RequiredValidator( 
                          errorText: 'Please enter a Username'), 
                        MinLengthValidator(10, 
                          errorText: 
                            'Username must be at least 10 digits'),
                        MaxLengthValidator(16,
                          errorText:
                            'Username cannot be longer than 16 digits'), 
                        PatternValidator(r'^[a-zA-Z0-9]+$', 
                          errorText: 
                            'Username cannot contain any special characters') 
                      ]).call,
                      decoration: InputDecoration( 
                        hintText: 'Username', 
                        labelText: 'Username', 
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
                  //Create the email user text input
                  Padding( 
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0), 
                    child: TextFormField(
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
                    )
                  ),
                  //Create the password user input field
                  Container( 
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),  
                    color: Color(0x00000000),
                    child: TextFormField( 
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
                  ),
                  Container( 
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0), 
                    color: Color(0x00000000),
                    child: TextFormField( 
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
                  ),  
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
                          print(_passwordController.text);
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            try {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailController.text, password: _passwordController.text
                              );
                               print("successful signup");
                            } on FirebaseAuthException catch (e) {
                              if(e.code == 'email-already-in-use') {
                                
                                print("in use email");
                              }
                            }
                          }
                        },
                        child: const Text('Sign up')
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
                            text: 'Already have an account?',
                            style: TextStyle(color: const Color.fromARGB(255, 62, 92, 118)),
                          ),
                          TextSpan(
                            text: '  Log in',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _formkey.currentState?.reset();
                                context.pushReplacement('/login');
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