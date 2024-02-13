import 'package:supabase_flutter/src/testing/range_type.dart';

class RangeComparable<T> {
  RangeComparable({
    T? lowerRange,
    T? upperRange,
    required this.rangeType,
  })  : _lowerRange = Bound<T>(lowerRange),
        _upperRange = Bound<T>(upperRange);

  final RangeDataType rangeType;
  final Bound<T> _upperRange;
  final Bound<T> _lowerRange;

  T? get upperRange => _upperRange.bound;
  T? get lowerRange => _lowerRange.bound;
  bool get isUnbounded => _upperRange.isUnbounded && _lowerRange.isUnbounded;
  bool get isBounded => _upperRange.isBounded && _lowerRange.isBounded;
  bool get hasUnbounded => _upperRange.isUnbounded || _lowerRange.isUnbounded;

  bool isInRange(dynamic value) {
    try {
      late final Bound<T> bound;

      if (T == double && value is int) {
        final valueCast = double.parse(value.toString()) as T;
        bound = Bound<T>(valueCast);
      } else {
        bound = Bound<T>(value as T);
      }

      final isInLowerRange =
          _lowerRange.isUnbounded ? true : _lowerRange <= bound;
      final isInUpperRange =
          _upperRange.isUnbounded ? true : _upperRange >= bound;

      return isInLowerRange && isInUpperRange;
    } catch (err) {
      throw Exception('${value.runtimeType} is an unsupported type.');
    }
  }

  bool isAdjacent(RangeComparable<T> other) {
    // If any of the boundaries is null, even though they might logically be
    // adjacent, PostgreSQL adjacency operator does not treat adjacency between
    // unbounded ranges, therefore it always returns false
    if (isUnbounded || other.isUnbounded) {
      return false;
    }

    // If ranges overlap, they cannot be adjacent
    if (overlaps(other)) {
      return false;
    }

    late final Object amount;

    switch (rangeType) {
      case RangeDataType.integer:
      case RangeDataType.timestamp:
      case RangeDataType.timestamptz:
        // When the bound is integer, it will count as 1, when the bound is
        // DateTime it will count as 1 millisecond
        amount = 1;
        break;
      case RangeDataType.float:
        // When the bound is float, it will count as 0.1
        amount = 0.1;
        break;
      case RangeDataType.date:
        // Therefore here, we shall calculate milliseconds in a day
        amount = 24 * 60 * 60 * 1000;
        break;
    }

    return (_lowerRange - amount == Bound<T>(other.upperRange)) ||
        (_upperRange + amount == Bound<T>(other.lowerRange));
  }

  bool overlaps(RangeComparable<T> other) {
    if (isUnbounded || other.isUnbounded) {
      return true;
    }

    if (_lowerRange.isUnbounded) {
      return _upperRange > Bound<T>(other.lowerRange);
    }

    if (_upperRange.isUnbounded) {
      return _lowerRange < Bound<T>(other.lowerRange);
    }

    return _lowerRange <= Bound<T>(other.upperRange) &&
        _upperRange >= Bound<T>(other.lowerRange);
  }

  bool strictlyLeftOf(RangeComparable<T> other) {
    if (_upperRange.isBounded && other.lowerRange != null) {
      return _upperRange < Bound<T>(other.lowerRange);
    }

    return false;
  }

  bool strictlyRightOf(RangeComparable<T> other) {
    if (_lowerRange.isBounded && other.upperRange != null) {
      return _lowerRange > Bound<T>(other.upperRange);
    }

    return false;
  }

  bool doesNotExtendToTheLeftOf(RangeComparable<T> other) {
    if (isUnbounded) {
      if (other.isUnbounded) {
        return true;
      }

      if (other.hasUnbounded && other.upperRange != null) {
        return true;
      }
    }

    if (isBounded || (hasUnbounded && !isUnbounded)) {
      if (other.isUnbounded) {
        return true;
      }
    }

    if (hasUnbounded && lowerRange != null) {
      if (other.hasUnbounded && other.upperRange != null) {
        return true;
      }
    }

    if (_lowerRange.isBounded && other.lowerRange != null) {
      return _lowerRange >= Bound<T>(other.lowerRange);
    }

    return false;
  }

  bool doesNotExtendToTheRightOf(RangeComparable<T> other) {
    if (isUnbounded) {
      if (other.isUnbounded) {
        return true;
      }

      if (other.hasUnbounded && other.lowerRange != null) {
        return true;
      }
    }

    if (isBounded || (hasUnbounded && !isUnbounded)) {
      if (other.isUnbounded) {
        return true;
      }
    }

    if (hasUnbounded && lowerRange != null) {
      if (other.hasUnbounded && other.lowerRange != null) {
        return true;
      }
    }

    if (hasUnbounded && upperRange != null) {
      if (other.hasUnbounded && other.lowerRange != null) {
        return true;
      }
    }

    if (_upperRange.isBounded && other.upperRange != null) {
      return _upperRange <= Bound<T>(other.upperRange);
    }

    return false;
  }

  bool operator >(RangeComparable<T> other) => _gt(other);

  bool operator >=(RangeComparable<T> other) => _gt(other) || this == other;

  bool operator <(RangeComparable<T> other) => _lt(other);

  bool operator <=(RangeComparable<T> other) => _lt(other) || this == other;

  @override
  bool operator ==(Object other) =>
      other is RangeComparable &&
      _lowerRange == Bound<T>(other.lowerRange) &&
      _upperRange == Bound<T>(other.upperRange);

  @override
  int get hashCode => Object.hash(lowerRange, upperRange);

  bool _gt(RangeComparable<T> other) {
    if (rangeType != other.rangeType) {
      throw Exception(
        'Cannot compare two range types of different types',
      );
    }
    // According to the PostgreSQL behavior, when a [,] range is compared
    // against any other, it returns false. e.g.
    //
    // [,] > [5,15] -> false
    // [,] > [10,] -> false
    // [,] > [,] -> false
    //
    // The only exception is when a [,] range is compared against a [,n]
    // range, when the lower bound is not specified but only a upper bound
    // then PostgreSQL returns true. e.g.
    //
    // [,] > [,20] -> true
    //
    if (isUnbounded) {
      return other.hasUnbounded && other.upperRange != null;
    }

    // According to the PostgreSQL behavior, when any range that is not
    // completely unbounded is compared against any other [,] range, it
    // returns true. e.g.
    //
    // [3,] > [,] -> true
    // [3,20] > [,] -> true
    // [3,] > [,] -> true
    //
    // The only exception is when a [,n] range is compared against a [,]
    // range, when the lower bound is not specified but only a upper bound
    // then PostgreSQL returns true. e.g.
    //
    // [,7] > [,] -> false
    //
    if (other.isUnbounded) {
      return _lowerRange.isBounded;
    }

    // According to the PostgreSQL behavior, when any [,n] range
    // is compared against any other range, it returns false. e.g.
    //
    // [,7] > [2,6] -> false
    // [,7] > [2,] -> false
    // [,7] > [,] -> false
    //
    // The only exception is when a [,n] range is compared against a [,n]
    // range, when this happens, PostgreSQL actually performs the
    // operation. e.g.
    //
    // [,7] > [,6] -> true -- because 7 > 6
    // [,7] > [,7] -> false
    // [,7] > [,8] -> false
    //
    if (hasUnbounded && _upperRange.isBounded) {
      if (other.hasUnbounded && other.upperRange != null) {
        return _upperRange > Bound<T>(other.upperRange);
      }
      return false;
    }

    // According to the PostgreSQL behavior, when any [n,] is compared against
    // a [n,n] range, PostgreSQL will perform a greater than or equal to
    // operation on both lower bounds. e.g.
    //
    // [3,] > [2,15] -> true
    // [3,] > [3,15] -> true
    // [3,] > [4,15] -> false
    //
    if (hasUnbounded && _lowerRange.isBounded && other.isBounded) {
      return _lowerRange >= Bound<T>(other.lowerRange);
    }

    return _lowerRange == Bound<T>(other.lowerRange)
        ? _upperRange > Bound<T>(other.upperRange)
        : _lowerRange > Bound<T>(other.lowerRange);
  }

  bool _lt(RangeComparable other) {
    if (rangeType != other.rangeType) {
      throw Exception(
        'Cannot compare two range types of different types',
      );
    }

    // According to the PostgreSQL behavior, when a [,] range is compared
    // against any other [b,b] or [b,] range, it returns true. e.g.
    //
    // [,] < [5,15] -> true
    // [,] < [10,] -> true
    //
    // An exception is when a [,] range is compared against a [,b]
    // range, when the lower bound is not specified but only a upper bound,
    // or if ranges are equal, then PostgreSQL returns false. e.g.
    //
    // [,] < [,20] -> false
    // [,] < [,] -> false
    //

    if (isUnbounded) {
      if (other.isUnbounded) {
        return false;
      }

      if (other.hasUnbounded && other.upperRange != null) {
        return false;
      }

      return true;
    }

    // According to the PostgreSQL behavior, when a [b,] range is compared
    // against any other [,b] or [,] range, it returns false. e.g.
    //
    // [3,] < [,2] -> false
    // [3,] < [,3] -> false
    // [3,] < [,4] -> false
    // [3,] < [,] -> false
    //
    if (hasUnbounded && _lowerRange.isBounded) {
      // According to the PostgreSQL behavior, when a [b,] range is compared
      // against any other [b,] or [b,b] range, because they have a
      // lower bound specified, then PostgreSQL actually performs the operation,
      // comparing both lower bounds. e.g.
      //
      // [3,] < [2,15] -> false
      // [3,] < [3,15] -> false
      // [3,] < [4,15] -> true
      // [3,] < [2,] -> false
      // [3,] < [3,] -> false
      // [3,] < [4,] -> true
      //
      if (other.lowerRange != null) {
        return _lowerRange < Bound<T>(other.lowerRange);
      }
      return false;
    }

    // According to the PostgreSQL behavior, when a [,b] range is compared
    // against any other range, it returns true. e.g.
    //
    // [,7] < [4,6] -> true
    // [,7] < [4,7] -> true
    // [,7] < [4,8] -> true
    // [,7] < [6,20] -> true
    // [,7] < [7,20] -> true
    // [,7] < [8,20] -> true
    // [,7] < [6,] -> true
    // [,7] < [7,] -> true
    // [,7] < [8,] -> true
    // [,7] < [,] -> true
    //
    // The only exception is when it is compared against a [,b] range, when
    // the lower bound is unspecified and the upper bound is specified, then
    // PostgreSQL will actually perform the operation, comparing both upper
    // bound. e.g.
    //
    // [,7] < [,6] -> false
    // [,7] < [,7] -> false
    // [,7] < [,8] -> true
    //
    if (hasUnbounded && _upperRange.isBounded) {
      if (other.hasUnbounded && other.upperRange != null) {
        return _upperRange < Bound<T>(other.upperRange);
      }
      return true;
    }

    return _lowerRange == Bound<T>(other.lowerRange)
        ? _upperRange < Bound<T>(other.upperRange)
        : _lowerRange < Bound<T>(other.lowerRange);
  }
}

class Bound<T> {
  const Bound(this.bound);

  final T? bound;

  bool get isBounded => bound != null;
  bool get isUnbounded => bound == null;

  @override
  bool operator ==(Object other) {
    if (other is Bound<T>) {
      if (T == DateTime) {
        final thisCast = bound as DateTime?;
        final otherCast = other.bound as DateTime?;

        // If any of them are unbounded, then it will compare nullability
        // rather than DateTime values
        if (isUnbounded || other.isUnbounded) {
          return thisCast == otherCast;
        }

        return thisCast!.isAtSameMomentAs(otherCast!);
      }

      return bound == other.bound;
    }

    return false;
  }

  bool operator >(Bound<T> other) {
    if (this == other) {
      return false;
    }

    if (isUnbounded && other.isBounded) {
      return false;
    }

    if (isBounded && other.isUnbounded) {
      return true;
    }

    if (T == DateTime) {
      final thisCast = bound as DateTime?;
      final otherCast = other.bound as DateTime?;

      return thisCast!.isAfter(otherCast!);
    }

    return (bound as dynamic) > other.bound;
  }

  bool operator <(Bound<T> other) {
    if (this == other) {
      return false;
    }

    if (isUnbounded && other.isBounded) {
      return true;
    }

    if (isBounded && other.isUnbounded) {
      return false;
    }

    if (T == DateTime) {
      final thisCast = bound as DateTime?;
      final otherCast = other.bound as DateTime?;

      return thisCast!.isBefore(otherCast!);
    }

    return (bound as dynamic) < other.bound;
  }

  bool operator >=(Bound<T> other) => this > other || this == other;
  bool operator <=(Bound<T> other) => this < other || this == other;

  Bound<T> operator +(Object other) {
    if (bound == null) {
      return this;
    }

    if (T == DateTime) {
      final duration = Duration(milliseconds: other as int);
      final boundCast = bound as DateTime;

      return Bound<T>(boundCast.add(duration) as T);
    }

    return Bound<T>((bound as dynamic) + other);
  }

  Bound<T> operator -(Object other) {
    if (bound == null) {
      return this;
    }

    if (T == DateTime) {
      final duration = Duration(milliseconds: other as int);
      final boundCast = bound as DateTime;

      return Bound<T>(boundCast.subtract(duration) as T);
    }

    return Bound<T>((bound as dynamic) - other);
  }

  @override
  int get hashCode => Object.hashAll([bound]);
}
