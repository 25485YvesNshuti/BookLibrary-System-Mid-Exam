import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/theme_provider.dart';
import '../models/book.dart';
import 'add_edit_book_screen.dart';
import 'book_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';
  String _sortOrder = 'title';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.popUntil(context, (route) => route.isFirst);
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditBookScreen()),
          ).then((_) {
            Provider.of<BookProvider>(context, listen: false).fetchBooks();
          });
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
          break;
      }
    });
  }

  void _quitApplication() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var isDarkMode = themeProvider.isDarkMode;
    var textColor = isDarkMode ? Colors.white : Colors.green;
    var titleTextStyle = TextStyle(
      color: textColor,
      fontWeight: isDarkMode ? FontWeight.normal : FontWeight.bold,
    );
    var subtitleTextStyle = TextStyle(
      color: textColor,
      fontWeight: isDarkMode ? FontWeight.normal : FontWeight.bold,
    );
    var ratingTextStyle = TextStyle(
      color: isDarkMode ? Colors.white : Colors.green,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'MyBook Library',
          style: titleTextStyle,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
          DropdownButton<String>(
            value: _sortOrder,
            icon: Icon(Icons.sort, color: Colors.white),
            dropdownColor: Theme.of(context).primaryColor,
            onChanged: (String? newValue) {
              setState(() {
                _sortOrder = newValue!;
                Provider.of<BookProvider>(context, listen: false)
                    .sortBooks(_sortOrder);
              });
            },
            items: <String>['title', 'author', 'rating']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value.capitalize(),
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Book'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditBookScreen()),
                ).then((_) {
                  Provider.of<BookProvider>(context, listen: false)
                      .fetchBooks();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Quit Application'),
              onTap: () {
                _quitApplication();
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search books',
                  labelStyle: TextStyle(color: textColor),
                  prefixIcon: Icon(Icons.search, color: textColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
                style: TextStyle(color: textColor),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/book-library-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<BookProvider>(
                builder: (context, bookProvider, child) {
                  final books = _searchQuery.isEmpty
                      ? bookProvider.books
                      : bookProvider.searchBooks(_searchQuery);

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return ListTile(
                        leading: Icon(Icons.book, color: textColor),
                        title: Text(
                          'Book Name: ${book.title}',
                          style: titleTextStyle.copyWith(fontSize: 18),
                        ),
                        subtitle: Text(
                          'Author Name: ${book.author}',
                          style: subtitleTextStyle.copyWith(fontSize: 16),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rating: ${book.rating.toStringAsFixed(1)}',
                              style: ratingTextStyle.copyWith(fontSize: 14),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: textColor),
                              onPressed: () => _editBook(context, book),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: textColor),
                              onPressed: () => _deleteBook(context, book),
                            ),
                          ],
                        ),
                        onTap: () => _viewBookDetails(context, book),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }

  void _editBook(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
    ).then((_) {
      Provider.of<BookProvider>(context, listen: false).fetchBooks();
    });
  }

  void _deleteBook(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Book'),
          content: Text('Are you sure you want to delete ${book.title}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Provider.of<BookProvider>(context, listen: false)
                    .deleteBook(book.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _viewBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
