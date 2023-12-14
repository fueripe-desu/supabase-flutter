enum RequestMode { rest }

enum OperationMode { select }

class QueryParser {
  final Uri query;
  late final String url;
  late final RequestMode mode;
  late final OperationMode operation;
  late final String version;
  late final String table;
  late final Map<String, String> rawQueryParams;
  late final List<QueryParam> queryParams;

  QueryParser(this.query) {
    final splitPath = query.path.split('/');
    url = splitPath[0];
    mode = _getRequestMode(splitPath[1]);
    version = splitPath[2];
    table = splitPath[3];

    rawQueryParams = query.queryParameters;
    operation = _getOperation();

    queryParams = _parseQueryParams();
  }

  List<QueryParam> _parseQueryParams() {
    final List<QueryParam> queryParamsList = [];

    if (mode == RequestMode.rest) {
      if (operation == OperationMode.select) {
        final selectParams = rawQueryParams['select']!;

        if (selectParams == "*") {
          queryParamsList.add(EverythingParam());
          return [...queryParamsList];
        }

        // Used to split the params string by its outter commas.
        // e.g. "username,current_task(title,description)"
        // output: ["username", "current_task(title,description)"]
        final splitRegex = RegExp(r',(?![^(]*\))');
        final splitParams = selectParams.split(splitRegex);

        for (final param in splitParams) {
          // Handles the case where a custom field name is passed in the query
          String? customName;
          List<String>? customNameSplit;

          // When it contains a colon it means that a custom field name
          // has been specified
          if (param.contains(':')) {
            customNameSplit = param.split(':');
            customName = customNameSplit[0];
          }

          // If a param contains an opening parenthesis it's a foreign key
          if (param.contains('(')) {
            // Used to split the foreign key param string by its columns inside
            // the parentheses and also get the table name before the parentheses.
            // e.g. "current_task(title,description)"
            // output: "current_task" and ["title", "description"]
            final foreignKeyRegex = RegExp(r'^(.*?)\((.*?)\)$');
            final match =
                foreignKeyRegex.firstMatch(customNameSplit?[1] ?? param);

            if (match != null) {
              final tableName = match.group(1)!;
              final columns = match.group(2)!;

              final columnsList = columns.split(',');

              final fkParam = ForeignKeyParam(
                table: tableName,
                columns: columnsList,
                customName: customName,
              );

              queryParamsList.add(fkParam);
              continue;
            } else {
              throw Exception('Invalid foreign key param string.');
            }
          }

          // Case it doesn't pass any of the above if statements, it's a column param
          final columnParam = ColumnParam(
            column: customNameSplit?[1] ?? param,
            customName: customName,
          );
          queryParamsList.add(columnParam);
        }
      }
    }
    return [...queryParamsList];
  }

  RequestMode _getRequestMode(String requestName) {
    switch (requestName) {
      case "rest":
        return RequestMode.rest;
      default:
        throw Exception('Unknown request mode.');
    }
  }

  OperationMode _getOperation() {
    if (rawQueryParams.containsKey('select')) {
      return OperationMode.select;
    }

    throw Exception('Unknown operation.');
  }
}

abstract class QueryParam {}

class ColumnParam implements QueryParam {
  final String column;
  final String? customName;

  const ColumnParam({
    required this.column,
    this.customName,
  });
}

class ForeignKeyParam implements QueryParam {
  final String table;
  final String? customName;
  final List<String> columns;

  const ForeignKeyParam({
    required this.table,
    required this.columns,
    this.customName,
  });
}

class EverythingParam implements QueryParam {}
