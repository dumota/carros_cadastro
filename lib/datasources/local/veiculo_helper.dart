


import 'package:carros_cadastro/datasources/local/banco_dados.dart';
import 'package:carros_cadastro/datasources/local/marca_helper.dart';
import 'package:carros_cadastro/models/marca.dart';
import 'package:carros_cadastro/models/veiculo.dart';
import 'package:sqflite/sqflite.dart';

class VeiculoHelper{
  static const sqlCreate = '''
  CREATE TABLE ${Veiculo.tabela}(
    ${Veiculo.codigo_coluna} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Veiculo.modelo_coluna} TEXT,
    ${Veiculo.marca_coluna} INTEGER,
    ${Veiculo.ano_coluna} TEXT,
    ${Veiculo.valor_coluna} TEXT,
    FOREIGN KEY(${Veiculo.marca_coluna}) REFERENCES $marcaTabela($marcaCodigo)
  )
''';

  Future<Veiculo> inserir(Veiculo veiculo) async {
    Database db = await BancoDados().db;

    veiculo.codigo = await db.insert(Veiculo.tabela, veiculo.toMap());
    return veiculo;
  }

  Future<int> alterar(Veiculo veiculo) async {
    Database db = await BancoDados().db;

    return db.update(
      Veiculo.tabela,
      veiculo.toMap(),
      where: '${Veiculo.codigo_coluna} = ?',
      whereArgs: [veiculo.codigo]
    );
  }

  Future<int> apagar(Veiculo veiculo) async {
    Database db = await BancoDados().db;

    return await db.delete(Veiculo.tabela,
      where: '${Veiculo.codigo_coluna} = ?',
      whereArgs: [veiculo.codigo]
    );
  }

  Future<List<Veiculo>> getByMarca(int codMarca) async {
    Marca? marca = await MarcaHelper().getMarca(codMarca);

    if (marca != null) {
      Database db = await BancoDados().db;

      List dados = await db.query(
        Veiculo.tabela,
        where: '${Veiculo.marca_coluna} = ?',
        whereArgs: [codMarca],
        orderBy: Veiculo.modelo_coluna
      );

      return dados.map((e) => Veiculo.fromMap(e, marca)).toList();
    }

    return [];
  }

  Future<Veiculo?> getVeiculo(int codVeiculo) async {
    Database db = await BancoDados().db;

    List dados = await db.query(
      Veiculo.tabela,
      where: '${Veiculo.codigo_coluna} = ?',
      whereArgs: [codVeiculo]
    );

    if (dados.isNotEmpty) {
      int codMarca= int.parse(dados.first[Veiculo.marca_coluna].toString());
      Marca marca = (await MarcaHelper().getMarca(codMarca))!;
      return Veiculo.fromMap(dados.first, marca);
    }
    return null;
  }


}