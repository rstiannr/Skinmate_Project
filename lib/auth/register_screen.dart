import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String errorMessage = '';

  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    final existingUser = await dbHelper.getUserByEmail(email);
    if (existingUser != null) {
      setState(() {
        errorMessage = 'User already exists';
      });
      return;
    }
    final userId = await dbHelper.insertUserWithBasicInfo(name, email, password);

    await saveLoggedInUser(userId, name);

    setState(() {
      errorMessage = '';
    });

    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> saveLoggedInUser(int userId, String userName) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('userId', userId);
    await prefs.setString('userName', userName);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
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
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                        controller: nameController,
                                        focusNode: nameFocus,
                                        textInputAction: TextInputAction.next,
                                        onSubmitted: (_) {
                                          FocusScope.of(context).requestFocus(emailFocus);
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                          ),
                                          hintText: 'Enter your name',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),
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
                                            borderRadius: BorderRadius.circular(18),
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

                                    SizedBox(height: 10),

                                    SizedBox(
                                      width: 300,
                                      height: 45,
                                      child: TextField(
                                        controller: passwordController,
                                        focusNode: passwordFocus,
                                        obscureText: _obscureText1,
                                        textInputAction: TextInputAction.next,
                                        onSubmitted: (_) {
                                          FocusScope.of(context).requestFocus(confirmPasswordFocus);
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(18),
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
                                              _obscureText1
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText1 = !_obscureText1;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 300,
                                      height: 45,
                                      child: TextField(
                                        controller: confirmPasswordController,
                                        focusNode: confirmPasswordFocus,
                                        obscureText: _obscureText2,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) {
                                          register();
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                          ),
                                          hintText: 'Enter your confirm password',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText2
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: errorMessage.isNotEmpty
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
                                  ],
                                ),
                              ),

                              SizedBox(height: 150),
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
                                  onTap: register,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                    child: Text(
                                      'Register',
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
                                      child: Text(
                                        'or sign up with',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF6D6D6D),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          height: 0.2,
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
                                    "do you already have an account? ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      'Log in here',
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
