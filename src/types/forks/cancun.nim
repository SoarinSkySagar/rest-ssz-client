import ../primitives
import ../common
import shanghai

type
    ExecutionPayloadCancun* = object  # Shanghai + blob_gas_used + excess_blob_gas
        parent_hash*: Hash32
        fee_recipient*: Address
        state_root*: Hash32
        receipts_root*: Hash32
        logs_bloom*: Bloom
        prev_randao*: Bytes32
        block_number*: Uint64
        gas_limit*: Uint64
        gas_used*: Uint64
        timestamp*: Uint64
        extra_data*: ByteList[MAX_EXTRA_DATA_BYTES]
        base_fee_per_gas*: Uint256
        block_hash*: Hash32
        transactions*: List[ByteList[MAX_BYTES_PER_TX], MAX_TXS_PER_PAYLOAD]
        withdrawals*: List[Withdrawal, MAX_WITHDRAWALS_PER_PAYLOAD]
        blob_gas_used*: Uint64
        excess_blob_gas*: Uint64

    PayloadAttributesCancun* = object  # Shanghai + parent_beacon_block_root
        timestamp*: Uint64
        prev_randao*: Bytes32
        suggested_fee_recipient*: Address
        withdrawals*: List[Withdrawal, MAX_WITHDRAWALS_PER_PAYLOAD]
        parent_beacon_block_root*: Root

    ExecutionPayloadBodyCancun* = ExecutionPayloadBodyShanghai

    BuiltPayloadCancun* = object  # Shanghai + blobs_bundle (V1) + should_override_builder
        payload*: ExecutionPayloadCancun
        block_value*: Uint256
        blobs_bundle*: BlobsBundleV1
        should_override_builder*: Boolean

    ExecutionPayloadEnvelopeCancun* = object  # + parent_beacon_block_root
        payload*: ExecutionPayloadCancun
        parent_beacon_block_root*: Root