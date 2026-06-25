# Package

version       = "0.1.0"
author        = "Sagar Rana"
description   = "REST-SSZ client"
license       = "MIT"
srcDir        = "src"
bin           = @["rest_ssz_client"]


# Dependencies

requires "nim >= 2.2.10"
requires "presto"
requires "ssz_serialization"
requires "serialization"