import 'package:miaudote/models/style-card.dart';

class Pet {
  int id;
  String nome;
  String imagem;
  List<String> sexo;
  List<String> especie;
  int idade;
  StyleCard styleCard;

  Pet({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.sexo,
    required this.especie,
    required this.idade,
    required this.styleCard,
  });
}
