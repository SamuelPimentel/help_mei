import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/categoria.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/entities/saldos.dart';
import 'package:help_mei/pages/compra_produto.dart';

class ProdutoCard extends StatelessWidget {
  const ProdutoCard({
    super.key,
    required this.produto,
    required this.categorias,
    required this.controller,
    required this.saldo,
    this.refresh,
  });

  final Produto produto;
  final List<Categoria> categorias;
  final EntityControllerGeneric controller;
  final Saldos saldo;
  final void Function()? refresh;

  Widget chipCategoria(Categoria categoria) {
    return Chip(
      label: Text(categoria.nomeCategoria),
      surfaceTintColor: categoria.colorCategoria,
    );
  }

  Widget buildCategoria() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [for (var categoria in categorias) chipCategoria(categoria)],
      ),
    );
  }

  void onTapCard(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompraProduto(
            produto: produto,
            controller: controller,
          ),
        )).then((value) {
      if (refresh != null) refresh!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => onTapCard(context),
        splashColor: Theme.of(context).colorScheme.secondary,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: produto.imageFile == null
                        ? const AssetImage('assets/images/waiting.png')
                            as ImageProvider
                        : FileImage(produto.imageFile!),
                  ),
                  color: Colors.white38,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: produto.nomeProduto,
                    child: Text(
                      produto.nomeProduto,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text(
                    produto.descricaoProduto,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  buildCategoria()
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Text('R\$${saldo.custoUnitario.toStringAsFixed(2)}'),
                  Text(
                    'Valor atual',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(),
                  Text('${saldo.quantidade}'),
                  Text(
                    'Estoque',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
