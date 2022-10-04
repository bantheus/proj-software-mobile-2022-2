class Pet {
  int id;
  String nome;
  String imagem;
  String descricao;
  List<String> sexo;
  List<String> especie;
  int idade;

  Pet({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.sexo,
    required this.especie,
    required this.idade,
  });
}
