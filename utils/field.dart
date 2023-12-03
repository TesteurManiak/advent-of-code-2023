import 'dart:math' as math;

import 'package:quiver/iterables.dart';

typedef VoidFieldCallback = void Function(Position pos);

/// A helper class for easier work with 2D data.
class Field<T> {
  Field(List<List<T>> field)
      : assert(field.isNotEmpty),
        assert(field[0].isNotEmpty),
        // creates a deep copy by value from given field to prevent unwarranted overrides
        field = List<List<T>>.generate(
          field.length,
          (y) => List<T>.generate(field[0].length, (x) => field[y][x]),
        ),
        height = field.length,
        width = field[0].length;

  final List<List<T>> field;
  late final int height;
  late final int width;

  /// Returns whether the given position is inside of this field.
  bool isOnField(Position position) =>
      position.x >= 0 &&
      position.y >= 0 &&
      position.x < width &&
      position.y < height;

  /// Returns the whole row with given row index.
  Iterable<T> getRow(int row) => field[row];

  /// Returns the whole column with given column index.
  Iterable<T> getColumn(int column) => field.map((row) => row[column]);

  /// Returns the minimum value in this field.
  T get minValue => min<T>(field.expand((element) => element))!;

  /// Returns the maximum value in this field.
  T get maxValue => max<T>(field.expand((element) => element))!;

  /// Returns an iterable of all positions where the given [predicate] is true.
  Iterable<Position> locationsWhere(bool Function(T element) predicate) sync* {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (predicate(field[y][x])) {
          yield (x: x, y: y);
        }
      }
    }
  }

  /// Executes the given callback for every position on this field.
  void forEach(VoidFieldCallback callback) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        callback((x: x, y: y));
      }
    }
  }

  /// Returns the number of occurances of given object in this field.
  int count(T searched) => field
      .expand((element) => element)
      .fold<int>(0, (acc, elem) => elem == searched ? acc + 1 : acc);

  /// Executes the given callback for all given positions.
  void forPositions(
    Iterable<Position> positions,
    VoidFieldCallback callback,
  ) {
    for (final position in positions) {
      callback(position);
    }
  }

  /// Returns all adjacent cells to the given position. This does `NOT` include
  /// diagonal neighbours.
  Iterable<Position> adjacent(int x, int y) {
    return <Position>{
      (x: x, y: y - 1),
      (x: x, y: y + 1),
      (x: x - 1, y: y),
      (x: x + 1, y: y),
    }..removeWhere(
        (pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height,
      );
  }

  /// Returns all positional neighbours of a point. This includes the adjacent
  /// `AND` diagonal neighbours.
  Iterable<Position> neighbours(int x, int y) {
    return <Position>{
      // positions are added in a circle, starting at the top middle
      (x: x, y: y - 1),
      (x: x + 1, y: y - 1),
      (x: x + 1, y: y),
      (x: x + 1, y: y + 1),
      (x: x, y: y + 1),
      (x: x - 1, y: y + 1),
      (x: x - 1, y: y),
      (x: x - 1, y: y - 1),
    }..removeWhere(
        (pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height,
      );
  }

  Iterable<Position> neighboursFromPosition(Position position) {
    return neighbours(position.x, position.y);
  }

  /// Returns a deep copy by value of this [Field].
  Field<T> copy() {
    final newField = List<List<T>>.generate(
      height,
      (y) => List<T>.generate(width, (x) => field[y][x]),
    );
    return Field<T>(newField);
  }

  @override
  String toString() {
    final sb = StringBuffer();
    for (final row in field) {
      for (final elem in row) {
        sb.write(elem.toString());
      }
      sb.write('\n');
    }
    return sb.toString();
  }

  T operator [](Position pos) => field[pos.y][pos.x];
  void operator []=(Position pos, T value) => field[pos.y][pos.x] = value;
}

/// Extension for [Field]s where [T] is of type [int].
extension IntegerField on Field<int> {
  /// Increments the values of Position `x` `y`.
  int increment(int x, int y) => this[(x: x, y: y)] += 1;

  /// Convenience method to create a Field from a single String, where the
  /// String is a "block" of integers.
  static Field<int> fromString(String string) {
    final lines = string
        .split('\n')
        .map((line) => line.trim().split('').map(int.parse).toList())
        .toList();
    return Field(lines);
  }
}

typedef Position = ({int x, int y});

extension PositionExt on Position {
  Position operator -(Position other) => (x: x - other.x, y: y - other.y);
  Position operator +(Position other) => (x: x + other.x, y: y + other.y);
}

typedef Segment = ({Position start, Position end});

extension SegmentExt on Segment {
  /// Return all the points between start and end.
  Set<Position> get points {
    final points = <Position>{};
    final xDiff = end.x - start.x;
    final yDiff = end.y - start.y;
    final xDir = xDiff.sign;
    final yDir = yDiff.sign;
    final xSteps = xDiff.abs();
    final ySteps = yDiff.abs();
    final steps = math.max(xSteps, ySteps);

    for (int i = 0; i <= steps; i++) {
      final x = start.x + (i * xDir * xSteps ~/ steps);
      final y = start.y + (i * yDir * ySteps ~/ steps);
      points.add((x: x, y: y));
    }
    return points;
  }
}
