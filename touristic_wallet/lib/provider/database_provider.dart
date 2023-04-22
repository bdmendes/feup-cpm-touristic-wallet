import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider extends ChangeNotifier {
  final String _databaseCreationScript;
  late final dynamic database;

  DatabaseProvider(this._databaseCreationScript);

  Future<void> initDatabase() async {
    database = await openDatabase(
      'touristic_wallet.db',
      onCreate: (db, version) {
        return db.execute(_databaseCreationScript);
      },
      version: 1,
    );
  }
}
