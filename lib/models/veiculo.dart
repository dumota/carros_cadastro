

import 'package:carros_cadastro/models/marca.dart';

class Veiculo {
  static const tabela = 'TbVeiculo';
  static const codigo_coluna = 'codigo';
  static const modelo_coluna = 'modelo';
  static const ano_coluna = 'ano';
  static const valor_coluna = 'valor';
  static const marca_coluna = 'cod_marca';

  int? codigo;
  String modelo;
  Marca marca;
  String ano ;
  String valor;

  Veiculo({
    this.codigo,
    required this.modelo,
    required this.marca,
    required this.ano,
    required this.valor
  });


  factory Veiculo.fromMap(Map map , Marca marca){
    return Veiculo(
      codigo: int.tryParse(map[codigo_coluna].toString()),
      modelo: map[modelo_coluna],
      marca: marca,
      ano: map[ano_coluna],
      valor: map[valor_coluna]
    );
  }

  Map<String, dynamic> toMap(){
    return {
      codigo_coluna: codigo,
      modelo_coluna: modelo,
      marca_coluna: marca.codigo,
      ano_coluna: ano,
      valor_coluna: valor
    };
  }

}