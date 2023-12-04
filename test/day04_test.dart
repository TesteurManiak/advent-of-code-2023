import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day04', () {
    final day = Day04();

    setUpAllForDay(day);

    group('solvePart1', () {
      const expectedOutput = 13;

      test('returns $expectedOutput', () {
        expect(day.solvePart1(), expectedOutput);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 30;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });
    });
  });
}
