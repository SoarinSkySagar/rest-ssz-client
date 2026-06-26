import chronos

import calls
import ssztext

const
  InputPath  = "input.txt"
  OutputPath = "output.txt"

proc processBlock(
    client: RestSszClient, outFile: File, blk: Block
  ): Future[void] {.async.} =
  try:
    case blk.typeName
    of "ExecutionPayloadEnvelopeAmsterdam":
      var req: ExecutionPayloadEnvelopeAmsterdam
      assign(blk.node, req)
      let r = await client.submitPayload(req)
      if r.isOk: outFile.logBlock("PayloadStatus", r.get())
      else: stderr.writeLine("submitPayload: " & r.error)

    of "ForkchoiceUpdateAmsterdam":
      var req: ForkchoiceUpdateAmsterdam
      assign(blk.node, req)
      let r = await client.updateForkchoice(req)
      if r.isOk: outFile.logBlock("ForkchoiceUpdateResponse", r.get())
      else: stderr.writeLine("updateForkchoice: " & r.error)

    of "BodiesByHashRequest":
      var req: BodiesByHashRequest
      assign(blk.node, req)
      let r = await client.getBodiesByHash(req)
      if r.isOk: outFile.logBlock("BodiesResponse", r.get())
      else: stderr.writeLine("getBodiesByHash: " & r.error)

    of "BlobsV4Request":
      var req: BlobsV4Request
      assign(blk.node, req)
      let r = await client.getBlobsV4(req)
      if r.isOk:
        if r.get().isSome: outFile.logBlock("BlobsV4Response", r.get().get())
        else: outFile.logLine("BlobsV4Response\nresult: none (204 no content)\n")
      else: stderr.writeLine("getBlobsV4: " & r.error)

    else:
      stderr.writeLine("skipping non-request type: " & blk.typeName)
  except RestCommunicationError as exc:
    stderr.writeLine("transport error for " & blk.typeName & ": " & exc.msg)
  except IOError as exc:
    stderr.writeLine("write failed for " & blk.typeName & ": " & exc.msg)

proc main() {.async.} =
  let client = newRestSszClient().valueOr:
    stderr.writeLine("failed to create client: " & $error)
    return
  defer: await client.close()

  let blocks =
    try:
      readBlocks(InputPath)
    except Exception as exc:
      stderr.writeLine("failed to read " & InputPath & ": " & exc.msg)
      return

  let outFile =
    try:
      openLog(OutputPath)
    except IOError as exc:
      stderr.writeLine("cannot open " & OutputPath & ": " & exc.msg)
      return
  defer: outFile.close()

  for blk in blocks:
    await client.processBlock(outFile, blk)
    echo "processed ", blk.typeName

when isMainModule:
  waitFor main()
