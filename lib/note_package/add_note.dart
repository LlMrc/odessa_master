import 'package:flutter/material.dart';

import '../data/crud_operation.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[50],
        body: Column(
          children: [
            AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleTextStyle: const TextStyle(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('📝Add Note'.toUpperCase()),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                      ),
                      onPressed: () async {
                        addNoteToBox(titleController.text, descController.text);
                        if (titleController.text.isEmpty) {
                          titleController.text = 'No Title';
                        } else if (descController.text.isEmpty) {
                          descController.text = 'no notes';
                        }

                        titleController.clear();
                        descController.clear();
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Save".toUpperCase())),
                )
              ],
            ),
            Flexible(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  width: size.width > 600.0 ? size.width * 0.70 : size.width,
                  height: size.height,
                  child: ListView(
                      reverse: true,
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Card(
                            shadowColor: Colors.grey,
                            elevation: 4,
                            child: TextFormField(
                                onFieldSubmitted: (value) {
                                  addNoteToBox(titleController.text,
                                      descController.text);
                                  if (titleController.text.isEmpty) {
                                    titleController.text = 'No Title';
                                  } else if (descController.text.isEmpty) {
                                    descController.text = 'no notes';
                                  }

                                  titleController.clear();
                                  descController.clear();
                                  Navigator.of(context).pop(true);
                                },
                                textInputAction: TextInputAction.done,
                                controller: titleController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: const OutlineInputBorder(),
                                  prefixIcon:
                                      Icon(Icons.edit, color: Colors.grey[400]),
                                  hintText: 'Title...',
                                )),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Card(
                          shadowColor: Colors.grey,
                          borderOnForeground: false,
                          elevation: 4,
                          child: TextFormField(
                            textInputAction: TextInputAction.newline,
                            controller: descController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Description'),
                                hoverColor: Colors.indigo),
                            maxLines: 6,
                          ),
                        )
                      ].reversed.toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
