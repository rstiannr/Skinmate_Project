import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'splash_screen.dart';
import 'auth/login_screen.dart' as auth_login;
import 'auth/users_screen.dart';
import 'auth/register_screen.dart' as auth_register;
import 'tracker/tracker_screen.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintLayerBordersEnabled = true;
  runApp(SkinMateApp());
}

class SkinMateApp extends StatelessWidget {
  const SkinMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkinMate',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.login: (context) => auth_login.LoginScreen(),
        AppRoutes.register: (context) => auth_register.RegisterScreen(),
        AppRoutes.tracker: (context) => TrackerScreen(),
        AppRoutes.users: (context) => UsersScreen(),
      },
    );
  }
}
