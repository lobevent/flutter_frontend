extension RouteInterpolation on String {
  String interpolate(Map<String, String> params) {
    String result = this;
    params.forEach((key, value) {
      result = result.replaceAll(RegExp(r'%' + key + '%'), value);
    });

    return result;
  }
}
