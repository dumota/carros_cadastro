const marcaTabela = 'TbMarca';
const marcaCodigo = 'codigo';
const marcaNome   = 'nome';

class Marca{
  int? codigo;
  String nome ;

  Marca({this.codigo, required this.nome});

  factory Marca.fromMap(Map map){
    return Marca(
      codigo: int.tryParse(map[marcaCodigo].toString()),
      nome: map[marcaNome]
    );
  }


  Map<String, dynamic> toMap(){
    return{
      marcaCodigo: codigo,
      marcaNome : nome
    };
  }
}