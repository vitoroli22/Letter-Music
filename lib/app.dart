import 'package:flutter/material.dart';
import 'features/auth/pages/welcome_page.dart';

class LetterMusicApp extends StatelessWidget {
  const LetterMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LetterMusic',
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'Roboto'),
      home: const WelcomePage(),
    );
  }
}
