import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day07', () {
    final day = Day07();

    setUpAllForDay(day);

    group('solvePart1', () {
      const expectedOutput = 6440;

      test('returns $expectedOutput', () {
        expect(day.solvePart1(), expectedOutput);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 5905;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });
    });
  });
}
