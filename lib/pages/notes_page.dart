import 'package:flutter_demo_application/models/note.dart';
import 'package:flutter_demo_application/models/note_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  // create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter note..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
               Navigator.pop(context); // close first, to match standard behavior? but original doesn't matter
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                 // add to db
                 context.read<NoteDatabase>().addNote(textController.text);
                 // clear controller
                 textController.clear();
                 Navigator.pop(context);
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     content: Text('Note created successfully!'),
                     behavior: SnackBarBehavior.floating,
                   ),
                 );
              }
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  // read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes(); // Use read instead of watch
  }

  // update a note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Update Note"),
          content: TextField(controller: textController),
          actions: [
            TextButton(
              onPressed: () {
                 textController.clear();
                 Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    context
                        .read<NoteDatabase>()
                        .updateNote(note.id, textController.text);
                    // clear controller
                    textController.clear();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text("Update"))
          ],
        ));
  }

  // delete a note
  void deleteNote(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<NoteDatabase>().deleteNote(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          child: const Icon(Icons.add),
        ),
        body: currentNotes.isEmpty
            ? const Center(child: Text("No notes yet. Add one!"))
            : ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  // get individual note
                  final note = currentNotes[index];

                  // list tile UI
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(note.text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // edit button
                          IconButton(
                              onPressed: () => updateNote(note),
                              icon: const Icon(Icons.edit, color: Colors.blueAccent)),
                          // delete button
                          IconButton(
                              onPressed: () => deleteNote(note.id),
                              icon: const Icon(Icons.delete, color: Colors.redAccent))
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
