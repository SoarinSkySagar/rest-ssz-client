import presto/client

import rest_ssz_client
import types/containers
import types/blobs/v4

export containers, v4

proc submitPayload*(
    body: ExecutionPayloadEnvelopeAmsterdam
  ): PayloadStatus {.
    rest,
    endpoint: "/engine/v2/amsterdam/payloads",
    meth: MethodPost,
    accept: SszMediaType.}

proc updateForkchoice*(
    body: ForkchoiceUpdateAmsterdam
  ): ForkchoiceUpdateResponse {.
    rest,
    endpoint: "/engine/v2/amsterdam/forkchoice",
    meth: MethodPost,
    accept: SszMediaType.}

proc getPayload*(
    payloadId: string
  ): BuiltPayloadAmsterdam {.
    rest,
    endpoint: "/engine/v2/amsterdam/payloads/{payloadId}",
    meth: MethodGet,
    accept: SszMediaType.}

proc getBodiesByHash*(
    body: BodiesByHashRequest
  ): BodiesResponse[ExecutionPayloadBodyAmsterdam] {.
    rest,
    endpoint: "/engine/v2/amsterdam/bodies/hash",
    meth: MethodPost,
    accept: SszMediaType.}

proc getBodiesByRange*(
    `from`: uint64,
    count: uint64
  ): BodiesResponse[ExecutionPayloadBodyAmsterdam] {.
    rest,
    endpoint: "/engine/v2/amsterdam/bodies",
    meth: MethodGet,
    accept: SszMediaType.}

proc getBlobsV4*(
    body: BlobsV4Request
  ): BlobsV4Response {.
    rest,
    endpoint: "/engine/v2/blobs/v4",
    meth: MethodPost,
    accept: SszMediaType.}

proc getCapabilities*(): CapabilitiesResponse {.
    rest,
    endpoint: "/engine/v2/capabilities",
    meth: MethodGet,
    accept: "application/json".}

proc getIdentity*(): IdentityResponse {.
    rest,
    endpoint: "/engine/v2/identity",
    meth: MethodGet,
    accept: "application/json".}
