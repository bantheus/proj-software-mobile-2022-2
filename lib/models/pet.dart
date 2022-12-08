class Pet {
  String id;
  String nome;
  String imagem;
  String descricao;
  String sexo;
  String especie;
  int idade;
  String dataEntrada;
  String dataAdocao;
  String tutor;
  int status;

  Pet(
      {required this.id,
      required this.nome,
      required this.imagem,
      required this.descricao,
      required this.sexo,
      required this.especie,
      required this.idade,
      required this.dataEntrada,
      required this.dataAdocao,
      this.status = 0,
      this.tutor = 'ong'});
}
