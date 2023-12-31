import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  _SeedMap parseInput({bool debug = false, bool part2 = false}) {
    final lines = input.getPerLine();

    final seeds =
        lines[0].replaceAll('seeds: ', '').split(' ').map(int.parse).toSet();

    final seedToSoil = <_SeedLine>[];
    final soilToFertilizer = <_SeedLine>[];
    final fertilizerToWater = <_SeedLine>[];
    final waterToLight = <_SeedLine>[];
    final lightToTemperature = <_SeedLine>[];
    final temperatureToHumidity = <_SeedLine>[];
    final humidityToLocation = <_SeedLine>[];

    for (int index = 1; index < lines.length; index++) {
      final line = lines[index];
      if (line.startsWith('seed-to-soil map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          seedToSoil.add(_SeedLine.parse(lines[nextIndex]));
        }
      } else if (line.startsWith('soil-to-fertilizer map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          soilToFertilizer.add(_SeedLine.parse(lines[nextIndex]));
        }
      } else if (line.startsWith('fertilizer-to-water map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          fertilizerToWater.add(_SeedLine.parse(lines[nextIndex]));
        }
      } else if (line.startsWith('water-to-light map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          waterToLight.add(_SeedLine.parse(lines[nextIndex]));
        }
      } else if (line.startsWith('light-to-temperature map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          lightToTemperature.add(_SeedLine.parse(lines[nextIndex]));
        }
      } else if (line.startsWith('temperature-to-humidity map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          temperatureToHumidity.add(_SeedLine.parse(lines[nextIndex]));
        }
      } else if (line.startsWith('humidity-to-location map:')) {
        for (int nextIndex = index + 1;
            nextIndex < lines.length && lines[nextIndex].isNotEmpty;
            nextIndex++) {
          humidityToLocation.add(_SeedLine.parse(lines[nextIndex]));
        }
      }
    }

    return _SeedMap(
      seeds: seeds,
      seedToSoilMap: seedToSoil,
      soilToFertilizerMap: soilToFertilizer,
      fertilizerToWaterMap: fertilizerToWater,
      waterToLightMap: waterToLight,
      lightToTemperatureMap: lightToTemperature,
      temperatureToHumidityMap: temperatureToHumidity,
      humidityToLocationMap: humidityToLocation,
    );
  }

  @override
  int solvePart1() {
    final parsedInput = parseInput();
    return parsedInput.seeds.map(parsedInput.seedToLocation).min;
  }

  @override
  int solvePart2() {
    final parsedInput = parseInput();
    final seedRanges = <({int startSeed, int endSeed})>[
      for (int i = 0; i < parsedInput.seeds.length; i += 2)
        (
          startSeed: parsedInput.seeds.elementAt(i),
          endSeed: parsedInput.seeds.elementAt(i) +
              parsedInput.seeds.elementAt(i + 1)
        ),
    ];

    int location = 0;
    while (true) {
      final seed = parsedInput.locationToSeed(location);
      if (seedRanges.any((e) => seed >= e.startSeed && seed < e.endSeed)) {
        return location;
      }
      location++;
    }
  }
}

class _SeedMap {
  _SeedMap({
    required this.seeds,
    required this.seedToSoilMap,
    required this.soilToFertilizerMap,
    required this.fertilizerToWaterMap,
    required this.waterToLightMap,
    required this.lightToTemperatureMap,
    required this.temperatureToHumidityMap,
    required this.humidityToLocationMap,
  });

  final Set<int> seeds;
  final List<_SeedLine> seedToSoilMap;
  final List<_SeedLine> soilToFertilizerMap;
  final List<_SeedLine> fertilizerToWaterMap;
  final List<_SeedLine> waterToLightMap;
  final List<_SeedLine> lightToTemperatureMap;
  final List<_SeedLine> temperatureToHumidityMap;
  final List<_SeedLine> humidityToLocationMap;

  int seedToLocation(int seed) {
    final soil = sourceToDest(seed, seedToSoilMap);
    final fertilizer = sourceToDest(soil, soilToFertilizerMap);
    final water = sourceToDest(fertilizer, fertilizerToWaterMap);
    final light = sourceToDest(water, waterToLightMap);
    final temperature = sourceToDest(light, lightToTemperatureMap);
    final humidity = sourceToDest(temperature, temperatureToHumidityMap);
    final location = sourceToDest(humidity, humidityToLocationMap);

    return location;
  }

  int locationToSeed(int location) {
    final humidity = destToSource(location, humidityToLocationMap);
    final temperature = destToSource(humidity, temperatureToHumidityMap);
    final light = destToSource(temperature, lightToTemperatureMap);
    final water = destToSource(light, waterToLightMap);
    final fertilizer = destToSource(water, fertilizerToWaterMap);
    final soil = destToSource(fertilizer, soilToFertilizerMap);
    final seed = destToSource(soil, seedToSoilMap);

    return seed;
  }

  int sourceToDest(int source, List<_SeedLine> destMap) {
    return destMap
            .firstWhereOrNull((e) => e.containsSource(source))
            ?.sourceToDest(source) ??
        source;
  }

  int destToSource(int dest, List<_SeedLine> sourceMap) {
    return sourceMap
            .firstWhereOrNull((e) => e.containsDest(dest))
            ?.destToSource(dest) ??
        dest;
  }
}

class _SeedLine {
  const _SeedLine({
    required this.destinationRangeStart,
    required this.sourceRangeStart,
    required this.rangeLength,
  });

  factory _SeedLine.parse(String line) {
    final parts = line.split(' ');
    return _SeedLine(
      destinationRangeStart: int.parse(parts[0]),
      sourceRangeStart: int.parse(parts[1]),
      rangeLength: int.parse(parts[2]),
    );
  }

  final int destinationRangeStart;
  final int sourceRangeStart;
  final int rangeLength;

  bool containsSource(int source) {
    return source >= sourceRangeStart &&
        source < sourceRangeStart + rangeLength;
  }

  int sourceToDest(int source) {
    return source - sourceRangeStart + destinationRangeStart;
  }

  bool containsDest(int dest) {
    return dest >= destinationRangeStart &&
        dest < destinationRangeStart + rangeLength;
  }

  int destToSource(int dest) {
    return dest - destinationRangeStart + sourceRangeStart;
  }
}
