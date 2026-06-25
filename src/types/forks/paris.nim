import ../primitives

type
    ExecutionPayloadParis* = object
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

    PayloadAttributesParis* = object
        timestamp*: Uint64
        prev_randao*: Bytes32
        suggested_fee_recipient*: Address

    ExecutionPayloadBodyParis* = object
        transactions*: List[ByteList[MAX_BYTES_PER_TX], MAX_TXS_PER_PAYLOAD]

    BuiltPayloadParis* = object
        payload*: ExecutionPayloadParis
        block_value*: Uint256

    ExecutionPayloadEnvelopeParis* = object
        payload*: ExecutionPayloadParis