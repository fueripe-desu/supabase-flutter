class FilterBuilder {
  final List<Map<String, dynamic>> _data;
  const FilterBuilder(List<Map<String, dynamic>> data) : _data = data;

  List<Map<String, dynamic>> execute() => _data;

  FilterBuilder eq(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] == value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder neq(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] != value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder gt(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] > value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder gte(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] >= value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder lt(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] < value).toList();

    return FilterBuilder(newData);
  }

  FilterBuilder lte(String column, dynamic value) {
    final data = _data;
    final newData = data.where((element) => element[column] <= value).toList();

    return FilterBuilder(newData);
  }
}
