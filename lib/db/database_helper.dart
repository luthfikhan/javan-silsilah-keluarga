import 'package:javan_silsilah_keluarga/constans.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> _database;

  Future<Database> get _db async {
    if (_database == null) {
      _database = _initDb();
      return _database;
    }
    return _database;
  }

  Future<Database> _initDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE user( 
            id_user INTEGER PRIMARY KEY, 
            name TEXT,
            gender INTEGER,
            id_ortu INTEGER,
            status INTEGER
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<bool> dbExists() async {
    return databaseExists(join(await getDatabasesPath(), 'user.db'));
  }

  Future<void> insertUser(UserModel userModel) async {
    Database db = await _db;

    await db.insert('user', userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel> getUserDetail(int idUser) async {
    final db = await _db;

    List<Map> results = await db.query(
      'user',
      where: "id_user = ?",
      whereArgs: [idUser],
    );

    return UserModel.fromMap(results[0]);
  }

  Future<List<UserModel>> getAllData() async {
    final db = await _db;

    List<Map> results = await db.query('user');

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  Future<List<UserModel>> getAnakCucu() async {
    final db = await _db;

    List<Map> results = await db.query(
      'user',
      where: "status > ?",
      whereArgs: [0],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  Future<List<UserModel>> getAnakByIdOrtu(int id) async {
    final db = await _db;

    List<Map> results = await db.query(
      'user',
      where: "id_ortu = ?",
      whereArgs: [id],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  Future<void> updateUser(UserModel user) async {
    final db = await _db;

    await db.update('user', user.toMap(),
        where: "id_user = ?",
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(int id) async {
    final db = await _db;

    var u = await getUserDetail(id);

    if (u.status == 1) {
      await db.delete(
        'user',
        where: "id_ortu = ?",
        whereArgs: [u.id],
      );
    }

    await db.delete(
      'user',
      where: "id_user = ?",
      whereArgs: [id],
    );
  }

  /* 
    Challenge
  */
  // 3. Semua ank budi
  Future<List<UserModel>> semuaAnak() async {
    final db = await _db;

    List<Map> results = await db.query(
      'user',
      where: "status = ?",
      whereArgs: [1],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  // 4. Semua cucu budi
  Future<List<UserModel>> semuaCucu() async {
    final db = await _db;

    List<Map> results = await db.query(
      'user',
      where: "status = ?",
      whereArgs: [2],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  // 5. Semua cucu perempuan budi
  Future<List<UserModel>> semuaCucuPr() async {
    final db = await _db;

    List<Map> results = await db.query(
      'user',
      where: "status = ? and gender = ?",
      whereArgs: [2, GENDER.PEREMPUAN.index],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  // 6. Get data bibi
  Future<List<UserModel>> getBibi(int id) async {
    final db = await _db;

    var u = await getUserDetail(id);

    List<Map> results = await db.query(
      'user',
      where: "status = ? and gender = ? and id_ortu != ?",
      whereArgs: [1, GENDER.PEREMPUAN.index, u.ortuId],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }

  // 6. Get data sepupu
  Future<List<UserModel>> getSepupu(int id, int iGender) async {
    final db = await _db;

    var u = await getUserDetail(id);

    List<Map> results = await db.query(
      'user',
      where: "status = ? and gender = ? and id_ortu != ?",
      whereArgs: [2, iGender, u.ortuId],
    );

    return List<UserModel>.from(results.map((e) => UserModel.fromMap(e)));
  }
}
