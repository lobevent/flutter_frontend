extension RouteInterpolation on String {
  String interpolate(Map<String, String> params) {

    final String result = this;
    params.forEach((key, value) => result.replaceAll('%$key%', value));

    return result;
  }

}
