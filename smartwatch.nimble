# Package

version       = "0.1.0"
author        = "Akito <the@akito.ooo"
description   = "WebUI showing S.M.A.R.T. status of storage media on servers."
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["smartwatch"]


# Dependencies

requires "nim >= 1.2.4"
requires "jester >= 0.4.3"
