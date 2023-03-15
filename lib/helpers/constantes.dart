const int maxInt32 = 0x7fffffff;
const databaseVersion = 3;

class SqliteTipos {
  static const integer = 'INTEGER';
  static const text = 'TEXT';
  static const real = 'REAL';
  SqliteTipos._();
}

class SqlitePropriedades {
  static const primaryKey = 'PRIMARY KEY';
  static const notNull = 'NOT NULL';
  static const unique = 'UNIQUE';
}
