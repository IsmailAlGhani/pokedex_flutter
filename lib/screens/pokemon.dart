class PokemonListItemModel {
  PokemonListItemModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory PokemonListItemModel.fromJSON(Map<String, dynamic> data) {
    var url = data['url'];
    return PokemonListItemModel(
      id: url.split('/')[url.split('/').length - 2],
      name: data['name'],
    );
  }

  PokemonListItemModel.dummy() : id = '0', name = 'test';

  @override
  String toString() {
    // TODO: implement toString
    return '{id: $id, name: $name}';
  }
}
