import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool _obscureText = true;
  String errorMessage = '';

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter email and password';
      });
      return;
    }

    final user = await dbHelper.getUserByEmail(email);
    if (user == null) {
      setState(() {
        errorMessage = 'User not found';
      });
      return;
    }

    if (user['password'] != password) {
      setState(() {
        errorMessage = 'Incorrect password';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user['users_id']);
    await prefs.setString('userName', user['name']);

    setState(() {
      errorMessage = '';
    });

    Navigator.pushReplacementNamed(context, '/tracker');
  }

  Future<void> _deleteAllTablesAndDatabase() async {
    await dbHelper.deleteAllTablesAndDatabase();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All tables and database deleted!')),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            children: [
              Container(
                width: 340,
                height: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 0,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: SizedBox(
                  child: Image.asset(
                    'assets/skinmate_login.png',
                    alignment: Alignment.center,
                    height: 100,
                  ),
                ),
              ),
              SizedBox(height: 75),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 340,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 0,
                              offset: Offset(0, 0),
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 330,
                                child: Column(
                                  children: [
                                    SizedBox(height: 25),
                                    SizedBox(
                                      width: 300,
                                      height: 45,
                                      child: TextField(
                                        controller: emailController,
                                        focusNode: emailFocus,
                                        textInputAction: TextInputAction.next,
                                        onSubmitted: (_) {
                                          FocusScope.of(context).requestFocus(passwordFocus);
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                          ),
                                          hintText: 'Enter your email',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 15),

                                    SizedBox(
                                      width: 300,
                                      height: 45,
                                      child: TextField(
                                        controller: passwordController,
                                        focusNode: passwordFocus,
                                        obscureText: _obscureText,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) {
                                          login();
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                          ),
                                          hintText: 'Enter your password',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                            errorMessage.isNotEmpty
                                                ? Text(
                                                  errorMessage,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                )
                                                : SizedBox.shrink(),
                                      ),
                                    ),

                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(0, 0),
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          onPressed: () async {
                                            try {
                                              await Navigator.pushNamed(
                                                context,
                                                '/forgot_password',
                                              );
                                            } catch (e) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                      title: Text('Oops!'),
                                                      content: Text(
                                                        'Page masih dalam perbaikan.',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 180),
                              Container(
                                width: 135,
                                height: 35,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: ShapeDecoration(
                                  color: Color(0xFF1FC16B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: login,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                    child: Text(
                                      'Log In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 291,
                                height: 12,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 30),
                                        child: Divider(
                                          color: Color(0xFF6D6D6D),
                                          thickness: 1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: _deleteAllTablesAndDatabase,
                                        child: Text(
                                          'or log in with',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF6D6D6D),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            height: 0.2,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Divider(
                                          color: Color(0xFF6D6D6D),
                                          thickness: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/instagram.png',
                                    width: 30,
                                  ),
                                  SizedBox(width: 40),
                                  Image.asset('assets/google.png', width: 30),
                                  SizedBox(width: 40),
                                  Image.asset('assets/twitter.png', width: 30),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: Text(
                                      'Sign up here',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 70),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/users');
                          },
                          child: Text(
                            'Go to User Control Panel',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
