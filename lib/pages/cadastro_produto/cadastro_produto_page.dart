import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/pages/cadastro_produto/widgets/autocomplete_produto.dart';
import 'package:help_mei/pages/cadastro_produto/widgets/textfield_cadastro_produto.dart';

class CadastroProdutoPage extends StatelessWidget {
  CadastroProdutoPage(
      {super.key, required this.marcas, required this.controller});

  final TextEditingController _marcaController = TextEditingController();
  final List<Marca> marcas;
  final EntityControllerGeneric controller;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textfieldCadastroProduto(
                  context, 'Nome do produto', _nomeController),
              textfieldCadastroProduto(
                  context, 'Descrição do produto', _descricaoController),
              autoCompleteProduto(
                _marcaController,
                marcas.map((marca) {
                  return marca.nomeMarca;
                }).toList(),
                'Marca do produto:',
              ),
              autoCompleteProduto(
                _marcaController,
                marcas.map((marca) {
                  return marca.nomeMarca;
                }).toList(),
                'Marca do produto:',
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _concluirCadastro(context);
                  },
                  child: Text('Cadastrar'))
            ],
          ),
        ),
      ),
    );
  }

  void _concluirCadastro(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Concluir cadastro?'),
          content: const Text('Deseja inserir os dados do produto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cadastraProduto(context);
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  void _cadastraProduto(BuildContext context) async {
    var resultado = marcas.where((marca) {
      return (marca.nomeMarca.toLowerCase() ==
          _marcaController.text.toLowerCase());
    });

    Marca marca;

    if (resultado.isEmpty) {
      var marcaCadastro = Marca.noPrimaryKey(nomeMarca: _marcaController.text);

      await controller.insertEntity(marcaCadastro);

      marca = marcaCadastro;
    } else {
      marca = resultado.first;
    }

    var produto = Produto.noPrimaryKey(
        nomeProduto: _nomeController.text,
        descricaoProduto: _descricaoController.text,
        imagemProduto: null,
        idMarca: marca.idMarca);
    await controller.insertEntity(produto);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Produto cadastrado com sucesso! \n Deseja continuar cadastrando?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(produto);
              },
              child: Text('Não'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}
