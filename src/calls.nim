import chronos
import presto/client
import results

import rest_client
import ssz_helpers
import types/containers
import types/blobs/v4

export results, containers, v4
export rest_client

const
  JsonMediaType = "application/json"

func bytesToStr(data: openArray[byte]): string {.raises: [].} =
  result = newString(data.len)
  if data.len > 0:
    copyMem(addr result[0], unsafeAddr data[0], data.len)

func httpErr(resp: RestPlainResponse): string {.raises: [].} =
  "HTTP " & $resp.status & ": " & bytesToStr(resp.data)

func decodeOn200[T](t: typedesc[T], resp: RestPlainResponse): Result[T, string] {.
    raises: [].} =
  if resp.status == 200:
    let decoded = sszDecode(T, resp.data)
    if decoded.isOk:
      ok(decoded.get())
    else:
      err($decoded.error())
  else:
    err(httpErr(resp))

proc doGet(
    client: RestSszClient, path, query, accept: string
  ): Future[RestPlainResponse] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  var address = client.rest.address
  address.path = path
  address.query = query
  let
    headers = @[("accept", accept)]
    req = HttpClientRequestRef.new(
      client.rest.session, address, MethodGet, headers = headers)
    resp = await requestWithoutBody(req, Opt.none(string), RestClientMetricsAllTypes)
  let data =
    try:
      await resp.getBodyBytes()
    except HttpError as exc:
      await resp.closeWait()
      raiseRestCommunicationError(exc)
  let res = RestPlainResponse(
    status: resp.status, contentType: resp.contentType,
    headers: resp.headers, data: data)
  await resp.closeWait()
  res

proc doPost(
    client: RestSszClient, path: string, body: seq[byte], contentType, accept: string
  ): Future[RestPlainResponse] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  var address = client.rest.address
  address.path = path
  let
    headers = @[
      ("content-type", contentType),
      ("content-length", $body.len),
      ("accept", accept)
    ]
    req = HttpClientRequestRef.new(
      client.rest.session, address, MethodPost, headers = headers)
    chunkSize = client.rest.session.connectionBufferSize
    resp = await requestWithBody(
      req, cast[pointer](unsafeAddr body[0]), uint64(body.len), chunkSize,
      Opt.none(string), RestClientMetricsAllTypes)
  let data =
    try:
      await resp.getBodyBytes()
    except HttpError as exc:
      await resp.closeWait()
      raiseRestCommunicationError(exc)
  let res = RestPlainResponse(
    status: resp.status, contentType: resp.contentType,
    headers: resp.headers, data: data)
  await resp.closeWait()
  res

proc submitPayload*(
    client: RestSszClient, envelope: ExecutionPayloadEnvelopeAmsterdam
  ): Future[Result[PayloadStatus, string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doPost(
    "/engine/v2/amsterdam/payloads", sszEncode(envelope),
    SszMediaType, SszMediaType)
  decodeOn200(PayloadStatus, resp)

proc updateForkchoice*(
    client: RestSszClient, update: ForkchoiceUpdateAmsterdam
  ): Future[Result[ForkchoiceUpdateResponse, string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doPost(
    "/engine/v2/amsterdam/forkchoice", sszEncode(update),
    SszMediaType, SszMediaType)
  decodeOn200(ForkchoiceUpdateResponse, resp)

proc getPayload*(
    client: RestSszClient, payloadId: string
  ): Future[Result[BuiltPayloadAmsterdam, string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doGet(
    "/engine/v2/amsterdam/payloads/" & payloadId, "", SszMediaType)
  decodeOn200(BuiltPayloadAmsterdam, resp)

proc getBodiesByHash*(
    client: RestSszClient, request: BodiesByHashRequest
  ): Future[Result[BodiesResponse[ExecutionPayloadBodyAmsterdam], string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doPost(
    "/engine/v2/amsterdam/bodies/hash", sszEncode(request),
    SszMediaType, SszMediaType)
  decodeOn200(BodiesResponse[ExecutionPayloadBodyAmsterdam], resp)

proc getBodiesByRange*(
    client: RestSszClient, startBlock, count: uint64
  ): Future[Result[BodiesResponse[ExecutionPayloadBodyAmsterdam], string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let
    query = "from=" & $startBlock & "&count=" & $count
    resp = await client.doGet("/engine/v2/amsterdam/bodies", query, SszMediaType)
  decodeOn200(BodiesResponse[ExecutionPayloadBodyAmsterdam], resp)

proc getBlobsV4*(
    client: RestSszClient, request: BlobsV4Request
  ): Future[Result[Opt[BlobsV4Response], string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doPost(
    "/engine/v2/blobs/v4", sszEncode(request), SszMediaType, SszMediaType)
  case resp.status
  of 200:
    let decoded = sszDecode(BlobsV4Response, resp.data)
    if decoded.isOk:
      ok(Opt.some(decoded.get()))
    else:
      err($decoded.error())
  of 204:
    ok(Opt.none(BlobsV4Response))
  else:
    err(httpErr(resp))

proc getCapabilities*(
    client: RestSszClient
  ): Future[Result[string, string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doGet("/engine/v2/capabilities", "", JsonMediaType)
  if resp.status == 200:
    ok(bytesToStr(resp.data))
  else:
    err(httpErr(resp))

proc getIdentity*(
    client: RestSszClient
  ): Future[Result[string, string]] {.
    async: (raises: [CancelledError, RestCommunicationError]).} =
  let resp = await client.doGet("/engine/v2/identity", "", JsonMediaType)
  if resp.status == 200:
    ok(bytesToStr(resp.data))
  else:
    err(httpErr(resp))
