
import 'package:carros_cadastro/datasources/local/veiculo_helper.dart';
import 'package:carros_cadastro/models/marca.dart';
import 'package:carros_cadastro/models/veiculo.dart';
import 'package:carros_cadastro/ui/components/campo_texto.dart';
import 'package:flutter/material.dart';

class CadVeiculoPage extends StatefulWidget {
  final Marca marca;
  final Veiculo? veiculo;

  const CadVeiculoPage(this.marca, {this.veiculo, Key? key}) : super(key: key);

  @override
  State<CadVeiculoPage> createState() => _CadVeiculoPageState();
}

class _CadVeiculoPageState extends State<CadVeiculoPage> {
  final _veiculoHelper = VeiculoHelper();
  final _nomeController = TextEditingController();
  final _anoController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.veiculo != null) {
      _nomeController.text = widget.veiculo!.modelo;
      _anoController.text = widget.veiculo!.ano;
      _valorController.text = widget.veiculo!.valor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro Veiculo - ${widget.marca.nome}')),
      body: ListView(
        children: [
          CampoTexto(
            controller: _nomeController,
            texto: 'Nome do Veiculo'
          ),
          CampoTexto(
            controller: _anoController,
            texto: 'ano do Veiculo',
            teclado: TextInputType.number,
          ),
          CampoTexto(
            controller: _valorController,
            texto: 'Valor do Veiculo',
            teclado: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: _salvarVeiculo,
            child: const Text('Salvar')
          ),
          _criarBotaoExcluir(),
        ],
      ),
    );
  }

  Widget _criarBotaoExcluir() {
    if (widget.veiculo != null) {
      return ElevatedButton(
          onPressed: _excluirVeiculo,
          child: const Text('Excluir')
      );
    }
    return Container();
  }

  void _excluirVeiculo() {
    _veiculoHelper.apagar(widget.veiculo!);
    Navigator.pop(context);
  }

  void _salvarVeiculo() {
    if (widget.veiculo != null) {
      widget.veiculo!.modelo = _nomeController.text;
      widget.veiculo!.ano = _anoController.text;
      widget.veiculo!.valor = _valorController.text;
      _veiculoHelper.alterar(widget.veiculo!);
    }
    else {
      _veiculoHelper.inserir(Veiculo(
          modelo: _nomeController.text,
          marca: widget.marca,
          ano: _anoController.text,
          valor: _valorController.text
      ));
    }
    Navigator.pop(context);
  }
}
