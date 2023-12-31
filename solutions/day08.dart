import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  _ParsingRecord parseInput({bool debug = false, bool part2 = false}) {
    final lines = input.getPerLine();
    final instructions = lines[0].split('').map(_Direction.parse).toList();

    final map = <String, _Node>{};
    for (int i = 2; i < lines.length; i++) {
      final line = lines[i];
      final parts = line.split(' = ');
      final key = parts[0];
      final nodeRegex = RegExp(r'\((\w+), (\w+)\)');
      final match = nodeRegex.firstMatch(parts[1]);
      final left = match!.group(1)!;
      final right = match.group(2)!;

      map[key] = _Node(left: left, right: right);
    }

    return (instructions: instructions, map: map);
  }

  @override
  int solvePart1() {
    final record = parseInput();
    int operationCount = 0;

    String key = 'AAA';
    while (key != 'ZZZ') {
      final node = record.map[key]!;
      final direction =
          record.instructions[operationCount % record.instructions.length];
      key = direction == _Direction.left ? node.left : node.right;
      operationCount++;
    }
    return operationCount;
  }

  @override
  int solvePart2() {
    final record = parseInput();
    final keys = record.map.keys.where((e) => e.endsWith('A')).toList();
    final allOperations = <BigInt>[];

    for (final key in keys) {
      int operationCount = 0;
      String currentNode = key;

      while (!currentNode.endsWith('Z')) {
        final direction =
            record.instructions[operationCount % record.instructions.length];
        currentNode = switch (direction) {
          _Direction.left => record.map[currentNode]!.left,
          _Direction.right => record.map[currentNode]!.right,
        };
        operationCount++;
      }
      allOperations.add(BigInt.from(operationCount));
    }

    BigInt sum = BigInt.from(1);
    for (final step in allOperations) {
      sum *= step ~/ sum.gcd(step);
    }
    return sum.toInt();
  }
}

typedef _ParsingRecord = ({List<_Direction> instructions, _NodeMap map});

typedef _NodeMap = Map<String, _Node>;

class _Node {
  const _Node({
    required this.left,
    required this.right,
  });

  final String left;
  final String right;

  @override
  String toString() => '($left, $right)';
}

enum _Direction {
  left('L'),
  right('R');

  const _Direction(this.value);

  factory _Direction.parse(String value) {
    return _Direction.values.firstWhere((e) => e.value == value);
  }

  final String value;
}
