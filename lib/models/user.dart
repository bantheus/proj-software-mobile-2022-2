class User {
  String nome;
  String email;
  String celular;
  String senha;
  bool status;

  User({
    required this.nome,
    required this.email,
    required this.celular,
    required this.senha,
    this.status = false,
  });
}
