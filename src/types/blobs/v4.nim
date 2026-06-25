import ../containers

type
    BlobsV4Request* = object
        versioned_hashes*: List[VersionedHash, MAX_BLOBS_REQUEST]
        indices_bitarray*: Bitvector[CELLS_PER_EXT_BLOB]

    BlobV4Entry* = object
        available*: Boolean
        contents*: BlobCellsAndProofs

    BlobsV4Response* = object
        entries*: List[BlobV4Entry, MAX_BLOBS_REQUEST]