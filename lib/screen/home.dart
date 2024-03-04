import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_notes/model/note.dart';
import 'package:hive_notes/screen/add_note.dart';
import 'package:hive_notes/singletons/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box notesBox = Hive.box<Notes>(Constants.notesTable);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "NOTES",
          style: TextStyle(
              height: 1.5,
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNoteScreen(),
                    ));
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: notesBox.listenable(),
          builder: (context, box, child) {
            if (box.isEmpty) {
              return const Center(
                child: Text(
                  'No Notes Added !!!',
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return MasonryGridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: box.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  Notes currentNote = box.getAt(index);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNoteScreen(
                              id: index,
                              notes: currentNote,
                            ),
                          ));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentNote.title.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              currentNote.description.toString(),
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
