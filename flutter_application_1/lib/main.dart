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
        scaffoldBackgroundColor: Colors.grey[100],
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
  final List<Map<String, dynamic>> _quotes = [
    {
      'quote': 'Be yourself; everyone else is already taken',
      'author': 'Oscar Wilde',
      'date': '2023-01-15',
      'category': 'Inspiration',
      'favorite': false,
      'seen': true,
      'comment': 'This is my favorite quote!',
    },
    {
      'quote': 'I have nothing to declare except my genius',
      'author': 'Oscar Wilde',
      'date': '2023-02-20',
      'category': 'Humorous',
      'favorite': false,
      'seen': false,
      'comment': '',
    },
    {
      'quote': 'The truth is rarely pure and never simple',
      'author': 'Oscar Wilde',
      'date': '2023-03-10',
      'category': 'Philosophy',
      'favorite': false,
      'seen': true,
      'comment': 'Deep thought about truth',
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isFavoriteView = false;
  bool _showSeenQuotes = true;
  bool _showUnseenQuotes = true;

  List<String> get _categories {
    Set<String> categories = {'All'};
    for (var quote in _quotes) {
      categories.add(quote['category']!);
    }
    return categories.toList();
  }

  List<Map<String, dynamic>> get _filteredQuotes {
    return _quotes.where((quote) {
      final matchesSearch = quote['quote']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          quote['author']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (quote['comment'] != null &&
              quote['comment']!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()));
      final matchesCategory =
          _selectedCategory == 'All' || quote['category'] == _selectedCategory;
      final matchesFavorite = !_isFavoriteView || quote['favorite'] == true;
      final matchesSeenStatus =
          (_showSeenQuotes && quote['seen'] == true) ||
              (_showUnseenQuotes && quote['seen'] == false);
      return matchesSearch && matchesCategory && matchesFavorite && matchesSeenStatus;
    }).toList();
  }

  void _addQuote() {
    showDialog(
      context: context,
      builder: (context) => QuoteDialog(
        onSave: (quote, author, category, comment) {
          setState(() {
            _quotes.add({
              'quote': quote,
              'author': author,
              'category': category,
              'date': DateTime.now().toString().substring(0, 10),
              'favorite': false,
              'seen': false,
              'comment': comment,
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quote added successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        categories: _categories.where((c) => c != 'All').toList(),
      ),
    );
  }

  void _editQuote(int index) {
    showDialog(
      context: context,
      builder: (context) => QuoteDialog(
        quote: _quotes[index]['quote'],
        author: _quotes[index]['author'],
        category: _quotes[index]['category'],
        comment: _quotes[index]['comment'],
        onSave: (quote, author, category, comment) {
          setState(() {
            _quotes[index] = {
              'quote': quote,
              'author': author,
              'category': category,
              'date': _quotes[index]['date']!,
              'favorite': _quotes[index]['favorite'] ?? false,
              'seen': _quotes[index]['seen'] ?? false,
              'comment': comment,
            };
          });
        },
        categories: _categories.where((c) => c != 'All').toList(),
      ),
    );
  }

  void _deleteQuote(int index) {
    final deletedQuote = _quotes[index];
    setState(() {
      _quotes.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Quote deleted'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _quotes.insert(index, deletedQuote);
            });
          },
        ),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      _quotes[index]['favorite'] = !_quotes[index]['favorite'];
    });
  }

  void _toggleSeen(int index) {
    setState(() {
      _quotes[index]['seen'] = !_quotes[index]['seen'];
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
        actions: [
          IconButton(
            icon: Icon(_isFavoriteView ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _isFavoriteView = !_isFavoriteView;
              });
            },
            tooltip: _isFavoriteView ? 'Show all quotes' : 'Show favorites',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search quotes...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : 'All';
                            });
                          },
                          selectedColor: Colors.red,
                          labelStyle: TextStyle(
                            color: _selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Seen'),
                      selected: _showSeenQuotes,
                      onSelected: (value) {
                        setState(() {
                          _showSeenQuotes = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Unseen'),
                      selected: _showUnseenQuotes,
                      onSelected: (value) {
                        setState(() {
                          _showUnseenQuotes = value;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_filteredQuotes.length} quotes',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        '${_quotes.where((q) => q['favorite'] == true).length} favorites',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredQuotes.length,
              itemBuilder: (context, index) {
                final quote = _filteredQuotes[index];
                return _buildQuoteCard(quote, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tooltip: 'Add new quote',
      ),
    );
  }

  Widget _buildQuoteCard(Map<String, dynamic> quote, int index) {
    final originalIndex = _quotes.indexOf(quote);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    quote['category']!,
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        quote['favorite'] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: quote['favorite'] == true ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(originalIndex),
                      tooltip: quote['favorite'] == true
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                    ),
                    IconButton(
                      icon: Icon(
                        quote['seen'] == true ? Icons.visibility : Icons.visibility_off,
                        color: quote['seen'] == true ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => _toggleSeen(originalIndex),
                      tooltip: quote['seen'] == true
                          ? 'Mark as unseen'
                          : 'Mark as seen',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              quote['quote']!,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (quote['comment'] != null && quote['comment'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  quote['comment']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '— ${quote['author']!}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  quote['date']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editQuote(originalIndex),
                  color: Colors.blue,
                  tooltip: 'Edit quote',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _deleteQuote(originalIndex),
                  color: Colors.red,
                  tooltip: 'Delete quote',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteDialog extends StatefulWidget {
  final String? quote;
  final String? author;
  final String? category;
  final String? comment;
  final List<String> categories;
  final Function(String quote, String author, String category, String comment) onSave;

  const QuoteDialog({
    super.key,
    this.quote,
    this.author,
    this.category,
    this.comment,
    required this.categories,
    required this.onSave,
  });

  @override
  State<QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  late TextEditingController _quoteController;
  late TextEditingController _authorController;
  late TextEditingController _commentController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _quoteController = TextEditingController(text: widget.quote ?? '');
    _authorController = TextEditingController(text: widget.author ?? '');
    _commentController = TextEditingController(text: widget.comment ?? '');
    _selectedCategory = widget.category ?? widget.categories.first;
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _authorController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
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
                widget.quote == null ? 'Add New Quote' : 'Edit Quote',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quoteController,
                decoration: InputDecoration(
                  labelText: 'Quote',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quote';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Comment (optional)',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: widget.categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
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
                          _authorController.text.isNotEmpty &&
                          _selectedCategory.isNotEmpty) {
                        widget.onSave(
                          _quoteController.text,
                          _authorController.text,
                          _selectedCategory,
                          _commentController.text,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
      ),
    );
  }
}