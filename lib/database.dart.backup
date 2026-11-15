import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class BarDatabase {
  BarDatabase._();
  static final BarDatabase instance = BarDatabase._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final root = await getDatabasesPath();
    _db = await openDatabase(
      p.join(root, 'souzas_bar.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer TEXT NOT NULL DEFAULT '',
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            is_closed INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id INTEGER NOT NULL,
            name TEXT NOT NULL DEFAULT '',
            quantity REAL NOT NULL DEFAULT 1,
            price REAL NOT NULL DEFAULT 0,
            FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
        await db.execute('CREATE INDEX idx_orders_date ON orders(created_at)');
        await db.execute('CREATE INDEX idx_items_order ON order_items(order_id)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Migrações incrementais serão adicionadas nas próximas versões.
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    return _db!;
  }

  Future<int> createOrder(Map<String, Object?> order,
      List<Map<String, Object?>> items) async {
    final db = await database;
    return db.transaction((txn) async {
      final id = await txn.insert('orders', order);
      for (final item in items) {
        await txn.insert('order_items', {...item, 'order_id': id});
      }
      return id;
    });
  }

  Future<void> updateOrder(int id, Map<String, Object?> order,
      List<Map<String, Object?>> items) async {
    final db = await database;
    await db.transaction((txn) async {
      final changed = await txn.update(
        'orders', order, where: 'id = ?', whereArgs: [id],
      );
      if (changed == 0) {
        throw StateError('Comanda $id não encontrada no banco de dados.');
      }
      await txn.delete('order_items', where: 'order_id = ?', whereArgs: [id]);
      for (final item in items) {
        await txn.insert('order_items', {...item, 'order_id': id});
      }
    });
  }

  Future<List<Map<String, Object?>>> loadOrders() async {
    final db = await database;
    final orders = await db.query('orders', orderBy: 'created_at DESC');
    final result = <Map<String, Object?>>[];
    for (final order in orders) {
      final items = await db.query('order_items',
          where: 'order_id = ?', whereArgs: [order['id']]);
      result.add({...order, 'items': items});
    }
    return result;
  }

  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.insert('settings', {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> readSetting(String key) async {
    final db = await database;
    final rows = await db.query('settings',
        columns: ['value'], where: 'key = ?', whereArgs: [key], limit: 1);
    return rows.isEmpty ? null : rows.first['value'] as String;
  }
}
