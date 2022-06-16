
import 'package:carros_cadastro/datasources/local/marca_helper.dart';
import 'package:carros_cadastro/models/marca.dart';
import 'package:carros_cadastro/ui/components/campo_texto.dart';
import 'package:carros_cadastro/ui/components/mensagem_alerta.dart';
import 'package:flutter/material.dart';

class CadMarcaPage extends StatefulWidget {
  final Marca? marca;

  const CadMarcaPage({this.marca, Key? key}) : super(key: key);

  @override
  State<CadMarcaPage> createState() => _CadMarcaPageState();
}

class _CadMarcaPageState extends State<CadMarcaPage> {
  final _marcaHelper = MarcaHelper();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.marca != null) {
      _nomeController.text = widget.marca!.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Marcas'),),
      body: ListView(
        children: [
          CampoTexto(
            controller: _nomeController,
            texto: 'Nome da Marca'
          ),
          ElevatedButton(
            onPressed: _salvarMarca,
            child: const Text('Salvar')
          ),

          Visibility(
            child: ElevatedButton(
                child: const Text('Excluir'),
                onPressed: _excluirMarca
            ),
            visible: widget.marca != null,
          ),
        ],
      ),
    );
  }

  void _excluirMarca() {
    MensagemAlerta.show(
      context: context,
      titulo: 'Atenção',
      texto: 'Deseja excluir essa marca?',
      botoes: [
        TextButton(
            child: const Text('Sim'),
            onPressed: _confirmarExclusao
        ),
        ElevatedButton(
            child: const Text('Não'),
            onPressed: (){ Navigator.pop(context); }
        ),
      ]
    );
  }

  void _confirmarExclusao() {
    if (widget.marca != null) {
      _marcaHelper.apagar(widget.marca!);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _salvarMarca() {
    if (_nomeController.text.isEmpty) {
      MensagemAlerta.show(
        context: context,
        titulo: 'Atenção',
        texto: 'Nome da marca é obrigatório!',
        botoes: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () { Navigator.pop(context); }
          ),
        ]
      );
      return;
    }
    if (widget.marca != null) {
      widget.marca!.nome = _nomeController.text;
      _marcaHelper.alterar(widget.marca!);
    }
    else {
      _marcaHelper.inserir(Marca(nome: _nomeController.text));
    }
    Navigator.pop(context);
  }
}
