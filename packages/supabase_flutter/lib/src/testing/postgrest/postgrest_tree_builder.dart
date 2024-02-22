import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tokens.dart';

class PostrestValueTreeBuilder {
  final List<PostrestValueToken> _tokens = [];

  PostrestValueToken buildTree(List<PostrestValueToken> tokens) {
    _tokens.addAll(tokens);
    final finalToken = _buildTree();
    cleanCache();
    return finalToken;
  }

  PostrestValueToken _buildTree() {
    final List<PostrestValueToken> finalTokens = [];
    final bool isComplexType = _tokens.length > 1;

    for (int i = 0; i < _tokens.length; i++) {
      final token = _tokens[i];

      if (token is EndToken) {
        finalTokens.add(token);
        final newToken = _buildLastToken(finalTokens, isComplexType);
        finalTokens.add(newToken);
      } else {
        finalTokens.add(token);
      }
    }

    return finalTokens.first;
  }

  PostrestValueToken _buildLastToken(
      List<PostrestValueToken> tokensList, bool isComplexType) {
    final List<PostrestValueToken> localTokens = [];

    while (tokensList.isNotEmpty && !_isStartToken(tokensList.last)) {
      final token = tokensList.removeLast();
      localTokens.insert(0, token);
    }

    if (isComplexType) {
      final startToken = tokensList.removeLast();
      localTokens.insert(0, startToken);
    }

    if (isComplexType && localTokens.any((token) => _isDelimiterToken(token))) {
      if (_listHasJson(localTokens)) {
        final jsonString = _rebuildTokenString(localTokens);
        return JsonToken(jsonString);
      } else {
        final values = _filterValueTokens(localTokens);
        return ListToken(values);
      }
    } else {
      return localTokens.first;
    }
  }

  List<PostrestValueToken> _filterValueTokens(
          List<PostrestValueToken> tokens) =>
      tokens.where((element) => _isValueToken(element)).toList();

  bool _listHasJson(List<PostrestValueToken> tokens) =>
      tokens.any((element) => element is AssignmentToken);

  bool _isDelimiterToken(PostrestValueToken token) =>
      _isStartToken(token) || _isEndToken(token);

  bool _isStartToken(PostrestValueToken token) => token is StartToken;

  bool _isEndToken(PostrestValueToken token) => token is EndToken;

  bool _isValueToken(PostrestValueToken token) =>
      token is ValueToken ||
      token is JsonToken ||
      token is ListToken ||
      token is RangeToken;

  String _rebuildTokenString(List<PostrestValueToken> tokens) {
    String buffer = '';
    for (PostrestValueToken element in tokens) {
      buffer += element.toString();
    }
    return buffer;
  }

  void cleanCache() {
    _tokens.clear();
  }
}

class PostrestExpTreeBuilder {
  final List<PostrestExpToken> _tokens = [];
  final List<PostrestExpToken> _tokenStack = [];
  final List<PostrestExpToken> _currentFilters = [];

  PostrestFilterTree buildTree(List<PostrestExpToken> tokens) {
    _tokens.addAll(tokens);
    _buildTree();
    final tree = _tokenStack.first;
    _cleanParsingCache();
    return tree as PostrestFilterTree;
  }

  void _buildTree() {
    for (final token in _tokens) {
      if (token is PostrestFilterParams) {
        _tokenStack.add(token);
      } else if (token is LogicalStart) {
        _tokenStack.add(token);
      } else if (token is LogicalEnd) {
        while (_tokenStack.isNotEmpty && _tokenStack.last is! LogicalStart) {
          final filter = _tokenStack.removeLast();
          _currentFilters.add(filter);
        }

        final logicalStart = _tokenStack.removeLast() as LogicalStart;
        final operation = logicalStart.precedence;

        final tree = PostrestFilterTree(operation: operation);
        tree.addChildren(_currentFilters);

        _currentFilters.clear();
        _tokenStack.add(tree);
      }
    }

    if (_tokenStack.length > 1 || _tokenStack.first is PostrestFilterParams) {
      final tree = PostrestFilterTree(operation: PostrestFilterPrecedence.and);
      tree.addChildren(_tokenStack);
      _tokenStack.clear();
      _tokenStack.add(tree);
    }
  }

  void _cleanParsingCache() {
    _tokens.clear();
    _tokenStack.clear();
    _currentFilters.clear();
  }
}
