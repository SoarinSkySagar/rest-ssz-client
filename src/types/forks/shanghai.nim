import ../primitives
import ../common

type
    ExecutionPayloadShanghai* = object  # Paris + withdrawals
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

    PayloadAttributesShanghai* = object  # Paris + withdrawals
        timestamp*: Uint64
        prev_randao*: Bytes32
        suggested_fee_recipient*: Address
        withdrawals*: List[Withdrawal, MAX_WITHDRAWALS_PER_PAYLOAD]

    ExecutionPayloadBodyShanghai* = object  # Paris + withdrawals
        transactions*: List[ByteList[MAX_BYTES_PER_TX], MAX_TXS_PER_PAYLOAD]
        withdrawals*: List[Withdrawal, MAX_WITHDRAWALS_PER_PAYLOAD]

    BuiltPayloadShanghai* = object
        payload*: ExecutionPayloadShanghai
        block_value*: Uint256
    
    ExecutionPayloadEnvelopeShanghai* = object
        payload*: ExecutionPayloadShanghai