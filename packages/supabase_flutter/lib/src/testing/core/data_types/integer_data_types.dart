import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';

abstract class IntegerDataType extends DataType {
  IntegerDataType(int intValue) {
    value = _clamp(intValue);
  }
  late final int value;

  int get _maxValue;
  int get _minValue;

  int _clamp(int value) {
    if (value < _minValue) {
      return _minValue;
    } else if (value > _maxValue) {
      return _maxValue;
    }
    return value;
  }

  int _safeAdd(int a, int b) {
    if (a > 0 && b > _maxValue - a) {
      // Addition would overflow
      return _maxValue;
    } else if (a < 0 && b < _minValue - a) {
      // Addition would underflow
      return _minValue;
    }

    return a + b;
  }

  int _safeSubtract(int a, int b) {
    if (a < 0 && b > 0 && a < _minValue + b) {
      // Subtraction would underflow
      return _minValue;
    } else if (a > 0 && b < 0 && a > _maxValue + b) {
      // Subtraction would overflow
      return _maxValue;
    }

    return a - b;
  }

  int _safeMultiply(int a, int b) {
    if (a == 0 || b == 0) {
      return 0;
    } else if (a == _minValue || b == _minValue) {
      // Multiplying by the minimum value could cause overflow
      return _minValue;
    } else {
      final signA = a.sign;
      final signB = b.sign;
      a = a.abs();
      b = b.abs();

      // Use division to check for overflow before performing the multiplication
      if (a > _maxValue ~/ b) {
        return signA == signB ? _maxValue : _minValue;
      }
    }

    return a * b;
  }

  int _safeDivide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Division by zero is not allowed.');
    }

    return _clamp(a ~/ b);
  }

  int _safeModulo(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Modulo by zero is not allowed.');
    }

    return _clamp(a % b);
  }

  int _safeLeftShift(int a, int shift) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    int shiftedValue = a;
    for (int i = 0; i < shift; i++) {
      if (shiftedValue > _maxValue >> 1 || shiftedValue < _minValue >> 1) {
        // If shifting would cause overflow, clamp to max or min value
        shiftedValue = shiftedValue > 0 ? _maxValue : _minValue;
        break;
      }
      shiftedValue = shiftedValue << 1;
    }

    return _clamp(shiftedValue);
  }

  int _safeRightShift(int a, int shift) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    return _clamp(a >> shift);
  }

  int _safeUnsignedRightShift(int a, int shift) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    // Treating the number as if it were unsigned for the shift
    // unsigned right shift '>>>' fills in zeros on the left
    return _clamp((a & 0xFFFFFFFFFFFFFFFF) >>> shift);
  }
}

class BigInteger extends IntegerDataType {
  BigInteger(super.intValue);

  // Max and min are one digit less than the representable amount
  // in 64-bit machines, the representable amounts are:
  //
  // Posititive: 9223372036854775807
  // Negative: -9223372036854775808
  //
  // This is to be on the safe side and avoid overflowing the value,
  // as well as dart static analyzer won't allow a value bigger than
  // that, so it needs to be a digit less so we can test it without
  // major problems.
  static const int maxValue = 9223372036854775806;
  static const int minValue = -9223372036854775807;

  @override
  int get _maxValue => maxValue;

  @override
  int get _minValue => minValue;

  @override
  int compareTo(Object other) {
    if (other is int) {
      return value.compareTo(other);
    } else if (other is IntegerDataType) {
      return value.compareTo(other.value);
    } else {
      throw ArgumentError(
        'Comparison is only supported with BigInteger or int types.',
      );
    }
  }

  // Unary operators
  @override
  BigInteger operator -() {
    if (value == minValue) {
      return BigInteger(maxValue);
    }
    return BigInteger(-value);
  }

  // Arithmetic operators
  @override
  BigInteger operator +(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeAdd(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeAdd(value, other));
    }
    throw ArgumentError(
      'Addition is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator -(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeSubtract(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeSubtract(value, other));
    }
    throw ArgumentError(
      'Subtraction is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator *(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeMultiply(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeMultiply(value, other));
    }

    throw ArgumentError(
      'Multiplication is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator /(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeDivide(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeDivide(value, other));
    }

    throw ArgumentError(
      'Division is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator ~/(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeDivide(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeDivide(value, other));
    }

    throw ArgumentError(
      'Whole division is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator %(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeModulo(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeModulo(value, other));
    }

    throw ArgumentError(
      'Modulo is only supported with BigInteger or int types.',
    );
  }

  // Relational operators
  @override
  bool operator <(Object other) => compareTo(other) < 0;

  @override
  bool operator >(Object other) => compareTo(other) > 0;

  @override
  bool operator <=(Object other) => compareTo(other) <= 0;

  @override
  bool operator >=(Object other) => compareTo(other) >= 0;

  // Shift and bitwise operators
  @override
  BigInteger operator &(Object other) {
    if (other is BigInteger) {
      return BigInteger(value & other.value);
    } else if (other is int) {
      return BigInteger(value & other);
    }
    throw ArgumentError(
      'Bitwise AND is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator ^(Object other) {
    if (other is BigInteger) {
      return BigInteger(value ^ other.value);
    } else if (other is int) {
      return BigInteger(value ^ other);
    }
    throw ArgumentError(
      'Bitwise XOR is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator |(Object other) {
    if (other is BigInteger) {
      return BigInteger(value | other.value);
    } else if (other is int) {
      return BigInteger(value | other);
    }
    throw ArgumentError(
      'Bitwise OR is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator <<(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeLeftShift(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeLeftShift(value, other));
    }
    throw ArgumentError(
      'Left shift is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator >>(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeRightShift(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeRightShift(value, other));
    }
    throw ArgumentError(
      'Right shift is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator >>>(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeUnsignedRightShift(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeUnsignedRightShift(value, other));
    }
    throw ArgumentError(
      'Unsigned right shift is only supported with BigInteger or int types.',
    );
  }

  // Indexing operators
  @override
  DataType operator [](int index) {
    throw UnsupportedError('Index operator is unsupported by BigInteger');
  }

  @override
  void operator []=(int index, Object value) {
    throw UnsupportedError('Index assignment is unsupported by BigInteger');
  }

  @override
  bool operator ==(Object other) {
    if (other is BigInteger) {
      return value == other.value;
    } else if (other is int) {
      return value == other;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;
}
