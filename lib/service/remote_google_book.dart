import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pdf_reader/constant.dart';
import 'package:pdf_reader/service/book_model.dart';

class FetchBookFromGoogle extends StatefulWidget {
  const FetchBookFromGoogle({super.key, this.searchtherme = ''});
  final String searchtherme;

  @override
  State<FetchBookFromGoogle> createState() => _FetchBookFromGoogleState();
}

class _FetchBookFromGoogleState extends State<FetchBookFromGoogle> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = widget.searchtherme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool size = MediaQuery.of(context).size.width > 650;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Container(
            height: 36,
            decoration: BoxDecoration(
                color: Colors.blue.shade200.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30)),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  _textEditingController.text = value;
                });
              },
              controller: _textEditingController,
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () => _textEditingController.clear(),
                  icon: Icon(Icons.close, color: Colors.blue.shade200),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white)),
                errorBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.only(top: 10, bottom: 7, left: 8),
                hintText: "search...",
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<dynamic>>(
            future: _fetchPotterBooks(),
            builder: (context, snapshot) {
              final snapshotData = snapshot.data;

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator.adaptive());

                case ConnectionState.none:
                  return const Center(child: Text('No Connection'));

                case ConnectionState.active:
                  return const Center(child: Text('Ative Connection!⏳'));

                case ConnectionState.done:
                  if (snapshotData == null) {
                    return const Center(
                        child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Column(
                              children: [
                                Icon(FontAwesomeIcons.wifi),
                                Text('No connection')
                              ],
                            )));
                  } else if (snapshotData.isEmpty) {
                    return const Center(child: Text('No File Found'));
                  }
                  {
                    return ListView.builder(
                        itemCount: snapshotData.length,
                        itemBuilder: (context, index) {
                          var data = snapshotData[index];
                          var titile = data['volumeInfo']['title'];
                          var author =
                              data['volumeInfo']['authors'] ?? 'Author unknown';
                          var webReader = data['accessInfo']['webReaderLink'];
                          var previewedLink = data['volumeInfo']['previewLink'];
                          var imageUrl =
                              data['volumeInfo']['imageLinks']['thumbnail'];
                          var desc = data['volumeInfo']['description'];
                          String url = imageUrl ??=
                              "https://docs.google.com/document/d/1ZHQ4MP4YKfcOuExUwtxg_qU87X9RnO3iORBU0b6N-mk/edit?usp=share_link";

                          bool validURL = Uri.parse(url).isAbsolute;
                          if (kDebugMode) {
                            print(previewedLink);
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => DetailsBook(
                                        previewedLink: previewedLink,
                                        url: url,
                                        description: desc.toString(),
                                        title: titile.toString(),
                                        initialRoute: webReader,
                                      )));
                            },
                            child: Container(
                              height: 150,
                              padding: size
                                  ? const EdgeInsets.only(
                                      top: 2, left: 8, right: 8)
                                  : const EdgeInsets.only(
                                      top: 2, left: 20, right: 20),
                              decoration:
                                  BoxDecoration(color: Colors.purple.shade100),
                              child: Card(
                                //   margin: const EdgeInsets.only(top: 8, left: 8,right: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.all(8),
                                        width: 130,
                                        child: validURL == true
                                            ? Image.network(
                                                url,
                                                fit: BoxFit.fill,
                                              )
                                            : noImage),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            titile.toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            " ${author.toString().replaceAll(RegExp(r'(?:_|[^\w\s])+'), '')}",
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
              }
            }));
  }

  Future<List<dynamic>> _fetchPotterBooks() async {
    String key = "AIzaSyBlqUY-m4Vz8ncii6SRO-FtZtbWCDCsC34";

    var url = Uri.parse(
        "https://www.googleapis.com/books/v1/volumes?q=${_textEditingController.text}&key=$key");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(res.body) as Map<String, dynamic>;
      List<dynamic> itemsList = jsonResponse['items'];

      return itemsList;
    } else {
      throw Exception('Error: ${res.statusCode}');
    }
  }
}
