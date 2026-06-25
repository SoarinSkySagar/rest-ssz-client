import ../primitives
import ../common
import prague

type
    ExecutionPayloadOsaka* = ExecutionPayloadPrague

    PayloadAttributesOsaka* = PayloadAttributesPrague

    ExecutionPayloadBodyOsaka* = ExecutionPayloadBodyPrague

    BuiltPayloadOsaka* = object  # Prague but blobs_bundle is V2
        payload*: ExecutionPayloadOsaka
        block_value*: Uint256
        blobs_bundle*: BlobsBundleV2
        execution_requests*: List[ByteList[MAX_BYTES_PER_EXECUTION_REQUEST], MAX_EXECUTION_REQUESTS_PER_PAYLOAD]
        should_override_builder*: Boolean

    ExecutionPayloadEnvelopeOsaka* = object  # Prague shape, Osaka inner
        payload*: ExecutionPayloadOsaka
        parent_beacon_block_root*: Root
        execution_requests*: List[ByteList[MAX_BYTES_PER_EXECUTION_REQUEST], MAX_EXECUTION_REQUESTS_PER_PAYLOAD]