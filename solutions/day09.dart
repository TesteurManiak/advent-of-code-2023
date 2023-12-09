import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  Iterable<List<int>> parseInput({
    bool debug = false,
    bool part2 = false,
  }) sync* {
    final lines = input.getPerLine();
    for (final line in lines) {
      final match = RegExp(r'(-?\d+)')
          .allMatches(line)
          .map((m) => int.parse(m.group(0)!))
          .toList();
      yield match;
    }
  }

  List<List<int>> _findExtrapolations(List<int> history) {
    final extrapolations = <List<int>>[history];
    int y = 0;
    while (y < extrapolations.length) {
      final currentLine = extrapolations[y];
      final differences = <int>[];
      for (int i = 1; i < currentLine.length; i++) {
        final diff = currentLine[i] - currentLine[i - 1];
        differences.add(diff);
      }
      extrapolations.add(differences);
      if (differences.every((e) => e == 0)) break;
      y++;
    }
    return extrapolations;
  }

  @override
  int solvePart1() {
    final histories = parseInput().toList();
    int sum = 0;

    for (final history in histories) {
      final extrapolations = _findExtrapolations(history);
      extrapolations.last.add(0);
      for (int i = extrapolations.length - 2; i >= 0; i--) {
        final previousLine = extrapolations[i + 1];
        final currentLine = extrapolations[i];
        currentLine.add(currentLine.last + previousLine.last);
      }
      sum += extrapolations.first.last;
    }
    return sum;
  }

  @override
  int solvePart2() {
    final histories = parseInput().toList();
    int sum = 0;

    for (final history in histories) {
      final extrapolations = _findExtrapolations(history);
      for (int i = extrapolations.length - 2; i >= 0; i--) {
        final previousLine = extrapolations[i + 1];
        final currentLine = extrapolations[i];
        currentLine.insert(0, currentLine.first - previousLine.first);
      }
      sum += extrapolations.first.first;
    }
    return sum;
  }
}
