import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/login/bloc/login_bloc.dart';
import 'package:frontend/features/login/screen/login_screen.dart';
import 'package:frontend/features/main/bloc/main_bloc.dart';
import 'package:frontend/features/main/main_screen.dart';
import 'package:frontend/features/profile/profile_view.dart';
import 'package:frontend/features/register/bloc/register_bloc.dart';
import 'package:frontend/features/register/screen/register_screen.dart';
import 'package:frontend/features/splash/splash_screen.dart';
import 'package:frontend/features/user/bloc/user_bloc.dart';
import 'package:frontend/features/user/user_view.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/repositories/main_repository.dart';
import 'package:frontend/repositories/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(AuthRepository()),
        ),
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(AuthRepository())),
        BlocProvider<MainBloc>(create: (_) => MainBloc(MainRepository())),
        BlocProvider<UserBloc>(create: (_) => UserBloc(UserRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          if (settings.name == "/user-detail") {
            final String id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => UserView(userId: id),
            );
          } else if (settings.name == "/profile") {
            final String id = settings.arguments as String;
            return MaterialPageRoute(builder: (context) => ProfileView(id: id));
          }
          return null;
        },
        initialRoute: "/",
        routes: {
          "/": (context) => const SplashScreen(),
          "/main": (context) => const MainScreen(),
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
        },
      ),
    );
  }
}
