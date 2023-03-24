import 'package:flutter/material.dart';
import 'package:help_mei/entities/produto.dart';

Widget produtoCard(BuildContext context, Produto produto) {
  return Card(
    elevation: 5,
    child: Row(
      children: [
        SizedBox(
          width: 10,
        ),
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
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                produto.nomeProduto,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,
              ),
              Text(
                produto.descricaoProduto,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Chip(label: Text('Doce')),
                  const Chip(label: Text('Chocolate')),
                  const Chip(label: Text('Bala')),
                ],
              )
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Text('R\$5.00'),
              Text(
                'Valor atual',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        )
      ],
    ),
  );
}
