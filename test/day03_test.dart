import 'package:test/test.dart';

import '../solutions/index.dart';
import 'utils/test_utils.dart';

void main() {
  group('Day03', () {
    final day = Day03();

    setUpAllForDay(day);

    group('solvePart1', () {
      const expectedOutput = 4361;

      test('returns $expectedOutput', () {
        expect(day.solvePart1(), expectedOutput);
      });
    });

    group('solvePart2', () {
      const expectedOutput = 467835;

      test('returns $expectedOutput', () {
        expect(day.solvePart2(), expectedOutput);
      });
    });
  });
}
