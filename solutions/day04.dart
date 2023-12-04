import 'dart:math' as math;

import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Iterable<Day03Card> parseInput() sync* {
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

      yield (winningNumbers: winningNumbers, givenNumbers: givenNumbers);
    }
  }

  @override
  int solvePart1() {
    final cards = parseInput();
    int sum = 0;
    for (final card in cards) {
      final winningNumbers = card.winningNumbers;
      final givenNumbers = card.givenNumbers;
      final intersection = winningNumbers.intersection(givenNumbers);
      if (intersection.isNotEmpty) {
        sum += math.pow(2, intersection.length - 1).toInt();
      }
    }
    return sum;
  }

  @override
  int solvePart2() {
    final cards = parseInput();
    final obtainedScratchCards = <int, int>{};

    for (final (index, card) in cards.indexed) {
      // Default card count is 1, since we always get the first card.
      final cardCount = (obtainedScratchCards[index] ?? 0) + 1;
      obtainedScratchCards[index] = cardCount;

      final winningNumbers = card.winningNumbers;
      final givenNumbers = card.givenNumbers;
      final intersection = winningNumbers.intersection(givenNumbers);

      for (int nextIndex = 1;
          nextIndex < intersection.length + 1;
          nextIndex++) {
        // Check if nextIndex is not outside the bounds of the cards list.
        if (index + nextIndex >= cards.length) break;

        // Increment the card count of the next card.
        obtainedScratchCards[index + nextIndex] =
            (obtainedScratchCards[index + nextIndex] ?? 0) + cardCount;
      }
    }

    return obtainedScratchCards.values.sum;
  }
}

typedef Day03Card = ({Set<int> winningNumbers, Set<int> givenNumbers});
