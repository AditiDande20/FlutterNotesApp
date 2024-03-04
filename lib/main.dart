import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_notes/model/note.dart';
import 'package:hive_notes/singletons/constants.dart';
import 'package:path_provider/path_provider.dart';

import 'screen/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesAdapter());
  await Hive.openBox<Notes>(Constants.notesTable);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}


