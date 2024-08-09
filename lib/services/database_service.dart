import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL'; // Type for isRead

    await db.execute('''
    CREATE TABLE books (
      id $idType,
      title $textType,
      author $textType,
      rating $doubleType,
      isRead $intType
    )
    ''');
  }

  Future<Book> create(Book book) async {
    final db = await instance.database;
    final id = await db.insert('books', book.toJson());
    return book.copyWith(id: id);
  }

  Future<Book> readBook(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'books',
      columns: ['id', 'title', 'author', 'rating', 'isRead'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;

    final orderBy = 'title ASC';

    final result = await db.query('books', orderBy: orderBy);

    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> update(Book book) async {
    final db = await instance.database;

    return db.update(
      'books',
      book.toJson(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
