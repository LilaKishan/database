import 'dart:io';
import 'package:database/model/city_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'demo.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets/database', 'demo.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, Object?>>> getUserLIstFromUser() async {
    Database db = await initDatabase();
    List<Map<String, Object?>> data = await db.rawQuery(
        'select p.PID,p.Name,c.CityName  from Person_Master  p inner join City_Master c on p.CityId=c.CityId');
    return data;
  }

  Future<List<CityModel>> getCityList() async {
    Database db = await initDatabase();
    List<Map<String, Object?>> data =
        await db.rawQuery('Select * from City_Master');

    List<CityModel> cityList = [];
    for (int i = 0; i < data.length; i++) {
      CityModel model = CityModel();
      model.CityId = int.tryParse(data[i]['CityId'].toString());
      model.CityName = data[i]['CityName'].toString();
      cityList.add(model);
    }
    return cityList;
  }

  Future<int> insertUserDetail(map) async {
    Database db = await initDatabase();
    int userId = await db.insert('Person_Master', map);
    return userId;
  }

  Future<int> updateUserDetail(map, id) async {
    Database db = await initDatabase();

    int userId = await db
        .update('Person_Master', map, where: ' PID= ? ', whereArgs: [id]);
    return userId;
  }

  Future<int> deleteUserDetail(id) async {
    Database db = await initDatabase();

    int userId =
        await db.delete('Person_Master', where: ' PID= ? ', whereArgs: [id]);
    return userId;
  }
}
