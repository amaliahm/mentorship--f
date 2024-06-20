import 'package:flutter/material.dart';
import 'package:sorting_algo/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Algorithms',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 40, 179, 160)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sorting Algorithms'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(context, widget.title), body: MainUI());
  }
}

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(title),
  );
}
