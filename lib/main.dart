import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/cubit/cubit.dart';
import 'layout/shop_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/onboarding/on_boarding_screen.dart';
import 'bloc_observer.dart';
import 'shared/components/variables.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'styles/styles.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  token = CacheHelper.getData(key: 'token') ?? '';

  Widget startWidget() => onBoarding
      ? token.isNotEmpty
          ? const ShopLayout()
          : LoginScreen()
      : const OnBoarding();
  runApp(MyApp(startWidget()));
}

class MyApp extends StatelessWidget {
  const MyApp(this.startWidget, {super.key});
  final Widget startWidget;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeModelData()
            ..getCategoriesModel()
            ..getFavoritesModel()
            ..getUserModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop app',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
