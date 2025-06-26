import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/*
|--------------------------------------------------------------------------
|
| ***
|
|--------------------------------------------------------------------------
*/
class SqlViewer extends StatefulWidget {
  const SqlViewer({super.key});

  @override
  State<SqlViewer> createState() => _SqlViewerState();
}

class _SqlViewerState extends State<SqlViewer> {
  Widget? homeBody;
  SqlHelper sqlHelper = SqlHelper('jahezly.db');

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('SQL Viewer'),
          leading: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_sharp),
          ),
        ),
        body: homeBody,
      ),
    );
  }

  void init() {
    sqlHelper.databaseExists().then((value) {
      if (value == true) {
        setState(() {
          /* getAllRows('options')
              .then((value) => homeBody = Text(value.toString())); */
          homeBody = FutureBuilder<List<dynamic>>(
            //future: sqlHelper.listTables(),
            future: sqlHelper.listTables(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  String? data = snapshot.data?[index];
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('$data'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SqlTable(data!)),
                      );
                    },
                  );
                },
              );
            },
          );
        });
      } else {
        setState(() {
          homeBody = const Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Don't Found DataBass",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        });
      }
    });
  }

  Future<int?> getAllRows(String table) async {
    final dbClient = await sqlHelper.database;
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      "SELECT COUNT(*) FROM `options`",
    );
    return Sqflite.firstIntValue(queryResult!);
  }

  /*   Future<int?> countRows(String table) async {
    final dbClient = await sqlHelper.database;
    ;
    final result = await dbClient?.rawQuery('SELECT COUNT(*) FROM `orders`');
    final count = Sqflite.firstIntValue(result!);
    return count;
  } */
}

/*
|--------------------------------------------------------------------------
|
| ***
|
|--------------------------------------------------------------------------
*/
class SqlTable extends StatefulWidget {
  const SqlTable(this.tableName, {super.key});

  final String tableName;
  //final int rowCount;

  @override
  State<SqlTable> createState() => _SqlTableState();
}

class _SqlTableState extends State<SqlTable> {
  final SqlHelper sqlHelper = SqlHelper('jahezly.db');
  String? rrr;
  List<String> listTableColumns = [];

  @override
  void initState() {
    super.initState();
    countRows(
      widget.tableName,
    ).then((value) => {setState(() => rrr = value.toString())});
    sqlHelper.columnsTable(widget.tableName).then((value) {
      setState(() => listTableColumns = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.tableName.toString()),
          leading: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_sharp),
          ),
        ),
        body: Column(
          children: [
            Text(widget.tableName.toString()),
            Text('Row Count: $rrr'),
            const Text('---------------------'),
            ElevatedButton(
              onPressed: () {
                emptyTable(widget.tableName.toString()).then((value) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                });
              },
              child: const Text('Empty'),
            ),

            //_buildUserInfo(),
            Container(
              child: _buildUserInfo(widget.tableName, listTableColumns),
            ),
            //Expanded(child: _buildUserInfo()),
          ],
        ),
      ),
    );
  }

  Future<void> emptyTable(String table) async {
    final dbClient = await sqlHelper.database;

    await dbClient?.rawQuery('DELETE FROM `$table`');
    //final count = Sqflite.firstIntValue(result!);
    //return count;
  }

  Future<int?> countRows(String table) async {
    final dbClient = await sqlHelper.database;

    final result = await dbClient?.rawQuery('SELECT COUNT(*) FROM `$table`');
    final count = Sqflite.firstIntValue(result!);
    return count;
  }

  FutureBuilder<List?>? _buildUserInfo(String table, List<String> tableColumn) {
    return FutureBuilder<List?>(
      //
      future: sqlHelper.fetchRows(table),
      builder: (context, snapshot) {
        //
        if (snapshot.hasData) {
          return SqlDataTable(
            listOrser: snapshot.data!,
            listColumnsName: tableColumn,
          );
        } else if (snapshot.hasError) {
          //
          return Text('${snapshot.error}');
        }
        //
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /*   List<String> aa(String table) {
    sqlHelper.columnsTable(table).then((value) {
      return value;
    });
  } */
}

/*
|--------------------------------------------------------------------------
|
| ***
|
|--------------------------------------------------------------------------
*/
class SqlDataTable extends StatelessWidget {
  const SqlDataTable({
    super.key,
    required this.listOrser,
    required this.listColumnsName,
  });

  final List<dynamic> listOrser;
  final List<String> listColumnsName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //scrollDirection: Axis.horizontal,
      child: FittedBox(
        fit: BoxFit.contain,
        child: DataTable(
          // Datatable widget that have the property columns and rows.
          columns:
              listColumnsName.map((e) => DataColumn(label: Text(e))).toList(),
          /* columns: const [
            // Set the name of the column
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
          ], */
          rows: listOrser.map((data) => DataRow(cells: aa(data))).toList(),
        ),
      ),
    );
  }

  List<DataCell> aa(dynamic data) {
    return listColumnsName
        .map((e) => DataCell(Text(data[e].toString())))
        .toList();
  }
}

/* class HomeSql extends StatelessWidget {
  HomeSql({super.key});
  SqlHelper sqlHelper = SqlHelper('cart.db');

  @override
  Widget build(BuildContext context) {
    return aa();
  }

  Future<List<String>> aa() {
    sqlHelper.tables().then((value) {
      return Text(value.toString());
    });
  }
} */

/*
|--------------------------------------------------------------------------
|
| ***
|
|--------------------------------------------------------------------------
*/
class SqlHelper {
  SqlHelper(this.dataBaseName);
  final String? dataBaseName;

  static Database? _database;
  /*
  |--------------------------------------------------------------------------
  | Init Database
  | Chack Database If Found Or Not
  |--------------------------------------------------------------------------
  */
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await init();
    return _database;
  }

  init() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);
    var db = await openDatabase(path, version: 1, onCreate: null);
    return db;
  }

  Future<bool> databaseExists() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);
    return databaseFactory.databaseExists(path);
  }

  Future<List<String>> listTables() async {
    // you can use your initial name for dbClient
    final dbClient = await database;
    List<Map> maps = await dbClient!.rawQuery(
      'SELECT * FROM sqlite_master ORDER BY name',
    );

    List<String> tableNameList = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        try {
          if (maps[i]['name'].toString() != 'sqlite_sequence' &&
              maps[i]['name'].toString() != 'android_metadata') {
            tableNameList.add(maps[i]['name'].toString());
          }
        } catch (e) {
          //print('Exeption : ' + e);
        }
      }
    }
    return tableNameList;
  }

  Future<List<String>> columnsTable(String table) async {
    // you can use your initial name for dbClient
    final dbClient = await database;
    List<Map> maps = await dbClient!.rawQuery(
      "SELECT name FROM pragma_table_info('$table') ORDER BY cid",
    );

    List<String> lsitColumnName = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        try {
          lsitColumnName.add(maps[i]['name'].toString());
        } catch (e) {
          //print('Exeption : ' + e);
        }
      }
    }
    return lsitColumnName;
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE 'orders'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                            `marketId` INTEGER,
                            `productsKey` VARCHAR(20),
                            `totalPrice` FLOAT,
                            `quantity` INTEGER
                          )''');
    await db.execute('''CREATE TABLE 'products'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                            `marketId` INTEGER,
                            `key` INTEGER,
                            `name` TEXT,
                            `price` FLOAT,
                            `quantity` INTEGER,
                            `totalPrice` FLOAT
                          )''');

    /* await db.execute('''CREATE TABLE 'options'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT
                          )'''); */
  }

  Future<List> fetchRows(String table) async {
    final dbClient = await database;
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      'SELECT * FROM `$table` ORDER BY `id`',
    );
    return queryResult!.toList();
  }

  /*  Future<List<Map<dynamic, dynamic>>> rowsTable(String table) async {
// you can use your initial name for dbClient
    final dbClient = await database;
    List<Map> maps =
        await dbClient!.rawQuery('SELECT * FROM `$table` ORDER BY `id`');
    return maps;
  } */
}
