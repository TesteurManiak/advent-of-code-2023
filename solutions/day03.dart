import '../utils/index.dart';

typedef NumberRecord = ({int number, int x1, int x2, int y});
typedef NumbersRecord = ({
  String line,
  String map,
  List<NumberRecord> numbers,
  List<int> symbols
});
typedef SchematicRecord = ({
  List<NumbersRecord> parts,
  List<NumberRecord> numbers,
  Map<String, bool> symbols,
});

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<NumbersRecord> parseInput({bool debug = false, bool part2 = false}) {
    return input.getPerLine().indexed.map<NumbersRecord>((e) {
      final line = e.$2;
      final y = e.$1;
      final dotRegex = RegExp(r'\.');
      final nonDigitSpaceRegex = RegExp(r'[^\d\s]');
      final map =
          line.replaceAll(dotRegex, ' ').replaceAll(nonDigitSpaceRegex, 'X');

      final numberRegex = RegExp(r'(\d+)');
      final matches = numberRegex.allMatches(map);
      final numbers = matches.map<NumberRecord>((match) {
        final numStr = match.group(1)!;
        final number = int.parse(numStr);
        final x1 = match.start;
        final x2 = match.start + numStr.length - 1;

        return (number: number, x1: x1, x2: x2, y: y);
      }).toList();

      final symbolRegex = part2 ? RegExp(r'\*') : RegExp('X');
      final symbolMatches = symbolRegex.allMatches(map);
      final symbols = symbolMatches.map((match) => match.start).toList();

      return (line: line, map: map, numbers: numbers, symbols: symbols);
    }).toList();
  }

  SchematicRecord parseSchematic(List<NumbersRecord> parts) {
    final numbers = parts.expand((part) => part.numbers).toList();
    final symbols = <String, bool>{};

    for (int y = 0; y < parts.length; y++) {
      final part = parts[y];
      for (final x in part.symbols) {
        symbols['$x,$y'] = true;
      }
    }

    return (parts: parts, numbers: numbers, symbols: symbols);
  }

  bool numberAdjacentToSymbol(NumberRecord number, Map<String, bool> symbols) {
    final x1 = number.x1;
    final x2 = number.x2;
    final y = number.y;

    for (int dy = y - 1; dy <= y + 1; dy++) {
      for (int dx = x1 - 1; dx <= x2 + 1; dx++) {
        if (symbols['$dx,$dy'] ?? false) return true;
      }
    }
    return false;
  }

  Iterable<NumberRecord> findPartNumbers(
    List<NumberRecord> numbers,
    Map<String, bool> symbols,
  ) {
    return numbers.where((number) => numberAdjacentToSymbol(number, symbols));
  }

  @override
  int solvePart1() {
    final parts = parseInput();
    final schematic = parseSchematic(parts);
    final adjacentNumbers = findPartNumbers(
      schematic.numbers,
      schematic.symbols,
    );

    return adjacentNumbers.map((e) => e.number).sum;
  }

  @override
  int solvePart2() {
    final parts = parseInput(part2: true);
    final schematic = parseSchematic(parts);
    final adjacentNumbers = findPartNumbers(
      schematic.numbers,
      schematic.symbols,
    );
    return adjacentNumbers.map((e) => e.number).sum;
  }
}
