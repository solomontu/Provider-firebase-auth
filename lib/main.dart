import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_auth/authServices/userAuth.dart';
import 'package:provider_auth/screens/signup.dart';
import 'package:provider_auth/screens/splash.dart';
import 'screens/myHome.dart';
import 'screens/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('initialized');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderAuth>(
      create: (_) => ProviderAuth.instance(),
      // lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          // accentColor: black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ScreenSelector(),
        //  Login(),
      ),
    );
  }
}

class ScreenSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _status = Provider.of<ProviderAuth>(context);
    switch (_status.status) {
      case Status.uninitialized:
        return Splash();
        break;
      case Status.unAuthenticated:
        return Login();
        break;
      case Status.unAcredited:
        return Signup();
        break;
      case Status.authenticated:
        return MyHome();
        break;
      default:
        return Login();
    }
  }
}
