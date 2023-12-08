import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/read_input.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day08', () {
    final day = Day08();

    setUpAllForDay(day);

    group('solvePart1', () {
      test('returns 2', () {
        expect(day.solvePart1(), 2);
      });

      test('returns 6', () {
        day.input.inputAsList = readInputAsLines('aoc08-2.txt');
        expect(day.solvePart1(), 6);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 0;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });
    });
  });
}
