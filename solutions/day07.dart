import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  Iterable<_Hand> parseInput({bool debug = false, bool part2 = false}) sync* {
    final lines = input.getPerLine();
    for (final line in lines) {
      final hand = <_CamelCard>[];
      final parts = line.split(' ');
      final bid = int.parse(parts.last);
      for (final card in parts.first.split('')) {
        hand.add(_CamelCard.parse(card, jAsJoker: part2));
      }
      yield (hand: hand, type: _HandType.parse(hand), bid: bid);
    }
  }

  @override
  int solvePart1() {
    final hands = parseInput().toList();
    return _calcTotal(hands);
  }

  @override
  int solvePart2() {
    final hands = parseInput(part2: true).toList();
    return _calcTotal(hands);
  }

  int _sortHand(_Hand a, _Hand b) {
    final typeDiff = b.type.index.compareTo(a.type.index);
    if (typeDiff != 0) return typeDiff;

    for (int i = 0; i < a.hand.length; i++) {
      final cardDiff = a.hand[i].value.compareTo(b.hand[i].value);
      if (cardDiff != 0) return cardDiff;
    }
    return 0;
  }

  int _calcTotal(List<_Hand> hands) {
    final sorted = hands..sort(_sortHand);
    int sum = 0;
    for (int i = 0; i < sorted.length; i++) {
      final rank = i + 1;
      sum += rank * sorted[i].bid;
    }
    return sum;
  }
}

typedef _Hand = ({List<_CamelCard> hand, _HandType type, int bid});

enum _HandType {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPair,
  onePair,
  highCard;

  factory _HandType.parse(List<_CamelCard> hand) {
    final counts = <int, int>{};
    for (final card in hand) {
      counts[card.value] = (counts[card.value] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value - a.value);
    final first = sorted.first;
    final second = sorted.length > 1 ? sorted[1] : null;

    final jokers = counts[_CamelCard.joker.value] ?? 0;
    switch (jokers) {
      // Five of a kind cases
      case 5:
      case 4:
      case 3 when second?.value == 2:
      case 2 when first.value == 3:
      case 1 when first.value == 4:
        return _HandType.fiveOfAKind;
      // Four of a kind cases
      case 3 when second?.value == 1:
      case 2 when first.value == 2 && first.key != _CamelCard.joker.value:
      case 2 when second?.value == 2 && second?.key != _CamelCard.joker.value:
      case 1 when first.value == 3:
        return _HandType.fourOfAKind;
      // Full house cases
      case 1
          when first.value == 3 &&
              second?.value == 1 &&
              second?.key != _CamelCard.joker.value:
      case 1 when first.value == 2 && second?.value == 2:
        return _HandType.fullHouse;
      // Three of a kind cases
      case 1 when first.value == 2:
      case 2 when second?.value == 1:
        return _HandType.threeOfAKind;
      // No two pair cases
      // One pair cases
      case 1 when first.value == 1 && first.key != _CamelCard.joker.value:
      case 1 when second?.value == 1 && second?.key != _CamelCard.joker.value:
        return _HandType.onePair;
    }

    switch (first.value) {
      case 5:
        return _HandType.fiveOfAKind;
      case 4:
        return _HandType.fourOfAKind;
      case 3 when second?.value == 2:
        return _HandType.fullHouse;
      case 3:
        return _HandType.threeOfAKind;
      case 2 when second?.value == 2:
        return _HandType.twoPair;
      case 2:
        return _HandType.onePair;
      default:
        return _HandType.highCard;
    }
  }

  int get value => _HandType.values.length - index;
}

enum _CamelCard {
  ace('A', 14),
  king('K', 13),
  queen('Q', 12),
  jack('J', 11),
  ten('T', 10),
  nine('9', 9),
  eight('8', 8),
  seven('7', 7),
  six('6', 6),
  five('5', 5),
  four('4', 4),
  three('3', 3),
  two('2', 2),
  joker('J', 1);

  const _CamelCard(this.string, this.value);

  factory _CamelCard.parse(String string, {bool jAsJoker = false}) {
    if (string == 'J' && jAsJoker) return _CamelCard.joker;
    return _CamelCard.values.firstWhere((e) => e.string == string);
  }

  final String string;
  final int value;
}
