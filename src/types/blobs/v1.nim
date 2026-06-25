import ../containers

type
    BlobAndProofV1* = object
        blob*: ByteVector[BYTES_PER_BLOB]
        proof*: Bytes48

    BlobsV1Request* = object
        versioned_hashes*: List[VersionedHash, MAX_BLOBS_REQUEST]

    BlobV1Entry* = object
        available*: Boolean
        contents*: BlobAndProofV1

    BlobsV1Response* = object
        entries*: List[BlobV1Entry, MAX_BLOBS_REQUEST]