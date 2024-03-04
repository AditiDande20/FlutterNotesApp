import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_notes/model/note.dart';
import 'package:hive_notes/singletons/constants.dart';

class AddNoteScreen extends StatefulWidget {
  final int? id;
  final Notes? notes;
  const AddNoteScreen({super.key, this.id, this.notes});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Box notesBox = Hive.box<Notes>(Constants.notesTable);
  bool titleChanged = false;
  bool descriptionChanged = false;

  @override
  void initState() {
    if (widget.id != null && widget.notes != null) {
      titleController.text = widget.notes!.title.toString();
      descriptionController.text = widget.notes!.description.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              debugPrint(
                  "titleController.text ======== ${titleController.text}");
              debugPrint(
                  "descriptionController.text ======== ${descriptionController.text}");
              debugPrint("widget.id ======== ${widget.id}");
              debugPrint("widget.notes ======== ${widget.notes}");
              debugPrint("titleChanged ======== $titleChanged");
              debugPrint("descriptionChanged ======== $descriptionChanged");

              if (titleController.text.trim().isNotEmpty &&
                  descriptionController.text.trim().isNotEmpty &&
                  widget.id != null &&
                  widget.notes != null &&
                  (titleChanged || descriptionChanged)) {
                                  debugPrint("editNote ======== ");

                editNote();
              } else if (titleController.text.trim().isNotEmpty &&
                  descriptionController.text.trim().isNotEmpty &&
                  widget.id == null &&
                  widget.notes == null &&
                  (titleChanged == false && descriptionChanged == false)) {
                                  debugPrint("addNote ======== ");

                addNote();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          widget.id == null ? "Create Note" : "Edit Note",
          style: const TextStyle(
              height: 1.5,
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          widget.id != null
              ? IconButton(
                  onPressed: () {
                    deleteNote();
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.black54,
                )
              : Container()
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: TextField(
                  maxLines: 1,
                  controller: titleController,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 10),
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  onChanged: (value) {
                    if (widget.id != null) {
                      setState(() {
                        titleChanged = true;
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: 500,
                child: SingleChildScrollView(
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(bottom: 10),
                        hintText: 'Click to add description to your notes',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade500)),
                    onChanged: (value) {
                      if (widget.id != null) {
                        setState(() {
                          descriptionChanged = true;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNote() {
    Notes notes =
        Notes(titleController.text.trim(), descriptionController.text.trim());
    notesBox.add(notes);
    titleController.clear();
    descriptionController.clear();
    Navigator.pop(context);
  }

  void editNote() {
    Notes notes =
        Notes(titleController.text.trim(), descriptionController.text.trim());
    notesBox.putAt(widget.id!, notes);
    titleController.clear();
    descriptionController.clear();
    Navigator.pop(context);
  }

  void deleteNote() {
    if (widget.id != null) {
      notesBox.deleteAt(widget.id!);
      titleController.clear();
      descriptionController.clear();
      Navigator.pop(context);
    }
  }
}
