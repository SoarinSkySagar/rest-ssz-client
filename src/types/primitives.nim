import ssz_serialization/types
export List, ByteList, ByteVector, BitArray

const
  MAX_BYTES_PER_TX* = 1 shl 30                 # 2**30
  MAX_TXS_PER_PAYLOAD* = 1 shl 20              # 2**20
  MAX_WITHDRAWALS_PER_PAYLOAD* = 1 shl 4       # 2**4
  BYTES_PER_LOGS_BLOOM* = 256
  MAX_EXTRA_DATA_BYTES* = 1 shl 5              # 2**5
  MAX_BLOB_COMMITMENTS_PER_BLOCK* = 1 shl 12   # 2**12
  FIELD_ELEMENTS_PER_BLOB* = 4096
  BYTES_PER_FIELD_ELEMENT* = 32
  BYTES_PER_BLOB* = FIELD_ELEMENTS_PER_BLOB * BYTES_PER_FIELD_ELEMENT
  CELLS_PER_EXT_BLOB* = 128
  FIELD_ELEMENTS_PER_CELL* = 64
  BYTES_PER_CELL* = FIELD_ELEMENTS_PER_CELL * BYTES_PER_FIELD_ELEMENT
  MAX_BAL_BYTES* = MAX_BYTES_PER_TX
  MAX_EXECUTION_REQUESTS_PER_PAYLOAD* = 1 shl 8  # 2**8 
  MAX_BYTES_PER_EXECUTION_REQUEST* = MAX_BYTES_PER_TX
  MAX_VERSIONED_HASHES_PER_REQUEST* = 128
  MAX_BLOBS_REQUEST* = MAX_VERSIONED_HASHES_PER_REQUEST
  MAX_BODIES_REQUEST* = 1 shl 5                # 2**5 
  MAX_REQUEST_BODY_SIZE* = 1 shl 26            # 2**26
  MAX_ERROR_BYTES* = 1024
  MAX_CLIENT_CODE_LENGTH* = 2
  MAX_CLIENT_NAME_LENGTH* = 64
  MAX_CLIENT_VERSION_LENGTH* = 64
  MAX_CLIENT_VERSIONS* = 4
  MAX_CAPABILITY_NAME_LENGTH* = 64
  MAX_CAPABILITIES* = 64

type

  Optional*[T] = List[T, 1]

  Bitvector*[N: static int] = BitArray[N]

  Hash32* = ByteVector[32]
  Root* = ByteVector[32]
  Address* = ByteVector[20]
  Bloom* = ByteVector[256]
  VersionedHash* = ByteVector[32]
  Bytes4* = ByteVector[4]
  Bytes8* = ByteVector[8]
  Bytes32* = ByteVector[32]
  Bytes48* = ByteVector[48]
  Uint64* = uint64
  Uint256* = ByteVector[32]
  Boolean* = bool
  String* = ByteList[MAX_ERROR_BYTES]
