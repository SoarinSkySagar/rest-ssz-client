import ../primitives
import ../common
import cancun

type
    ExecutionPayloadPrague* = ExecutionPayloadCancun

    PayloadAttributesPrague* = PayloadAttributesCancun

    ExecutionPayloadBodyPrague* = ExecutionPayloadBodyCancun

    BuiltPayloadPrague* = object  # Cancun + execution_requests
        payload*: ExecutionPayloadPrague
        block_value*: Uint256
        blobs_bundle*: BlobsBundleV1
        execution_requests*: List[ByteList[MAX_BYTES_PER_EXECUTION_REQUEST], MAX_EXECUTION_REQUESTS_PER_PAYLOAD]
        should_override_builder*: Boolean

    ExecutionPayloadEnvelopePrague* = object  # Cancun + execution_requests
        payload*: ExecutionPayloadPrague
        parent_beacon_block_root*: Root
        execution_requests*: List[ByteList[MAX_BYTES_PER_EXECUTION_REQUEST], MAX_EXECUTION_REQUESTS_PER_PAYLOAD]