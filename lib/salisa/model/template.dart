class Template {
  final String category;
  final String image;
  final int id;
  final int placeholder;

  Template({
    required this.id,
    required this.category,
    required this.image,
    required this.placeholder,
  });
}

List<Template> templateList = [
  Template(
      id: 0,
      category: 'animals',
      image: 'lib/salisa/ngetemplate_assets/1_animals.png',
      placeholder: 2),
  Template(
      id: 1,
      category: 'vintage',
      image: 'lib/salisa/ngetemplate_assets/2_vintage.png',
      placeholder: 5),
  Template(
      id: 2,
      category: 'vintage',
      image: 'lib/salisa/ngetemplate_assets/3_vintage.png',
      placeholder: 2),
  Template(
      id: 3,
      category: 'modren',
      image: 'lib/salisa/ngetemplate_assets/2_modren.png',
      placeholder: 4),
];
