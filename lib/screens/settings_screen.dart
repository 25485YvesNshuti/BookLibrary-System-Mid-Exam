import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/book_provider.dart'; // Add this import
import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _sortOrder = 'title';

  @override
  void initState() {
    super.initState();
    _loadSortOrder();
  }

  Future<void> _loadSortOrder() async {
    final prefs = PreferencesService();
    final sortOrder = await prefs.getSortOrder();
    setState(() {
      _sortOrder = sortOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge), // Changed from headline6 to titleLarge
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: Text('Dark Mode'),
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Text('Sort Books By',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge), // Changed from headline6 to titleLarge
            RadioListTile<String>(
              title: Text('Title'),
              value: 'title',
              groupValue: _sortOrder,
              onChanged: _updateSortOrder,
            ),
            RadioListTile<String>(
              title: Text('Author'),
              value: 'author',
              groupValue: _sortOrder,
              onChanged: _updateSortOrder,
            ),
            RadioListTile<String>(
              title: Text('Rating'),
              value: 'rating',
              groupValue: _sortOrder,
              onChanged: _updateSortOrder,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateSortOrder(String? value) async {
    if (value != null) {
      setState(() {
        _sortOrder = value;
      });
      await PreferencesService().setSortOrder(value);
      Provider.of<BookProvider>(context, listen: false).sortBooks(value);
    }
  }
}
