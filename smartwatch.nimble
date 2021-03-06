# Package

version       = "0.1.0"
author        = "Akito <the@akito.ooo"
description   = "WebUI showing S.M.A.R.T. status of storage media on servers."
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["smartwatch"]
skipDirs      = @["tasks"]
skipFiles     = @["README.md"]
skipExt       = @["nim"]


# Dependencies

requires "nim >= 1.2.4"
requires "jester >= 0.4.3"

# Tasks

task test, "Run test.":
  exec "nim cc -r tests/test.nim"
task configure, "Configure project.":
  exec "git fetch"
  exec "git pull"
  exec "git checkout master"
  exec "git submodule update --init --recursive"
  exec "git submodule update --recursive --remote"
task fbuild, "Build project.":
  exec "nimble makecfg"
  exec """nim c \
            --define:git_rev=$(git log -1 --format="%H") \
            --define:build_date="$(date +'%Y-%m-%dT%H:%M:%S%Z')" \
            --out:smartwatch \
            src/smartwatch
       """
  exec "nimble clean"
task dbuild, "Debug Build project.":
  exec """nim c fakesmartctl.nim && \
          nim c \
            --define:git_rev=$(git log -1 --format="%H") \
            --define:build_date="$(date +'%Y-%m-%dT%H:%M:%S%Z')" \
            --define:debug_build=true \
            --out:smartwatch \
            --debuginfo:on \
            src/smartwatch
       """
task makecfg, "Create nim.cfg for optimized builds.":
  exec "nim tasks/cfg_optimized.nims"
task clean, "Removes nim.cfg.":
  exec "nim tasks/cfg_clean.nims"
#TODO Create better and working "doc" task.
