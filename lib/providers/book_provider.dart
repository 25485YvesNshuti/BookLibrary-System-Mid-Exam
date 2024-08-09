import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  BookProvider() {
    fetchBooks(); // Ensure fetchBooks is called when the provider is created
  }

  Future<void> fetchBooks() async {
    _books = await DatabaseService.instance
        .readAllBooks(); // Fetch all books from the database
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> addBook(Book book) async {
    await DatabaseService.instance.create(book); // Add book to the database
    fetchBooks(); // Refresh the list
  }

  Future<void> updateBook(Book book) async {
    await DatabaseService.instance
        .update(book); // Update the book in the database
    fetchBooks(); // Refresh the list
  }

  Future<void> deleteBook(int id) async {
    await DatabaseService.instance
        .delete(id); // Delete the book from the database
    fetchBooks(); // Refresh the list
  }

  List<Book> searchBooks(String query) {
    return _books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void sortBooks(String sortOrder) {
    switch (sortOrder) {
      case 'title':
        _books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'author':
        _books.sort((a, b) => a.author.compareTo(b.author));
        break;
      case 'rating':
        _books.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    notifyListeners(); // Notify listeners after sorting
  }
}
