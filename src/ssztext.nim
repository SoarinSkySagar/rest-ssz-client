import std/[strutils, tables]
import stew/byteutils
import ssz_serialization

import types/containers

type
  NodeKind* = enum nkBytes, nkInt, nkBool, nkNone, nkList, nkObj
  Node* = ref object
    case kind*: NodeKind
    of nkBytes: bytes*: seq[byte]
    of nkInt:   num*: uint64
    of nkBool:  b*: bool
    of nkNone:  discard
    of nkList:  items*: seq[Node]
    of nkObj:   fields*: OrderedTable[string, Node]

  Block* = object
    typeName*: string
    node*: Node

proc parseValue(s: string, i: var int): Node {.gcsafe.}

proc skipSpace(s: string, i: var int) =
  while i < s.len and s[i] in {' ', '\t'}: inc i

proc parseScalar(s: string, i: var int): Node {.gcsafe.} =
  let start = i
  while i < s.len and s[i] notin {',', '}', ']'}: inc i
  let tok = s[start ..< i].strip()
  if tok.len == 0 or tok == "none":
    Node(kind: nkNone)
  elif tok == "true":
    Node(kind: nkBool, b: true)
  elif tok == "false":
    Node(kind: nkBool, b: false)
  elif tok.startsWith("0x"):
    var h = tok[2 .. ^1]
    if h.len mod 2 == 1: h = "0" & h
    Node(kind: nkBytes, bytes: (if h.len == 0: @[] else: hexToSeqByte(h)))
  else:
    Node(kind: nkInt, num: parseBiggestUInt(tok))

proc parseList(s: string, i: var int): Node {.gcsafe.} =
  result = Node(kind: nkList)
  inc i # consume '['
  skipSpace(s, i)
  if i < s.len and s[i] == ']':
    inc i
    return
  while i < s.len:
    result.items.add parseValue(s, i)
    skipSpace(s, i)
    if i < s.len and s[i] == ',':
      inc i
      skipSpace(s, i)
    elif i < s.len and s[i] == ']':
      inc i
      break
    else:
      break

proc parseObj(s: string, i: var int): Node {.gcsafe.} =
  result = Node(kind: nkObj, fields: initOrderedTable[string, Node]())
  inc i # consume '{'
  skipSpace(s, i)
  if i < s.len and s[i] == '}':
    inc i
    return
  while i < s.len:
    let keyStart = i
    while i < s.len and s[i] != ':': inc i
    let key = s[keyStart ..< i].strip()
    inc i # consume ':'
    skipSpace(s, i)
    result.fields[key] = parseValue(s, i)
    skipSpace(s, i)
    if i < s.len and s[i] == ',':
      inc i
      skipSpace(s, i)
    elif i < s.len and s[i] == '}':
      inc i
      break
    else:
      break

proc parseValue(s: string, i: var int): Node {.gcsafe.} =
  skipSpace(s, i)
  if i >= s.len: return Node(kind: nkNone)
  case s[i]
  of '{': parseObj(s, i)
  of '[': parseList(s, i)
  else:   parseScalar(s, i)

proc parseValue*(s: string): Node =
  var i = 0
  parseValue(s, i)

# ---------------------------------------------------------------------------
# Read input.txt into blocks
# ---------------------------------------------------------------------------

proc readBlocks*(path: string): seq[Block] =
  let content = readFile(path)
  var
    name = ""
    node: Node = nil
  for raw in content.splitLines():
    let line = raw.strip()
    if line.len == 0:
      if name.len > 0 and node != nil:
        result.add Block(typeName: name, node: node)
      name = ""
      node = nil
      continue
    if name.len == 0:
      name = line
      node = Node(kind: nkObj, fields: initOrderedTable[string, Node]())
    else:
      let c = line.find(':')
      if c < 0: continue
      let field = line[0 ..< c].strip()
      node.fields[field] = parseValue(line[c + 1 .. ^1])
  if name.len > 0 and node != nil:
    result.add Block(typeName: name, node: node)

proc assign*[T](node: Node, dst: var T)
proc assignList[T; n: static int](node: Node, dst: var List[T, n])

proc assign*[T](node: Node, dst: var T) =
  mixin add, len, asSeq, items
  when T is bool:
    dst = (node.kind == nkBool and node.b)
  elif T is SomeUnsignedInt:
    if node.kind == nkInt: dst = T(node.num)
  elif T is BitArray:
    if node.kind == nkBytes:
      for i in 0 ..< dst.bytes.len:
        dst.bytes[i] = (if i < node.bytes.len: node.bytes[i] else: 0'u8)
  elif T is ByteList:
    if node.kind == nkBytes:
      for b in node.bytes: discard dst.add(b)
  elif T is array:
    if node.kind == nkBytes:
      for i in 0 ..< dst.len:
        dst[i] = (if i < node.bytes.len: node.bytes[i] else: 0'u8)
  elif T is List:
    assignList(node, dst)
  elif T is object:
    if node.kind == nkObj:
      for name, val in fieldPairs(dst):
        let child = node.fields.getOrDefault(name)
        if child != nil:
          assign(child, val)
  else:
    discard

proc assignList[T; n: static int](node: Node, dst: var List[T, n]) =
  mixin add, len, items
  when n == 1:
    if node.kind != nkNone:
      var elem: T
      assign(node, elem)
      discard dst.add(elem)
  else:
    if node.kind == nkList:
      for item in node.items:
        var elem: T
        assign(item, elem)
        discard dst.add(elem)

proc fmt*[T](x: T): string
proc fmtList[T; n: static int](x: List[T, n]): string

proc fmt*[T](x: T): string =
  mixin asSeq, len, items
  when T is bool:
    (if x: "true" else: "false")
  elif T is SomeUnsignedInt:
    $x
  elif T is BitArray:
    "0x" & toHex(x.bytes)
  elif T is ByteList:
    "0x" & toHex(x.asSeq)
  elif T is array:
    "0x" & toHex(x)
  elif T is List:
    fmtList(x)
  elif T is object:
    var parts: seq[string]
    for name, val in fieldPairs(x):
      parts.add(name & ": " & fmt(val))
    "{" & parts.join(", ") & "}"
  else:
    "?"

proc fmtList[T; n: static int](x: List[T, n]): string =
  mixin asSeq
  let s = asSeq(x)
  when n == 1:
    (if s.len == 0: "none" else: fmt(s[0]))
  else:
    var parts: seq[string]
    for it in s: parts.add fmt(it)
    "[" & parts.join(", ") & "]"

proc fmtBlock*[T](typeName: string, x: T): string =
  result = typeName & "\n"
  for name, val in fieldPairs(x):
    result.add(name & ": " & fmt(val) & "\n")

proc openLog*(path: string): File =
  open(path, fmAppend)

proc logBlock*[T](f: File, typeName: string, value: T) =
  f.write(fmtBlock(typeName, value) & "\n")

proc logLine*(f: File, text: string) =
  f.write(text & "\n")
