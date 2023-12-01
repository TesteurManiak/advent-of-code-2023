import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  static const numberMap = <String, String>{
    'one': 'one1one',
    'two': 'two2two',
    'three': 'three3three',
    'four': 'four4four',
    'five': 'five5five',
    'six': 'six6six',
    'seven': 'seven7seven',
    'eight': 'eight8eight',
    'nine': 'nine9nine',
  };

  @override
  Iterable<int> parseInput({bool debug = false, bool part2 = false}) sync* {
    final lines = input.getPerLine();
    final regex = RegExp(r'(\d)');

    for (final line in lines) {
      String newLine = line;
      if (part2) {
        for (final entry in numberMap.entries) {
          newLine = newLine.replaceAll(entry.key, entry.value);
        }
      }

      final matches = regex.allMatches(newLine);
      final fullNum = '${matches.first.group(0)}${matches.last.group(0)}';
      final number = int.parse(fullNum);

      yield number;
    }
  }

  @override
  int solvePart1() => parseInput().sum;

  @override
  int solvePart2() => parseInput(part2: true).sum;
}
