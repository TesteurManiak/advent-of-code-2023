import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/read_input.dart';

void main() {
  final day = Day01();

  test('day01 - part 1', () {
    day.input.inputAsList = readInputAsLines('aoc01.txt');
    final result = day.solvePart1();

    expect(result, 142);
  });

  test('day01 - part 2', () {
    day.input.inputAsList = readInputAsLines('aoc01-2.txt');
    final result = day.solvePart2();

    expect(result, 281);
  });
}
