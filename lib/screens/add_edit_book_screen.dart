import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/rating_widget.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  AddEditBookScreen({this.book});

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late double _rating;
  bool _isRead = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _isEditing = true;
      _title = widget.book!.title;
      _author = widget.book!.author;
      _rating = widget.book!.rating;
      _isRead = widget.book!.isRead; // Initialize _isRead
    } else {
      _title = '';
      _author = '';
      _rating = 0.0;
      _isRead = false; // Default value for isRead
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var isDarkMode = themeProvider.isDarkMode;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var backgroundColor = isDarkMode ? Colors.black54 : Colors.white;
    var borderColor = isDarkMode ? Colors.white54 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Book' : 'Add Book'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: backgroundColor, // Background color for the form
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Add SingleChildScrollView to avoid overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 16),
                Text(
                  'Author',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  initialValue: _author,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _author = value!;
                  },
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: 16),
                Text(
                  'Rating',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingWidget(
                  rating: _rating,
                  onRatingChanged: (newRating) {
                    setState(() {
                      _rating = newRating;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Read: ',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: _isRead,
                      onChanged: (newValue) {
                        setState(() {
                          _isRead = newValue;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final book = Book(
                        id: _isEditing ? widget.book!.id : null,
                        title: _title,
                        author: _author,
                        rating: _rating,
                        isRead: _isRead, // Include isRead
                      );
                      if (_isEditing) {
                        Provider.of<BookProvider>(context, listen: false)
                            .updateBook(book);
                      } else {
                        Provider.of<BookProvider>(context, listen: false)
                            .addBook(book);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(_isEditing ? 'Update Book' : 'Add Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
