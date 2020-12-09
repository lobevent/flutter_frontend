extension RouteInterpolation on String {
  String interpolate(String string, Map<String, String> params) {

    final String result = string;
    params.forEach((key, value) => result.replaceAll('%$key\$', value));

    return result;
  }

}
