import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:help_mei/controller/entity_controller_generic.dart';
import 'package:help_mei/entities/marca.dart';
import 'package:help_mei/entities/produto.dart';
import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/helpers/helper.dart';
import 'package:help_mei/pages/cadastro_produto/widgets/autocomplete_produto.dart';
import 'package:help_mei/pages/cadastro_produto/widgets/textfield_cadastro_produto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage(
      {super.key, required this.marcas, required this.controller});

  final List<Marca> marcas;
  final EntityControllerGeneric controller;

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final TextEditingController _marcaController = TextEditingController();

  final TextEditingController _nomeController = TextEditingController();

  final TextEditingController _descricaoController = TextEditingController();

  final TextEditingController _categoriaController = TextEditingController();

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(70),
                  splashColor: Theme.of(context).colorScheme.secondary,
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                    );
                    if (result != null) {
                      File image = File(result.files.single.path!);
                      setState(() {
                        imageFile = image;
                      });
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageFile == null
                            ? const AssetImage('assets/images/waiting.png')
                                as ImageProvider
                            : FileImage(imageFile!),
                      ),
                    ),
                  ),
                ),
                textfieldCadastroProduto(
                    context, 'Nome do produto', _nomeController),
                textfieldCadastroProduto(
                    context, 'Descrição do produto', _descricaoController),
                autoCompleteProduto(
                  _marcaController,
                  widget.marcas.map((marca) {
                    return marca.nomeMarca;
                  }).toList(),
                  'Marca do produto:',
                ),
                autoCompleteProduto(
                  _marcaController,
                  widget.marcas.map((marca) {
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
    var resultado = widget.marcas.where((marca) {
      return (marca.nomeMarca.toLowerCase() ==
          _marcaController.text.toLowerCase());
    });

    Marca marca;

    if (resultado.isEmpty) {
      var marcaCadastro = Marca.noPrimaryKey(nomeMarca: _marcaController.text);

      await widget.controller.insertEntity(marcaCadastro);

      marca = marcaCadastro;
    } else {
      marca = resultado.first;
    }

    String? imagemProduto = null;
    if (imageFile != null) {
      String imageName = nextPrimaryKey().toString();
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String imageDirectory =
          join(documentDirectory.path, '$helpMeiPath/images');
      Directory imgDirectory = Directory(imageDirectory);
      var existe = await imgDirectory.exists();
      if (!existe) {
        await imgDirectory.create(recursive: true);
      }
      //imageFile = await imageFile!.copy(imageDirectory);
      imageName = '$imageName${extension(imageFile!.path.toString())}';
      await imageFile!.rename(join(imageDirectory, imageName));
      imagemProduto = imageName;
    }

    var produto = Produto.noPrimaryKey(
        nomeProduto: _nomeController.text,
        descricaoProduto: _descricaoController.text,
        imagemProduto: imagemProduto,
        idMarca: marca.idMarca);
    await widget.controller.insertEntity(produto);

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
