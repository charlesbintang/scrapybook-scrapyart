class Template {

  final String category;


  final String image;


  final int placeholder;


  Template({

    required this.category,

    required this.image,

    required this.placeholder,

  });

}


List<Template> templateList = [

  Template(

      category: 'animals',

      image: 'lib/salisa/ngetemplate_assets/1_animals.png',

      placeholder: 2),

  Template(

      category: 'vintage',

      image: 'lib/salisa/ngetemplate_assets/2_vintage.png',

      placeholder: 5),

  Template(

      category: 'vintage',

      image: 'lib/salisa/ngetemplate_assets/3_vintage.png',

      placeholder: 2),

  Template(

      category: 'modren',

      image: 'lib/salisa/ngetemplate_assets/2_modren.png',

      placeholder: 4),

];

