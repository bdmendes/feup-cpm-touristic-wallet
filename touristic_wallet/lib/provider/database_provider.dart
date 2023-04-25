import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider extends ChangeNotifier {
  final String _databaseCreationScript;
  final String _databaseName;
  late final dynamic database;

  DatabaseProvider(this._databaseName, this._databaseCreationScript);

  Future<void> initDatabase() async {
    database = await openDatabase(
      _databaseName,
      onCreate: (db, version) {
        return db.execute(_databaseCreationScript);
      },
      version: 1,
    );
  }
}
