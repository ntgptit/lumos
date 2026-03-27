abstract final class AppAssets {
  static const root = 'assets';
  static const iconsPath = '$root/icons';
  static const imagesPath = '$root/images';
  static const animationsPath = '$root/animations';
  static const illustrationsPath = '$imagesPath/illustrations';
  static const logosPath = '$imagesPath/logos';

  static String icon(String name, {String extension = 'svg'}) {
    return '$iconsPath/$name.$extension';
  }

  static String image(String name, {String extension = 'png'}) {
    return '$imagesPath/$name.$extension';
  }

  static String animation(String name, {String extension = 'json'}) {
    return '$animationsPath/$name.$extension';
  }

  static String illustration(String name, {String extension = 'png'}) {
    return '$illustrationsPath/$name.$extension';
  }

  static String logo(String name, {String extension = 'png'}) {
    return '$logosPath/$name.$extension';
  }
}
