import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/saldos.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/pages/cadastro_produto/cadastro_produto_page.dart';
import 'package:help_mei/widgets/produto_card.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
        child: const Icon(Icons.add_circle_outline_outlined),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroProdutoPage(
                  marcas: widget.marcas, controller: widget.controller),
            ),
          );
          setState(() {
            getFuture();
          });
        },
      ),
      body: FutureBuilder(
        future: getFuture(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) return Container();
              return buildListView(context, snapshot);
          }
        },
      ),
    );
  }

  Widget buildListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: snapshot.data['produtos'].length,
      itemBuilder: (context, index) {
        return ProdutoCard(
          controller: widget.controller,
          produto: snapshot.data['produtos'][index],
          categorias: snapshot.data['categorias'].where((element) {
            for (var cat in snapshot.data['produtos'][index].categorias) {
              if (cat.idCategoria == element.idCategoria) return true;
            }
            return false;
          }).toList(),
          saldo: snapshot.data['saldos']
              .where((element) =>
                  element.idProduto ==
                  snapshot.data['produtos'][index].idProduto)
              .first,
          refresh: () {
            setState(() {
              getFuture();
            });
          },
        );
      },
    );
  }

  Future<Map> getFuture() async {
    var itens = await widget.controller.getEntities(Produto.empty());
    List<Produto> produtos = [];
    var cats = await widget.controller.getEntities(Categoria.empty());
    List<Categoria> categorias = [];
    for (var cat in cats) {
      categorias.add(cat as Categoria);
    }

    var sa = await widget.controller.getEntities(Saldos.empty());
    List<Saldos> saldos = [];
    for (var s in sa) {
      saldos.add(s as Saldos);
    }

    Directory documentDirectory = await getApplicationDocumentsDirectory();

    for (var iten in itens) {
      produtos.add(iten as Produto);

      if (iten.imagemProduto != null) {
        String imagePath = join(documentDirectory.path,
            '$helpMeiPath/images/${iten.imagemProduto}');
        File? imageFile;

        try {
          imageFile = File(imagePath);
        } catch (e) {
          imageFile = null;
        }
        iten.imageFile = imageFile;
      }
    }

    return {
      'produtos': produtos,
      'categorias': categorias,
      'saldos': saldos,
    };
  }
}
