import primitives
import common
import forks/[fork, paris, shanghai, cancun, prague, osaka, amsterdam]

export primitives, common
export fork, paris, shanghai, cancun, prague, osaka, amsterdam

type

  ExecutionPayload* = ExecutionPayloadAmsterdam

  PayloadAttributes* = PayloadAttributesAmsterdam

  ForkchoiceState* = object
    head_block_hash*: Hash32
    safe_block_hash*: Hash32
    finalized_block_hash*: Hash32

  PayloadStatus* = object
    status*: uint8                  # 0=VALID 1=INVALID 2=SYNCING 3=ACCEPTED
    latest_valid_hash*: Optional[Hash32]
    validation_error*: Optional[String]

  ExecutionPayloadBody* = ExecutionPayloadBodyAmsterdam

  ForkchoiceUpdate*[A] = object  # Paris .. Osaka (A = the fork's PayloadAttributes)
    forkchoice_state*: ForkchoiceState
    payload_attributes*: Optional[A]

  ForkchoiceUpdateAmsterdam* = object  # + custody_columns
    forkchoice_state*: ForkchoiceState
    payload_attributes*: Optional[PayloadAttributesAmsterdam]
    custody_columns*: Optional[Bitvector[CELLS_PER_EXT_BLOB]]

  ForkchoiceUpdateResponse* = object
    payload_status*: PayloadStatus  # restricted: VALID | INVALID | SYNCING
    payload_id*: Optional[Bytes8]

  BlobCellsAndProofs* = object
    blob_cells*: List[Optional[ByteVector[BYTES_PER_CELL]], CELLS_PER_EXT_BLOB]
    proofs*: List[Optional[Bytes48], CELLS_PER_EXT_BLOB]

  ClientVersion* = object
    code*: ByteList[MAX_CLIENT_CODE_LENGTH]
    name*: ByteList[MAX_CLIENT_NAME_LENGTH]
    version*: ByteList[MAX_CLIENT_VERSION_LENGTH]
    commit*: Bytes4

  IdentityResponse* = object
    versions*: List[ClientVersion, MAX_CLIENT_VERSIONS]

  CapabilitiesResponse* = object
    capabilities*: List[ByteList[MAX_CAPABILITY_NAME_LENGTH], MAX_CAPABILITIES]

  BodiesByHashRequest* = object
    block_hashes*: List[Hash32, MAX_BODIES_REQUEST]

  BodyEntry*[B] = object  # B = the fork's ExecutionPayloadBody
    available*: Boolean
    body*: B

  BodiesResponse*[B] = object
    entries*: List[BodyEntry[B], MAX_BODIES_REQUEST]