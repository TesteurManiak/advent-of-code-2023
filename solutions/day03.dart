import '../utils/index.dart';

typedef Day03ParseRecord = ({Set<String> symbols, Field<String> map});
typedef _PositionRecord = ({Position start, Position end});

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  Day03ParseRecord parseInput({bool debug = false, bool part2 = false}) {
    final parsedInput = input.asString;
    final symbols = parsedInput
        .replaceAll('.', '')
        .replaceAll(RegExp(r'\d'), '')
        .replaceAll('\n', '')
        .split('')
        .toSet();
    final map = Field<String>(
      input.getPerLine().map((e) => e.split('')).toList(),
    );

    return (symbols: symbols, map: map);
  }

  Map<_PositionRecord, int> _buildNumberMap(Day03ParseRecord input) {
    final numberMap = <_PositionRecord, int>{};

    for (int i = 0; i < input.map.height; i++) {
      final row = input.map.getRow(i);
      for (final match in regex.allMatches(row.join())) {
        final start = (x: match.start, y: i);
        final end = (x: match.end - 1, y: i);
        numberMap[(start: start, end: end)] ??= int.parse(match.group(0)!);
      }
    }

    return numberMap;
  }

  static final regex = RegExp(r'\d+');

  @override
  int solvePart1() {
    final parts = parseInput();
    final partNumbers = <int>[];
    final numberMap = _buildNumberMap(parts);

    for (final entry in numberMap.entries) {
      if (parts.map.checkSymbol(entry.key.start, parts.symbols) ||
          parts.map.checkSymbol(entry.key.end, parts.symbols)) {
        partNumbers.add(entry.value);
      }
    }

    return partNumbers.sum;
  }

  @override
  int solvePart2() {
    final parts = parseInput(part2: true);
    final numberMap = _buildNumberMap(parts);
    final gears = <Position, Set<int>>{};

    for (final entry in numberMap.entries) {
      final gearStart = parts.map.getGearFromPosition(entry.key.start);
      final gearEnd = parts.map.getGearFromPosition(entry.key.end);

      if (gearStart != null) {
        gears[gearStart] ??= {};
        gears[gearStart]?.add(entry.value);
      }

      if (gearEnd != null) {
        gears[gearEnd] ??= {};
        gears[gearEnd]?.add(entry.value);
      }
    }

    return gears.entries
        .where((e) => e.value.length == 2)
        .map((e) => e.value.first * e.value.last)
        .sum;
  }
}

extension on Field<String> {
  bool checkSymbol(Position pos, Set<String> symbols) {
    return neighboursFromPosition(pos).any(
      (e) => symbols.contains(getValueAtPosition(e)),
    );
  }

  Position? getGearFromPosition(Position pos) {
    final neighbours = neighboursFromPosition(pos);
    for (final n in neighbours) {
      if (getValueAtPosition(n) == '*') return n;
    }
    return null;
  }
}
