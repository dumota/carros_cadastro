
import 'package:carros_cadastro/datasources/local/veiculo_helper.dart';
import 'package:carros_cadastro/models/marca.dart';
import 'package:carros_cadastro/models/veiculo.dart';
import 'package:carros_cadastro/ui/pages/cad_veiculo_page.dart';
import 'package:flutter/material.dart';

class VeiculosPage extends StatefulWidget {
  final Marca marca;

  const VeiculosPage(this.marca, {Key? key}) : super(key: key);

  @override
  State<VeiculosPage> createState() => _VeiculosPageState();
}

class _VeiculosPageState extends State<VeiculosPage> {
  final _veiculoHelper = VeiculoHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.marca.nome +"-Cadastre seu Veiculo")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _cadastrarVeiculo,
      ),
      body: FutureBuilder(
        future: _veiculoHelper.getByMarca(widget.marca.codigo ?? 0),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }
              return _criarLista(snapshot.data as List<Veiculo>);
          }
        },
      ),
    );
  }

  Widget _criarLista(List<Veiculo> listaDados) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: listaDados.length,
      itemBuilder: (context, index) {
        return _criarItemLista(listaDados[index]);
      }
    );
  }

  Widget _criarItemLista(Veiculo veiculo) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          // child:  Text(veiculo.modelo, style: const TextStyle(fontSize: 28)),
          child: Column(
           
              children: [
                Text("Modelo: " +veiculo.modelo, style: const TextStyle(fontSize: 28))   ,
                Text("Ano: "+veiculo.ano, style: const TextStyle(fontSize: 28)),
                Text("Valor: "+veiculo.valor, style: const TextStyle(fontSize: 28)),
              ],
            
          ),
          

         
          // Text(veiculo.ano, style: const TextStyle(fontSize: 28)),
          
        ),
        
      ),
      onTap: () => _cadastrarVeiculo(veiculo: veiculo),
    );
  }

  void _cadastrarVeiculo({Veiculo? veiculo}) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => CadVeiculoPage(widget.marca, veiculo: veiculo,)
    ));

    setState(() { });
  }
}
