abstract class Media {
  const Media();

  static const _baseImage = 'assets/images';
  static const _baseLottie = 'assets/lottie';

  static const user = '$_baseImage+/user.jpg';

  static const search = '$_baseLottie+/search.json';
  static const cart = '$_baseLottie+/empty_cart.json';
  static const error = '$_baseLottie+/Error.json';
  static const success = '$_baseLottie+/Success.json';
}
