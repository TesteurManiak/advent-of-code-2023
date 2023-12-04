import 'dart:math' as math;

import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<_Game> parseInput({bool debug = false, bool part2 = false}) {
    final lines = input.getPerLine();
    return lines.map(_Game.fromLine).toList();
  }

  @override
  int solvePart1() {
    final games = parseInput();
    const maxRed = 12;
    const maxGreen = 13;
    const maxBlue = 14;
    return games
        .where(
          (g) =>
              g.maxRed <= maxRed &&
              g.maxGreen <= maxGreen &&
              g.maxBlue <= maxBlue,
        )
        .map((g) => g.id)
        .sum;
  }

  @override
  int solvePart2() {
    final games = parseInput();
    return games.map((g) => g.power).sum;
  }
}

class _Game {
  const _Game({
    required this.id,
    required this.maxBlue,
    required this.maxRed,
    required this.maxGreen,
  });

  factory _Game.fromLine(String line) {
    final parts = line.split(': ');
    final id = int.parse(parts[0].replaceFirst('Game ', ''));
    final subsets = parts[1].split('; ');

    int maxBlue = 0;
    int maxRed = 0;
    int maxGreen = 0;

    for (final subset in subsets) {
      final sets = subset.split(', ');
      for (final set in sets) {
        final parsedSet = set.split(' ');
        final value = int.parse(parsedSet[0]);
        final color = parsedSet[1];
        switch (color) {
          case 'blue':
            maxBlue = math.max(maxBlue, value);
          case 'red':
            maxRed = math.max(maxRed, value);
          case 'green':
            maxGreen = math.max(maxGreen, value);
        }
      }
    }

    return _Game(
      id: id,
      maxBlue: maxBlue,
      maxRed: maxRed,
      maxGreen: maxGreen,
    );
  }

  final int id;
  final int maxBlue;
  final int maxRed;
  final int maxGreen;

  int get power => maxBlue * maxRed * maxGreen;
}
