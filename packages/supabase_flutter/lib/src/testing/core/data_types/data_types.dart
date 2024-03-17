abstract class DataType implements Comparable<Object> {
  // Unary operators
  DataType operator -();

  // Arithmetic operators
  DataType operator +(Object other);
  DataType operator -(Object other);
  DataType operator *(Object other);
  DataType operator /(Object other);
  DataType operator ~/(Object other);
  DataType operator %(Object other);

  // relational operators
  bool operator >(Object other);
  bool operator <(Object other);
  bool operator >=(Object other);
  bool operator <=(Object other);

  // Bitwise and shift operators
  DataType operator &(Object other);
  DataType operator |(Object other);
  DataType operator ^(Object other);
  DataType operator <<(Object other);
  DataType operator >>(Object other);
  DataType operator >>>(Object other);

  // Indexing operators
  DataType operator [](int index);
  void operator []=(int index, Object value);

  // Equality operator
  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

abstract class FractionalDataType extends DataType {}
