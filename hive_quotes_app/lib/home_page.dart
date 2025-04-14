import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/quote.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _quotesBox = Hive.box<Quote>('quotesBox');
  final _textController = TextEditingController();
  final _authorController = TextEditingController();

  void _addQuote() {
    final text = _textController.text;
    final author = _authorController.text;

    if (text.isNotEmpty && author.isNotEmpty) {
      final quote = Quote(text: text, author: author);
      _quotesBox.add(quote);
      _textController.clear();
      _authorController.clear();
    }
  }

  void _deleteQuote(int index) {
    _quotesBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive Quotes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _textController, decoration: const InputDecoration(labelText: "Quote")),
            TextField(controller: _authorController, decoration: const InputDecoration(labelText: "Author")),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addQuote, child: const Text("Add Quote")),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _quotesBox.listenable(),
                builder: (context, Box<Quote> box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text("No quotes yet."));
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final quote = box.getAt(index);
                      return ListTile(
                        title: Text('"${quote?.text}"'),
                        subtitle: Text("- ${quote?.author}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteQuote(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
