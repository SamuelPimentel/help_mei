import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/pages/cadastro_produto/cadastro_produto_page.dart';
import 'package:help_mei/pages/listar_produtos/widgets/produto_card.dart';

class ListarProdutosPage extends StatefulWidget {
  const ListarProdutosPage(
      {super.key,
      required this.produtos,
      required this.marcas,
      required this.controller});

  final List<Produto> produtos;
  final List<Marca> marcas;
  final EntityControllerGeneric controller;

  @override
  State<ListarProdutosPage> createState() => _ListarProdutosPageState();
}

class _ListarProdutosPageState extends State<ListarProdutosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produtos Cadastrados',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline_outlined),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroProdutoPage(
                  marcas: widget.marcas, controller: widget.controller),
            ),
          );
          if (result != null) {
            setState(() {
              widget.produtos.add(result as Produto);
            });
          }
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: widget.produtos.length,
        itemBuilder: (context, index) {
          return produtoCard(context, widget.produtos[index]);
        },
      ),
    );
  }
}
