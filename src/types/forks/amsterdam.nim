import ../primitives
import ../common

type
    ExecutionPayloadAmsterdam* = object  # Cancun + block_access_list + slot_number
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
        block_access_list*: ByteList[MAX_BAL_BYTES]
        slot_number*: Uint64

    PayloadAttributesAmsterdam* = object  # Cancun + slot_number + target_gas_limit
        timestamp*: Uint64
        prev_randao*: Bytes32
        suggested_fee_recipient*: Address
        withdrawals*: List[Withdrawal, MAX_WITHDRAWALS_PER_PAYLOAD]
        parent_beacon_block_root*: Root
        slot_number*: Uint64
        target_gas_limit*: Uint64

    ExecutionPayloadBodyAmsterdam* = object  # Shanghai + block_access_list
        transactions*: List[ByteList[MAX_BYTES_PER_TX], MAX_TXS_PER_PAYLOAD]
        withdrawals*: List[Withdrawal, MAX_WITHDRAWALS_PER_PAYLOAD]
        block_access_list*: ByteList[MAX_BAL_BYTES]

    BuiltPayloadAmsterdam* = object  # Osaka with the Amsterdam ExecutionPayload
        payload*: ExecutionPayloadAmsterdam
        block_value*: Uint256
        blobs_bundle*: BlobsBundleV2
        execution_requests*: List[ByteList[MAX_BYTES_PER_EXECUTION_REQUEST], MAX_EXECUTION_REQUESTS_PER_PAYLOAD]
        should_override_builder*: Boolean

    ExecutionPayloadEnvelopeAmsterdam* = object  # Prague shape, Amsterdam inner
        payload*: ExecutionPayloadAmsterdam
        parent_beacon_block_root*: Root
        execution_requests*: List[ByteList[MAX_BYTES_PER_EXECUTION_REQUEST], MAX_EXECUTION_REQUESTS_PER_PAYLOAD]