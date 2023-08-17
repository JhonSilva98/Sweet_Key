import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sweets_key/telaPrincipal/telaPrincipal.dart';
import 'firebase/options/firebase_options.dart';

//quandofor pegar o getdados colocar as funçoes no else do future

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweets Key',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          background: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        //useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}
