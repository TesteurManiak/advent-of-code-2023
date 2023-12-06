import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<_TimeDistancePair> parseInput({
    bool debug = false,
    bool part2 = false,
  }) {
    final lines = input.getPerLine();
    final headerRegex = RegExp(r'^(Time|Distance):\s+');
    final numberRegex = RegExp(r'\d+');

    if (part2) {
      final time = numberRegex
          .allMatches(lines[0].replaceAll(headerRegex, ''))
          .map((e) => e.group(0)!)
          .join();
      final distance = numberRegex
          .allMatches(lines[1].replaceAll(headerRegex, ''))
          .map((e) => e.group(0)!)
          .join();
      return [(time: int.parse(time), distance: int.parse(distance))];
    }

    final times = numberRegex
        .allMatches(lines[0].replaceAll(headerRegex, ''))
        .map((e) => int.parse(e.group(0)!));
    final distances = numberRegex
        .allMatches(lines[1].replaceAll(headerRegex, ''))
        .map((e) => int.parse(e.group(0)!));

    final pairs = <_TimeDistancePair>[];
    for (int i = 0; i < times.length; i++) {
      pairs.add((time: times.elementAt(i), distance: distances.elementAt(i)));
    }

    return pairs;
  }

  @override
  int solvePart1() {
    final input = parseInput();

    int total = 1;
    for (final race in input) {
      int ways = 0;
      for (int hold = 1; hold < race.time; hold++) {
        final runDistance = calcDistance(hold, race.time);
        if (runDistance > race.distance) {
          ways++;
        }
      }
      total *= ways;
    }

    return total;
  }

  @override
  int solvePart2() {
    final input = parseInput(part2: true).first;

    int startingEdge = 1;
    for (int hold = 1; hold < input.time; hold++) {
      final runDistance = calcDistance(hold, input.time);
      if (runDistance > input.distance) {
        startingEdge = hold;
        break;
      }
    }

    int endingEdge = input.time - 1;
    for (int hold = input.time - 1; hold > 0; hold--) {
      final runDistance = calcDistance(hold, input.time);
      if (runDistance > input.distance) {
        endingEdge = hold;
        break;
      }
    }

    return endingEdge - startingEdge + 1;
  }

  int calcDistance(int hold, int time) => hold * (time - hold);
}

typedef _TimeDistancePair = ({int time, int distance});
