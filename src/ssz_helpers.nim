{.push raises: [].}

import results
import presto/common
import ssz_serialization

export results
export ssz_serialization

func sszEncode*[T](value: T): seq[byte] =
  SSZ.encode(value)

func sszDecode*[T](t: typedesc[T], data: openArray[byte]): RestResult[T] =
  try:
    ok(SSZ.decode(data, T))
  except SerializationError:
    err("SSZ decoding failed")


func encodeBytes*[T](value: T, contentType: string): RestResult[seq[byte]] =
  ok(sszEncode(value))

func decodeBytes*[T](
    t: typedesc[T],
    value: openArray[byte],
    contentType: Opt[ContentTypeData]
  ): RestResult[T] =
  sszDecode(T, value)

func encodeString*(value: string): RestResult[string] =
  ok(value)

func encodeString*(value: uint64): RestResult[string] =
  ok($value)
