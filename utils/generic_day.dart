import 'input_util.dart';

/// Provides the [InputUtil] for given day and a [printSolution] method to show
/// the puzzle solutions for given day.
abstract class GenericDay {
  GenericDay(this.day) : input = InputUtil(day);

  final int day;
  final InputUtil input;

  dynamic parseInput();
  dynamic solvePart1();
  dynamic solvePart2();

  void printSolutions({DayPart part = DayPart.all}) {
    print("-------------------------");
    print("         Day $day        ");
    if (part == DayPart.part1 || part == DayPart.all) {
      print("Solution for puzzle one: ${solvePart1()}");
    }
    if (part == DayPart.part2 || part == DayPart.all) {
      print("Solution for puzzle two: ${solvePart2()}");
    }
    print("\n");
  }
}

enum DayPart {
  part1('1'),
  part2('2'),
  all('all');

  const DayPart(this.value);

  final String value;

  static DayPart parse(String input) {
    return DayPart.values.firstWhere(
      (e) => e.value == input,
      orElse: () =>
          throw ArgumentError.value(input, 'input', 'Invalid day part'),
    );
  }
}
