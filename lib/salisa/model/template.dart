class Template {
  final String category;
  final String image;
  final double templateHeight;
  final double templateWidth;
  final int id;
  final int placeholder;

  Template({
    required this.id,
    required this.templateHeight,
    required this.templateWidth,
    required this.category,
    required this.image,
    required this.placeholder,
  });
}

List<Template> templateList = [
  Template(
      id: 0,
      templateHeight: 1080,
      templateWidth: 1080,
      category: 'animals',
      image: 'lib/salisa/ngetemplate_assets/1_animals.png',
      placeholder: 2),
  Template(
      id: 1,
      templateHeight: 1748, //1748,
      templateWidth: 1240, //1240,
      category: 'vintage',
      image: 'lib/salisa/ngetemplate_assets/2_vintage.png',
      placeholder: 5),
  Template(
      id: 2,
      templateHeight: 1080,
      templateWidth: 1080,
      category: 'vintage',
      image: 'lib/salisa/ngetemplate_assets/3_vintage.png',
      placeholder: 2),
  Template(
      id: 3,
      templateHeight: 1080,
      templateWidth: 1080,
      category: 'modren',
      image: 'lib/salisa/ngetemplate_assets/2_modren.png',
      placeholder: 4),
];
