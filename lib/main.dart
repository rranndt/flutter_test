import 'package:flutter/material.dart';
import 'package:trivia_flutter_tdd_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const NumberTriviaPage(),
    );
  }
}
