import ../containers

type
    BlobAndProofV2* = object  # Osaka cell proofs
        blob*: ByteVector[BYTES_PER_BLOB]
        proofs*: List[Bytes48, CELLS_PER_EXT_BLOB]

    BlobsV2Request* = object
        versioned_hashes*: List[VersionedHash, MAX_BLOBS_REQUEST]

    BlobV2Entry* = object  # also reused verbatim by /v3
        available*: Boolean
        contents*: BlobAndProofV2

    BlobsV2Response* = object
        entries*: List[BlobV2Entry, MAX_BLOBS_REQUEST]