import 'package:supabase_flutter/src/testing/supabase_test_exceptions.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/text_search/ts_vector.dart';

class ParseTreeBuilder {
  final List<TextSearchNode> _operandStack = [];
  final List<TextSearchOperation> _operatorStack = [];
  final List<int?> _distanceStack = [];
  final List<bool> _negationStack = [];
  bool _foundNotOperator = false;
  String? _errorMessage;

  TextSearchNode buildTree(List<String> tokens) {
    final result = _buildTree(tokens);
    _cleanState();

    if (result.hasError) {
      throw TextSearchException(result.errorMessage!);
    }

    return result.parseTree!;
  }

  _ParseTreeResult _buildTree(List<String> tokens) {
    for (final token in tokens) {
      final tokenOperation = TextSearchOperation.fromStringToOperation(token);

      if (_errorMessage != null) {
        return _ParseTreeResult(hasError: true, errorMessage: _errorMessage);
      }

      if (token == '!') {
        _handleUnaryOperator();
        continue;
      } else if (token == '(') {
        _handleOpeningParenthesis(tokenOperation!);
      } else if (token.contains(':')) {
        _handlePrefix(token);
      } else if (_isOperand(token)) {
        _handleOperand(token);
        continue;
      } else if (_isOperator(token)) {
        _handleOperator(token, tokenOperation!);
        continue;
      } else if (token == ')') {
        _handleClosingParenthesis();
      }
    }

    while (_operatorStack.isNotEmpty) {
      _createOperatorNode();
    }

    return _ParseTreeResult(hasError: false, parseTree: _operandStack.last);
  }

  void _createOperatorNode() {
    final rightOperand = _operandStack.removeLast();
    final operation = _operatorStack.removeLast();
    final leftOperand = _operandStack.removeLast();
    final distance = _distanceStack.removeLast();
    _operandStack.add(
      OperatorNode(
        operation: operation,
        distance: distance,
        left: leftOperand,
        right: rightOperand,
      ),
    );
  }

  void _createUnaryOperator(TextSearchNode operand) {
    _operandStack.add(
      UnaryOperatorNode(
        operation: TextSearchOperation.not,
        operand: operand,
      ),
    );
  }

  void _handlePrefix(String token) {
    if (_operandStack.isNotEmpty && _operandStack.last is OperandNode) {
      final operand = _operandStack.removeLast() as OperandNode;
      final isPrefix = token.contains('*');
      final labelsString = isPrefix ? token.substring(2) : token.substring(1);
      final labels = stringToWeightLabels(labelsString);

      final newOperand = OperandNode(
        value: operand.value,
        left: operand.left,
        right: operand.right,
        parent: operand.parent,
        isPrefix: isPrefix,
        weightLabels: labels,
      );

      _operandStack.add(newOperand);
    }
  }

  void _handleUnaryOperator() {
    _foundNotOperator = true;
  }

  void _handleOpeningParenthesis(TextSearchOperation operation) {
    if (_foundNotOperator) {
      _negationStack.add(true);
      _foundNotOperator = false;
    }
    _operatorStack.add(operation);
  }

  void _handleClosingParenthesis() {
    if (_foundNotOperator) {
      _setError('Invalid use of not operator');
    }

    while (_subExpressionHasNodes()) {
      _createOperatorNode();
    }
    if (_operatorStack.isEmpty) {
      _setError('Mismatched parentheses found.');
      return;
    }

    // Pop the '('
    _operatorStack.removeLast();
    if (_negationStack.isNotEmpty) {
      final subExpression = _operandStack.removeLast();
      _createUnaryOperator(subExpression);
      _negationStack.removeLast();
    }
  }

  void _handleOperand(String operand) {
    if (_foundNotOperator) {
      _operatorStack.add(TextSearchOperation.not);
      _foundNotOperator = false;
    }

    final operandNode = OperandNode(value: operand);

    if (_operatorStack.isNotEmpty &&
        _operatorStack.last == TextSearchOperation.not) {
      _operatorStack.removeLast();
      _createUnaryOperator(operandNode);
    } else {
      _operandStack.add(operandNode);
    }
  }

  void _handleOperator(String token, TextSearchOperation operation) {
    if (operation != TextSearchOperation.subExpression && _foundNotOperator) {
      _setError('Invalid use of not operator.');
    }

    while (_subExpressionHasNodes() &&
        _hasHigherPrecedence(_operatorStack.last, operation)) {
      _createOperatorNode();
    }
    _operatorStack.add(operation);

    if (!_isUnary(operation)) {
      final distance = _getOperatorDistance(token);
      _distanceStack.add(distance);
    }
  }

  List<WeightLabels> stringToWeightLabels(String labelsString) {
    final List<WeightLabels> labels = [];

    for (String char in labelsString.split('')) {
      if (char == 'a') {
        labels.add(WeightLabels.a);
      } else if (char == 'b') {
        labels.add(WeightLabels.b);
      } else if (char == 'c') {
        labels.add(WeightLabels.c);
      } else if (char == 'd') {
        labels.add(WeightLabels.d);
      }
    }

    return labels;
  }

  bool _isUnary(TextSearchOperation operation) =>
      operation == TextSearchOperation.not;

  bool _subExpressionHasNodes() =>
      _operatorStack.isNotEmpty &&
      _operatorStack.last != TextSearchOperation.subExpression;

  bool _hasHigherPrecedence(
          TextSearchOperation operator1, TextSearchOperation operator2) =>
      operator1.precedence > operator2.precedence;

  bool _isOperand(String token) => !_isOperator(token) && token != ')';

  bool _isOperator(String token) {
    for (final value in TextSearchOperation.values) {
      final regex = value.toOperatorRegex();
      if (regex.hasMatch(token)) {
        return true;
      }
    }

    return false;
  }

  int? _getOperatorDistance(String token) {
    final proximity = TextSearchOperation.proximity.toOperatorRegex();
    final phrase = TextSearchOperation.phrase.toOperatorRegex();

    if (proximity.hasMatch(token)) {
      final match = proximity.firstMatch(token);
      return int.parse(match!.group(1)!);
    } else if (phrase.hasMatch(token)) {
      return 1;
    }

    return null;
  }

  void _setError(String errorMessage) {
    _errorMessage = errorMessage;
  }

  void _cleanState() {
    _operandStack.clear();
    _operatorStack.clear();
    _negationStack.clear();
    _distanceStack.clear();

    _foundNotOperator = false;
  }
}

abstract class TextSearchNode {
  TextSearchNode? left;
  TextSearchNode? right;
  TextSearchNode? parent;

  TextSearchNode({
    this.left,
    this.right,
    this.parent,
  }) {
    left?.parent = this;
    right?.parent = this;
  }

  bool get isLeafNode => left == null && right == null;
  bool get isRootNode => parent == null;

  void setLeft(TextSearchNode? child) {
    left = child;
    child?.parent = this;
  }

  void setRight(TextSearchNode? child) {
    right = child;
    child?.parent = this;
  }

  @override
  String toString() => _buildString(this, 0);

  String _buildString(TextSearchNode? node, int depth) {
    if (node == null) return '';

    // Indentation for each level
    final indent = ' ' * depth * 2;
    final nodeString = '$indent${node.runtimeType}: ${node.nodeToString()}\n';

    final leftString = _buildString(node.left, depth + 1);
    final rightString = _buildString(node.right, depth + 1);

    return nodeString + leftString + rightString;
  }

  // Abstract method for node-specific string representation
  String nodeToString();

  // Abstract method for evaluating the node
  bool evaluate(TsVector tsVector);

  static TextSearchNode traverseToRoot(TextSearchNode leafNode) {
    TextSearchNode currentNode = leafNode;
    while (currentNode.parent != null) {
      currentNode = currentNode.parent!;
    }
    return currentNode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is TextSearchNode &&
        other.left == left &&
        other.right == right;
  }

  @override
  int get hashCode => Object.hash(runtimeType, left, right);
}

class OperandNode extends TextSearchNode {
  final String value;
  final bool isPrefix;
  final List<WeightLabels> labels;

  OperandNode({
    required this.value,
    this.isPrefix = false,
    List<WeightLabels>? weightLabels,
    super.left,
    super.right,
    super.parent,
  }) : labels = List.from(weightLabels ?? []);

  @override
  bool evaluate(TsVector tsVector) {
    // Return the value from the tsvector for this term
    final result = isPrefix
        ? tsVector.hasPrefix(
            value,
            labels: labels,
          )
        : tsVector.hasTerm(
            value,
            labels: labels,
          );
    return result;
  }

  @override
  String nodeToString() => 'Operand: $value';

  @override
  bool operator ==(Object other) =>
      other is OperandNode && other.value == value && super == other;

  @override
  int get hashCode => Object.hash(value, super.hashCode);
}

class OperatorNode extends TextSearchNode {
  final TextSearchOperation operation;
  final int? distance;

  OperatorNode({
    required this.operation,
    this.distance,
    super.left,
    super.right,
    super.parent,
  });

  @override
  bool evaluate(TsVector tsVector) {
    bool leftValue = left?.evaluate(tsVector) ?? false;
    bool rightValue = right?.evaluate(tsVector) ?? false;

    switch (operation) {
      case TextSearchOperation.and:
        return leftValue && rightValue;
      case TextSearchOperation.or:
        return leftValue || rightValue;
      case TextSearchOperation.phrase:
      case TextSearchOperation.proximity:
        if (left is OperandNode && right is OperandNode) {
          if (left == null || right == null) {
            return false;
          }
          final leftOperand = left as OperandNode;
          final rightOperand = right as OperandNode;
          final operandDistance = tsVector.getDistance(
            leftOperand.value,
            rightOperand.value,
          );

          return operandDistance == distance;
        }

        return leftValue && rightValue;
      default:
        return false;
    }
  }

  @override
  String nodeToString() => 'Operator: $operation (distance: $distance)';

  @override
  bool operator ==(Object other) =>
      other is OperatorNode &&
      other.operation == operation &&
      other.distance == distance &&
      super == other;

  @override
  int get hashCode => Object.hash(operation, distance, super.hashCode);
}

class UnaryOperatorNode extends TextSearchNode {
  final TextSearchOperation operation;

  UnaryOperatorNode({
    required this.operation,
    required TextSearchNode operand,
  }) {
    setRight(operand);
  }

  @override
  bool evaluate(TsVector tsVector) {
    bool operandValue = right?.evaluate(tsVector) ?? false;

    switch (operation) {
      case TextSearchOperation.not:
        return !operandValue;
      default:
        return false;
    }
  }

  @override
  String nodeToString() => 'UnaryOperator: $operation';

  @override
  bool operator ==(Object other) =>
      other is UnaryOperatorNode &&
      other.operation == operation &&
      super == other;

  @override
  int get hashCode => Object.hash(operation, super.hashCode);
}

class _ParseTreeResult {
  final TextSearchNode? parseTree;
  final bool hasError;
  final String? errorMessage;

  const _ParseTreeResult({
    required this.hasError,
    this.parseTree,
    this.errorMessage,
  });
}
