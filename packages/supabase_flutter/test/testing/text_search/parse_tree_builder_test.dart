import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stemmer/SnowballStemmer.dart';
import 'package:supabase_flutter/src/testing/supabase_test_exceptions.dart';
import 'package:supabase_flutter/src/testing/text_search/parse_tree_builder.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search_parser.dart';
import 'package:supabase_flutter/src/testing/text_search/token_validator.dart';
import 'package:supabase_flutter/src/testing/text_search/ts_vector.dart';

void main() {
  late final List<String> Function(String query, TextSearchDictionary dict,
      {bool optimize}) parseExpression;

  late final TextSearchDictionary Function(
    String dictName,
  ) loadDict;

  late final TextSearchNode Function(
    String query,
    TextSearchDictionary dict,
  ) buildTree;

  setUpAll(() {
    parseExpression = (query, dict, {optimize = true}) {
      final parser = TextSearchParser();
      final optimizer = QueryOptimizer();
      final tokenValidator = TokenValidator();
      final stemmer = SnowballStemmer();

      final tokens = parser.parseExpression(query);
      final optimizedTokens =
          optimize ? optimizer.optimize(tokens, dict) : tokens;
      final validationResult = tokenValidator.validateTokens(optimizedTokens);

      if (!validationResult.isValid) {
        throw TextSearchException(validationResult.message!);
      }

      final stemmedTokens = tokens.map((e) => stemmer.stem(e)).toList();

      return stemmedTokens;
    };

    loadDict = (dictName) {
      final file = File(
        'lib/src/testing/text_search_data/$dictName.json',
      );
      if (!file.existsSync()) {
        throw Exception('Config file \'$dictName\' does not exist.');
      }

      final jsonString = file.readAsStringSync();
      return TextSearchDictionary.fromJson(jsonString);
    };

    buildTree = (query, dict) {
      final tokens = parseExpression(query, dict);
      final builder = ParseTreeBuilder();
      return builder.buildTree(tokens);
    };
  });

  group('parse tree general tests', () {
    test('should return true if the node is the root', () {
      final tree = buildTree('cat', loadDict('english'));
      expect(tree.isRootNode, true);
    });

    test('should return false if the node is not the root', () {
      final left = buildTree('cat & dog', loadDict('english')).left!;
      expect(left.isRootNode, false);
    });

    test('should return true if the node is a leaf node', () {
      final left = buildTree('cat & dog', loadDict('english')).left!;
      expect(left.isLeafNode, true);
    });

    test('should return false if the node is not a leaf node', () {
      final tree = buildTree('cat & dog', loadDict('english'));
      expect(tree.isLeafNode, false);
    });

    test('should set the left child', () {
      final treeUnset = OperatorNode(operation: TextSearchOperation.and);
      final treeSet = OperatorNode(operation: TextSearchOperation.and);
      treeSet.setLeft(OperandNode(value: 'cat'));

      expect(treeUnset.left, null);
      expect(treeSet.left, OperandNode(value: 'cat'));
    });

    test('should define the parent of left node as the node that set it', () {
      final treeSet = OperatorNode(operation: TextSearchOperation.and);
      treeSet.setLeft(OperandNode(value: 'cat'));

      expect(treeSet.left!.parent == treeSet, true);
    });

    test('should set the right child', () {
      final treeUnset = OperatorNode(operation: TextSearchOperation.and);
      final treeSet = OperatorNode(operation: TextSearchOperation.and);
      treeSet.setRight(OperandNode(value: 'dog'));

      expect(treeUnset.right, null);
      expect(treeSet.right, OperandNode(value: 'dog'));
    });

    test('should define the parent of right node as the node that set it', () {
      final treeSet = OperatorNode(operation: TextSearchOperation.and);
      treeSet.setRight(OperandNode(value: 'dog'));

      expect(treeSet.right!.parent == treeSet, true);
    });

    test('should return the root of the tree', () {
      final left = buildTree('cat & dog', loadDict('english')).left!;
      final root = TextSearchNode.traverseToRoot(left);
      expect(root.isRootNode, true);
    });
  });

  group('operand node tests', () {
    late final OperandNode Function(
      String operand,
      TextSearchDictionary dict,
    ) createOperand;

    setUpAll(() {
      createOperand = (operand, dict) {
        return buildTree(operand, dict) as OperandNode;
      };
    });

    test('should contain the operand value', () {
      final operand = createOperand('cat', loadDict('english'));
      expect(operand.value, 'cat');
    });

    test('should return true if term exists in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog'});
      final operand = createOperand('cat', loadDict('english'));

      expect(operand.evaluate(tsVector), true);
    });

    test('should return false if term does not exist in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog'});
      final operand = createOperand('cow', loadDict('english'));

      expect(operand.evaluate(tsVector), false);
    });
  });

  group('unary node tests', () {
    late final UnaryOperatorNode Function(
      String operand,
      TextSearchDictionary dict,
    ) createUnary;

    setUpAll(() {
      createUnary = (operand, dict) {
        return buildTree(operand, dict) as UnaryOperatorNode;
      };
    });

    test('should contain the child operator node on the right branch', () {
      final unary = createUnary('!cat', loadDict('english'));

      expect(unary.right, OperandNode(value: 'cat'));
    });

    test('should return true if term does not exist in the ts vector', () {
      final tsVector = TsVector({1: 'dog'});
      final unary = createUnary('!cat', loadDict('english'));

      expect(unary.evaluate(tsVector), true);
    });

    test('should return false if term exists in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog'});
      final unary = createUnary('!cat', loadDict('english'));

      expect(unary.evaluate(tsVector), false);
    });
  });

  group('operator node tests', () {
    late final OperatorNode Function(
      String expression,
      TextSearchDictionary dict,
    ) createOperator;

    setUpAll(() {
      createOperator = (expression, dict) {
        return buildTree(expression, dict) as OperatorNode;
      };
    });

    test('should contain both operands as children', () {
      final node = createOperator('cat & !dog', loadDict('english'));

      expect(node.left, OperandNode(value: 'cat'));
      expect(
        node.right,
        UnaryOperatorNode(
          operation: TextSearchOperation.not,
          operand: OperandNode(value: 'dog'),
        ),
      );
    });

    test('should return true if both terms exist in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog'});
      final node = createOperator('cat & dog', loadDict('english'));

      expect(node.evaluate(tsVector), true);
    });

    test(
        'should return false if at least one term does not exist in the ts vector',
        () {
      final tsVector = TsVector({0: 'cat'});
      final node = createOperator('cat & dog', loadDict('english'));

      expect(node.evaluate(tsVector), false);
    });

    test('should return true if at least one term exists in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog'});
      final node = createOperator('cat | cow', loadDict('english'));

      expect(node.evaluate(tsVector), true);
    });

    test('should return false if both terms does not exist in the ts vector',
        () {
      final tsVector = TsVector({0: 'cat', 1: 'dog'});
      final node = createOperator('lion | cow', loadDict('english'));

      expect(node.evaluate(tsVector), false);
    });

    test('should return true if terms are adjacent in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog', 2: 'cow'});
      final node = createOperator('cat <-> dog', loadDict('english'));

      expect(node.evaluate(tsVector), true);
    });

    test('should return false if terms  are not adjacent in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog', 2: 'cow'});
      final node = createOperator('cat <-> cow', loadDict('english'));

      expect(node.evaluate(tsVector), false);
    });

    test('should return true if terms are n terms apart in the ts vector', () {
      final tsVector = TsVector({0: 'cat', 1: 'dog', 2: 'cow'});
      final node = createOperator('cat <2> cow', loadDict('english'));

      expect(node.evaluate(tsVector), true);
    });

    test('should return false if terms are not n terms apart in the ts vector',
        () {
      final tsVector = TsVector({0: 'cat', 1: 'dog', 2: 'cow'});
      final node = createOperator('cat <2> dog', loadDict('english'));

      expect(node.evaluate(tsVector), false);
    });
  });

  group('parse tree builder tests', () {
    test('should be able to build a single operand', () {
      final tree = buildTree('cat', loadDict('english'));
      expect(tree, OperandNode(value: 'cat'));
    });

    test('should be able to build a single negated operand', () {
      final tree = buildTree('!cat', loadDict('english'));
      expect(
        tree,
        UnaryOperatorNode(
          operation: TextSearchOperation.not,
          operand: OperandNode(value: 'cat'),
        ),
      );
    });

    test('should be able to build a single negated subexpression', () {
      final tree = buildTree('!(cat & dog)', loadDict('english'));
      expect(
        tree,
        UnaryOperatorNode(
          operation: TextSearchOperation.not,
          operand: OperatorNode(
            operation: TextSearchOperation.and,
            left: OperandNode(value: 'cat'),
            right: OperandNode(value: 'dog'),
          ),
        ),
      );
    });

    test('should be able to build an AND operator', () {
      final tree = buildTree('cat & dog', loadDict('english'));
      expect(
        tree,
        OperatorNode(
          operation: TextSearchOperation.and,
          left: OperandNode(value: 'cat'),
          right: OperandNode(value: 'dog'),
        ),
      );
    });

    test('should be able to build an OR operator', () {
      final tree = buildTree('cat | dog', loadDict('english'));
      expect(
        tree,
        OperatorNode(
          operation: TextSearchOperation.or,
          left: OperandNode(value: 'cat'),
          right: OperandNode(value: 'dog'),
        ),
      );
    });

    test('should be able to build a PHRASE operator', () {
      final tree = buildTree('cat <-> dog', loadDict('english'));
      expect(
        tree,
        OperatorNode(
          operation: TextSearchOperation.phrase,
          distance: 1,
          left: OperandNode(value: 'cat'),
          right: OperandNode(value: 'dog'),
        ),
      );
    });

    test('should be able to build a PROXIMITY operator', () {
      final tree = buildTree('cat <2> dog', loadDict('english'));
      expect(
        tree,
        OperatorNode(
          operation: TextSearchOperation.proximity,
          distance: 2,
          left: OperandNode(value: 'cat'),
          right: OperandNode(value: 'dog'),
        ),
      );
    });

    test('should be able to have a subexpression as operand', () {
      final tree =
          buildTree('(cat & !tiger) | (dog & !lion)', loadDict('english'));
      expect(
        tree,
        OperatorNode(
          operation: TextSearchOperation.or,
          left: OperatorNode(
            operation: TextSearchOperation.and,
            left: OperandNode(value: 'cat'),
            right: UnaryOperatorNode(
              operation: TextSearchOperation.not,
              operand: OperandNode(value: 'tiger'),
            ),
          ),
          right: OperatorNode(
            operation: TextSearchOperation.and,
            left: OperandNode(value: 'dog'),
            right: UnaryOperatorNode(
              operation: TextSearchOperation.not,
              operand: OperandNode(value: 'lion'),
            ),
          ),
        ),
      );
    });
  });

  group('unoptimized query tests', () {
    late final TextSearchNode Function(
      String expression,
      TextSearchDictionary dict,
    ) buildUnomptimized;

    setUpAll(() {
      buildUnomptimized = (query, dict) {
        final tokens = parseExpression(query, dict, optimize: false);
        final builder = ParseTreeBuilder();
        return builder.buildTree(tokens);
      };
    });

    test(
        'should be able to create a tree without removing unnecessary parantheses',
        () {
      final tree = buildUnomptimized('cat & (dog)', loadDict('english'));

      expect(
        tree,
        OperatorNode(
          operation: TextSearchOperation.and,
          left: OperandNode(value: 'cat'),
          right: OperandNode(value: 'dog'),
        ),
      );
    });
  });
}
