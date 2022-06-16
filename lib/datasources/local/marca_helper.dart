
import 'package:carros_cadastro/datasources/local/banco_dados.dart';
import 'package:carros_cadastro/models/marca.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

const sqlCreateMarca = '''
    CREATE TABLE $marcaTabela (
      $marcaCodigo INTEGER PRIMARY KEY AUTOINCREMENT,
      $marcaNome TEXT
    )
  ''';

class MarcaHelper {
  Future<Marca> inserir(Marca marca) async {
    Database db = await BancoDados().db;

    marca.codigo = await db.insert(marcaTabela, marca.toMap());
    return marca;
  }

  Future<int> alterar(Marca marca) async {
    Database db = await BancoDados().db;

    return db.update(marcaTabela, marca.toMap(),
      where: '$marcaCodigo = ?',
      whereArgs: [marca.codigo]
    );
  }

  Future<int> apagar(Marca marca) async {
    Database db = await BancoDados().db;

    return db.delete(marcaTabela,
      where: '$marcaCodigo = ?',
      whereArgs: [marca.codigo]
    );
  }

  Future<List<Marca>> getTodos() async {
    Database db = await BancoDados().db;

    //List dados = await db.rawQuery('SELECT * FROM $editoraTabela');
    List dados = await db.query(marcaTabela);

    return dados.map((e) => Marca.fromMap(e)).toList();
  }

  Future<Marca?> getMarca(int codigo) async {
    Database db = await BancoDados().db;

    List dados = await db.query(marcaTabela,
      columns: [marcaCodigo, marcaNome],
      where: '$marcaCodigo = ?',
      whereArgs: [codigo]
    );

    if (dados.isNotEmpty) {
      return Marca.fromMap(dados.first);
    }
    return null;
  }

  Future<int> getTotal() async {
    Database db = await BancoDados().db;

    return firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $marcaTabela')
    ) ?? 0;
  }
}