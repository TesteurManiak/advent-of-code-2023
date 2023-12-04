import 'dart:math' as math;

import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Iterable<Set<int>> parseInput() sync* {
    final lines = input.getPerLine();

    for (final line in lines) {
      final parts = line.split(': ')[1].split(' | ');
      final winningNumbers = parts[0]
          .split(' ')
          .where((e) => e.trim().isNotEmpty)
          .map(int.parse)
          .toSet();
      final givenNumbers = parts[1]
          .split(' ')
          .where((e) => e.trim().isNotEmpty)
          .map(int.parse)
          .toSet();

      yield winningNumbers.intersection(givenNumbers);
    }
  }

  @override
  int solvePart1() {
    final winningNumbers = parseInput();
    num sum = 0;
    for (final numbers in winningNumbers) {
      if (numbers.isNotEmpty) {
        sum += math.pow(2, numbers.length - 1);
      }
    }

    return sum.toInt();
  }

  @override
  int solvePart2() {
    final winningNumbers = parseInput().toList();
    final obtainedScratchCards = <int, int>{};
    int sum = 0;

    for (int index = 0; index < winningNumbers.length; index++) {
      final numbers = winningNumbers[index];
      // Default card count is 1, since we always get the first card.
      final cardCount = (obtainedScratchCards[index] ?? 0) + 1;
      sum += cardCount;

      final length =
          (index + numbers.length + 1).clamp(0, winningNumbers.length);

      for (int nextIndex = index + 1; nextIndex < length; nextIndex++) {
        // Increment the card count of the next card.
        obtainedScratchCards[nextIndex] =
            (obtainedScratchCards[nextIndex] ?? 0) + cardCount;
      }
    }

    return sum;
  }
}
