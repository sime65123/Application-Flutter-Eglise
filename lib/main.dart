import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/controlleurs/repository/google_auth.dart';
import 'package:groupe_des_vainqueurs/controlleurs/traduction.dart';
import 'package:groupe_des_vainqueurs/vues/about_us.dart';
import 'package:groupe_des_vainqueurs/vues/don_page.dart';
import 'package:groupe_des_vainqueurs/vues/home_page.dart';
import 'package:groupe_des_vainqueurs/vues/language.dart';
import 'package:groupe_des_vainqueurs/vues/login_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(StreamProvider<User?>(
      create: (context) => AuthService().user,
      initialData: null,
      builder: (context, w) => const MyApp()));
}

enum MyAppState { disconnected, connected, loading }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyAppState state = MyAppState.loading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyAppState state = MyAppState.loading;
    return GetMaterialApp(
      translations: LanguageTranslation(),
      locale: Get.deviceLocale,

      fallbackLocale: Locale("en", "US"),
      //title: 'Donation App',
      debugShowCheckedModeBanner: false,
      // routes: {"/": (context) => Connexion()},
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
        primaryColor: primaryColor,
      ),
      routes: {
        // La route par défaut est la page d'accueil.

        'connexion': (context) => const LoginPage(),
        'home': (context) => HomePage(),
        'aboutpage': (context) => AboutPage(),
        'donpage': (context) => DonPage(),
        'setting': (context) => Setting(),
        //clear'langue': (context) => PageLangue(),
        // La route nommée '/second' mène à la page SecondPage.
        //'/second': (context) => SecondPage(),
      },
      home: Consumer<User?>(builder: (context, user, w) {
        return user != null ? LoginPage() : HomePage();
      }),
    );
  }
}
