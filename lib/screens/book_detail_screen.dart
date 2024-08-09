import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../widgets/rating_widget.dart';
import 'add_edit_book_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  BookDetailScreen({required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late double _rating;
  late bool _isRead;

  @override
  void initState() {
    super.initState();
    _rating = widget.book.rating;
    _isRead = widget.book.isRead;
  }

  void _updateRating(double newRating) {
    setState(() {
      _rating = newRating;
    });
    final updatedBook = widget.book.copyWith(rating: newRating);
    Provider.of<BookProvider>(context, listen: false).updateBook(updatedBook);
  }

  void _updateReadStatus(bool isRead) {
    setState(() {
      _isRead = isRead;
    });
    final updatedBook = widget.book.copyWith(isRead: isRead);
    Provider.of<BookProvider>(context, listen: false).updateBook(updatedBook);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditBookScreen(book: widget.book),
                ),
              ).then((_) {
                final updatedBook =
                    Provider.of<BookProvider>(context, listen: false)
                        .books
                        .firstWhere((book) => book.id == widget.book.id);
                setState(() {
                  _rating = updatedBook.rating;
                  _isRead = updatedBook.isRead;
                });
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${widget.book.author}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            RatingWidget(
              rating: _rating,
              onRatingChanged: _updateRating,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Read: ', style: TextStyle(fontSize: 18)),
                Switch(
                  value: _isRead,
                  onChanged: (newValue) {
                    _updateReadStatus(newValue);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
