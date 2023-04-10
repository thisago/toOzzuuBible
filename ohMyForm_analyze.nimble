# Package

version       = "0.4.0"
author        = "Thiago Navarro"
description   = "A userscript that allows you go to the Ozzuu Bible in any biblical reference in any site!"
license       = "MIT"
srcDir        = "src"
bin           = @["toOzzuuBible"]
binDir = "build"

backend = "js"

# Dependencies

requires "nim >= 1.6.4"

requires "util"
requires "gm_api >= 0.3.1"
requires "bibleTools >= 1.2.4"

import src/toOzzuuBible/header

from std/strformat import fmt
from std/strutils import replace
from std/base64 import encode
from std/os import `/`

task finalize, "Uglify and add header":
  let
    f = binDir / bin[0] & "." & backend
    outF = binDir / bin[0] & ".user." & backend
  exec fmt"uglifyjs -o {f} {f}"
  let cssCode = gorgeEx("sass src/style/toOzzuuBible.sass")
  if cssCode.exitCode != 0:
    quit cssCode.output
  outF.writeFile (userscriptHeader & "\n" & f.readFile).replace("CSSCODEHERE", cssCode.output.encode)
  rmFile f

task buildRelease, "Build release version":
  exec "nimble -d:danger build"
  finalizeTask()
