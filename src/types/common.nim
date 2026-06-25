import primitives

type
  Withdrawal* = object
    index*: Uint64
    validator_index*: Uint64
    address*: Address
    amount*: Uint64                 # gwei

  BlobsBundleV1* = object
    commitments*: List[Bytes48, MAX_BLOB_COMMITMENTS_PER_BLOCK]
    proofs*: List[Bytes48, MAX_BLOB_COMMITMENTS_PER_BLOCK]
    blobs*: List[ByteVector[BYTES_PER_BLOB], MAX_BLOB_COMMITMENTS_PER_BLOCK]

  BlobsBundleV2* = object
    commitments*: List[Bytes48, MAX_BLOB_COMMITMENTS_PER_BLOCK]
    proofs*: List[Bytes48, MAX_BLOB_COMMITMENTS_PER_BLOCK * CELLS_PER_EXT_BLOB]
    blobs*: List[ByteVector[BYTES_PER_BLOB], MAX_BLOB_COMMITMENTS_PER_BLOCK]
