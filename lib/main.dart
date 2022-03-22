import 'package:communication_app/layout/cubit/home_layout_cubit.dart';
import 'package:communication_app/layout/cubit/home_layout_states.dart';
import 'package:communication_app/layout/home_layout.dart';
import 'package:communication_app/modules/login/login_screen.dart';
import 'package:communication_app/shared/end_points.dart';
import 'package:communication_app/shared/network/local/cache_helper.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Widget widget;
  uId = await CacheHelper.getData('uId');

  if (uId != null) {
    widget = HomeLayout();
  } else {
    widget = SocialLoginScreen();
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SocialCubit()
          ..getPosts()
          ..getUserData()
          ..getUsers(),
        child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    scaffoldBackgroundColor: Colors.white,
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: Colors.blueAccent,
                        unselectedItemColor: Colors.grey),
                    appBarTheme: AppBarTheme(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: Colors.white,
                          statusBarIconBrightness: Brightness.dark,
                        ),
                        titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Signika'),
                        iconTheme: IconThemeData(color: Colors.black)),
                    textTheme: TextTheme()),
                debugShowCheckedModeBanner: false,
                home: startWidget,
              );
            }));
  }
}
