import 'package:flutter/material.dart';

void main() {
  runApp(const AwesomeQuotesApp());
}

class AwesomeQuotesApp extends StatelessWidget {
  const AwesomeQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100], // Light grey background
      ),
      home: const QuotesPage(),
    );
  }
}

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final List<Map<String, String>> _quotes = [
    {
      'quote': 'Be yourself; everyone else is already taken',
      'author': 'Oscar Wilde',
    },
    {
      'quote': 'I have nothing to declare except my genius',
      'author': 'Oscar Wilde',
    },
    {
      'quote': 'The truth is rarely pure and never simple',
      'author': 'Oscar Wilde',
    },
  ];

  void _addQuote() {
    showDialog(
      context: context,
      builder: (context) => QuoteDialog(
        onSave: (quote, author) {
          setState(() {
            _quotes.add({'quote': quote, 'author': author});
          });
        },
      ),
    );
  }

  void _editQuote(int index) {
    showDialog(
      context: context,
      builder: (context) => QuoteDialog(
        quote: _quotes[index]['quote'],
        author: _quotes[index]['author'],
        onSave: (quote, author) {
          setState(() {
            _quotes[index] = {'quote': quote, 'author': author};
          });
        },
      ),
    );
  }

  void _deleteQuote(int index) {
    setState(() {
      _quotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Awesome Quotes',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100], // Light grey background
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _quotes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // White card background
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _quotes[index]['quote']!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _quotes[index]['author']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () => _editQuote(index),
                            child: const Text(
                              'edit quote',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _deleteQuote(index),
                            child: const Text(
                              'delete quote',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red, // Red FAB to match app bar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class QuoteDialog extends StatefulWidget {
  final String? quote;
  final String? author;
  final Function(String quote, String author) onSave;

  const QuoteDialog({
    super.key,
    this.quote,
    this.author,
    required this.onSave,
  });

  @override
  State<QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  late TextEditingController _quoteController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _quoteController = TextEditingController(text: widget.quote ?? '');
    _authorController = TextEditingController(text: widget.author ?? '');
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.quote == null ? 'Add Quote' : 'Edit Quote',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quoteController,
              decoration: InputDecoration(
                labelText: 'Quote',
                filled: true,
                fillColor: Colors.grey[100], // Light grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                filled: true,
                fillColor: Colors.grey[100], // Light grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_quoteController.text.isNotEmpty &&
                        _authorController.text.isNotEmpty) {
                      widget.onSave(
                        _quoteController.text,
                        _authorController.text,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red button to match theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}