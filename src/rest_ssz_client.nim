import chronos
import presto, presto/client

export presto, client

const
  SszMediaType* = "application/octet-stream"

type
  RestSszClient* = object
    rest*: RestClientRef
    baseUrl*: string

const
  defaultBaseUrl* = "http://127.0.0.1:9000"

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

when isMainModule:
  proc main() {.async.} =
    let client = newRestSszClient().valueOr:
      echo "failed to create client: ", error
      return
    defer: await client.close()
    echo "client configured for ", client.baseUrl

  waitFor main()
