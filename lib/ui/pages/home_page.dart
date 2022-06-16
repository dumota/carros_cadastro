import 'package:carros_cadastro/datasources/local/marca_helper.dart';
import 'package:carros_cadastro/models/marca.dart';
import 'package:carros_cadastro/ui/components/mensagem_alerta.dart';
import 'package:carros_cadastro/ui/pages/cad_marca_page.dart';
import 'package:carros_cadastro/ui/pages/veiculos_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _marcaHelper = MarcaHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: const Text('Sistema de Carros - Cadastre a marca ')),
       floatingActionButton: FloatingActionButton(
       child: const Icon(Icons.add),
       onPressed: _abrirTelaCadastro,
      ),
      body: FutureBuilder(
        future: _marcaHelper.getTodos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }
              return _criarLista(snapshot.data as List<Marca>);
          }
        },
      ),
    );
  }

  Widget _criarLista(List<Marca> listaDados) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: listaDados.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          child: _criarItemLista(listaDados[index]),
          background: Container(
            alignment: const Alignment(-1, 0),
            color: Colors.blue,
            child: const Text('Editar uma marca',
              style: TextStyle(color: Colors.white),),
          ),
          secondaryBackground: Container(
            alignment: const Alignment(1, 0),
            color: Colors.red,
            child: const Text('Excluir marca',
              style: TextStyle(color: Colors.white),),
          ),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.startToEnd) {
              _abrirTelaCadastro(marca : listaDados[index]);
            }
            else if (direction == DismissDirection.endToStart) {
              _marcaHelper.apagar(listaDados[index]);
            }
          },
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.endToStart) {
              return await MensagemAlerta.show(
                context: context,
                titulo: 'Atenção',
                texto: 'Deseja mesmo excluir esta marca?',
                botoes: [
                  TextButton(
                    child: const Text('Sim'),
                    onPressed: (){ Navigator.of(context).pop(true); }
                  ),
                  ElevatedButton(
                    child: const Text('Não'),
                      onPressed: (){ Navigator.of(context).pop(false); }
                  ),
                ]);
            }
            return true;
          },
        );
      }
    );
  }



  Widget _criarItemLista(Marca marca) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(marca.nome, style: const TextStyle(fontSize: 28),),
            ],
          ),
        ),
      ),
      onTap: () => _abrirListaVeiculos(marca),
      onLongPress: () => _abrirTelaCadastro(marca: marca),
    );
  }



  void _abrirListaVeiculos(Marca marca) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => VeiculosPage(marca)
    ));
  }

  void _abrirTelaCadastro({Marca? marca}) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => CadMarcaPage(marca: marca,)
    ));

    setState(() { });
  }
}