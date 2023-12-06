import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  Map<int, _TimeDistancePair> parseInput({
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
      return {0: (time: int.parse(time), distance: int.parse(distance))};
    }

    final times = numberRegex
        .allMatches(lines[0].replaceAll(headerRegex, ''))
        .map((e) => int.parse(e.group(0)!));
    final distances = numberRegex
        .allMatches(lines[1].replaceAll(headerRegex, ''))
        .map((e) => int.parse(e.group(0)!));

    final map = <int, _TimeDistancePair>{};
    for (int i = 0; i < times.length; i++) {
      map[i] = (time: times.elementAt(i), distance: distances.elementAt(i));
    }

    return map;
  }

  @override
  int solvePart1() {
    final input = parseInput();

    int total = 1;
    for (final race in input.values) {
      // Find the number of ways you can complete the race's distance
      int ways = 0;
      for (int hold = 1; hold < race.time; hold++) {
        final remaningTime = race.time - hold;
        final runDistance = hold * remaningTime;
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
    final input = parseInput(part2: true).values.first;

    int startingEdge = 0;
    int endingEdge = input.time - 1;

    for (int hold = 1; hold < input.time; hold++) {
      final remaningTime = input.time - hold;
      final runDistance = hold * remaningTime;
      if (runDistance > input.distance) {
        startingEdge = hold;
        break;
      }
    }

    for (int hold = input.time - 1; hold > 0; hold--) {
      final remaningTime = input.time - hold;
      final runDistance = hold * remaningTime;
      if (runDistance > input.distance) {
        endingEdge = hold;
        break;
      }
    }

    return endingEdge - startingEdge + 1;
  }
}

typedef _TimeDistancePair = ({int time, int distance});
