import ../containers
import v2

type
    BlobsV3Response* = object  # reuses BlobV2Entry; no separate BlobV3Entry
        entries*: List[BlobV2Entry, MAX_BLOBS_REQUEST]