import 'dart:math';

import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/irequest_new_primary_key.dart';
import 'package:help_mei/helpers/constantes.dart';

class Saldos extends Entity implements IRequestNewPrimaryKey {
  int idProduto;
  int quantidadeSaldos;
  double custoUnitarioSaldos;
  double totalSaldos;

  Saldos(
      {required this.idProduto,
      required this.quantidadeSaldos,
      required this.custoUnitarioSaldos,
      required this.totalSaldos})
      : super(tableName: 'saldos');
  Saldos.fromMap(Map map)
      : this(
          idProduto: map['id_produto'],
          quantidadeSaldos: map['quantidade_saldos'],
          custoUnitarioSaldos: map['custo_unitario_saldos'],
          totalSaldos: map['total_saldos'],
        );

  @override
  Entity fromMap(Map map) {
    return Saldos.fromMap(map);
  }

  @override
  Map<String, String> getPrimaryKeys() {
    return {'id_produto': idProduto.toString()};
  }

  @override
  void setPrimaryKeys(Map<String, dynamic> keys) {
    idProduto = keys['id_produto'];
  }

  @override
  void requestNewPrimaryKeys() {
    var rnd = Random();
    idProduto = rnd.nextInt(maxInt32);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_produto': idProduto,
      'quantidade_saldos': quantidadeSaldos,
      'custo_unitario_saldos': quantidadeSaldos,
      'total_saldos': totalSaldos,
    };
  }
}
