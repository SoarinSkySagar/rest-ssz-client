import chronos
import presto, presto/client

export presto, client

const
  SszMediaType* = "application/octet-stream"
  defaultBaseUrl* = "http://127.0.0.1:9000"

type
  RestSszClient* = object
    rest*: RestClientRef
    baseUrl*: string

proc newRestSszClient*(
    baseUrl: string = defaultBaseUrl
  ): RestResult[RestSszClient] =
  ok(
    RestSszClient(
      rest: ? RestClientRef.new(baseUrl),
      baseUrl: baseUrl
    )
  )

proc close*(client: RestSszClient) {.async: (raises: []).} =
  await client.rest.closeWait()
