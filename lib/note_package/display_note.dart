import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../data/datahelper.dart';
import 'edit_note.dart';

class DisplayNote extends StatefulWidget {
  const DisplayNote({
    Key? key,
    required this.noteId,
  }) : super(key: key);
  final Note noteId;

  @override
  State<DisplayNote> createState() => _DisplayNoteState();
}

class _DisplayNoteState extends State<DisplayNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff2C394B),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.amber.shade300),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              widget.noteId.delete();
              Navigator.of(context).pop(true);
            },
            icon: Icon(Icons.delete_forever, color: Colors.amber.shade300)),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditNote(
                              note: widget.noteId,
                            )));
              },
              icon: Icon(Icons.edit, color: Colors.amber.shade300)),
          IconButton(
              onPressed: () async {
                await Share.share(
                    "${widget.noteId.title}  \n ${widget.noteId.description}");
              },
              icon: Icon(Icons.share, color: Colors.amber.shade300))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.noteId.title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                        color: Colors.amber.shade100),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(widget.noteId.description,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
