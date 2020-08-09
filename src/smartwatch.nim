import
  smartharvest,
  htmlgen,
  jester,
  tablegenerator,
  parseopt
from os import
  commandLineParams,
  getCurrentDir
from osproc import 
  execCmdEx
from strutils import
  parseInt,
  contains
from json import 
  parseJson,
  getFields,
  getElems,
  getStr,
  hasKey
from tables import 
  hasKey
include
  depman,
  debug

router router:
  get "/dashboard":
    redirect "/"
  get "/":
    var smart_all: OrderedTable[seq[string], seq[seq[string]]]
    if debug_build:
        smart_all = getSmartDataAll(@["/dev/sda", "/dev/sdb", "/dev/sdc", "/dev/sdd"])
    else:
        smart_all = getSmartDataAll(getAllDevices())
    resp """<!DOCTYPE html>
<head>
  <link rel="stylesheet" href="css/dashboard.css">
</head>
<header>
  <a href='/'>Logo</a>
  <label for='toggleMenu'>
    <img src='' alt='menu' />
  </label>
</header><input id='toggleMenu' type='checkbox' />
<nav>
  <ul>
    <li><a href='/dashboard'>Dashboard</a></li>
    <li><a href='/management'>Management</a></li>
    <li><a href='/settings'>Settings</a></li>
    <li><a href='/about'>About</a></li>
    <!--<li><a href='/test'>Test</a></li>-->
  </ul>
</nav>""" &
      createSmartHtmlTable(smart_all) &
      br()
  
  get "/about":
    resp """
<!doctype html>

<html lang="en">
<head>
  <meta charset="utf-8">

  <title>About Smartwatch</title>
  <meta name="description" content="About Smartwatch">
  <meta name="author" content="Akito">

  <link rel="stylesheet" href="css/about.css">

</head>
<header>
  <a href='/'>Logo</a>
  <label for='toggleMenu'>
    <img src='' alt='menu' />
  </label>
</header><input id='toggleMenu' type='checkbox' />
<nav>
  <ul>
    <li><a href='/dashboard'>Dashboard</a></li>
    <li><a href='/management'>Management</a></li>
    <li><a href='/settings'>Settings</a></li>
    <li><a href='/about'>About</a></li>
    <!--<li><a href='/test'>Test</a></li>-->
  </ul>
</nav>
         """ &
         br() &
         """<strong>License</strong>""" &
         br() &
         br() &
         "Copyright (C) 2020  Akito <the@akito.ooo>" &
         br() &
         br() &
         "This program is free software: you can redistribute it and/or modify" &
         br() &
         "it under the terms of the GNU General Public License as published by" &
         br() &
         "the Free Software Foundation, either version 3 of the License, or" &
         br() &
         "(at your option) any later version." &
         br() &
         br() &
         "This program is distributed in the hope that it will be useful," &
         br() &
         "but WITHOUT ANY WARRANTY; without even the implied warranty of" &
         br() &
         "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" &
         br() &
         "GNU General Public License for more details." &
         br() &
         br() &
         "You should have received a copy of the GNU General Public License" &
         br() &
         "along with this program.  If not, see <https://www.gnu.org/licenses/>."
  get "/management":
    redirect "/"
  get "/settings":
    redirect "/"
  get "/json":
    resp "This response will be a JSON!"
  get "/test":
    resp "Test succeeded!"

proc areSmartctlPermissionsGiven(): bool =
  let
    (raw_smart_output, _) = execCmdEx("/usr/sbin/smartctl --scan-open --json=c")
    smart_devices = raw_smart_output.parseJson
                                    .getFields
                                    .getOrDefault("devices")
                                    .getElems
  for dev in smart_devices:
    if dev.getFields
          .hasKey("open_error") and
       dev.getFields["open_error"].getStr
          .contains("Permission denied"):
      return false
  return true

proc run() =
  if debug_build == false:
    if not areSmartctlPermissionsGiven():
      raise OS_PERMISSION_ERROR.newException("\nNot permitted to open devices.\nPlease run me as the `root` user.\n")
  var
    port: Port
    dir: string
  for kind, key, val in commandLineParams().getopt():
    case kind
      of cmdArgument:
        discard
      of cmdLongOption, cmdShortOption:
        case key:
          of "port", "p": port = val.parseInt().Port
          of "directory", "dir", "d": dir = val
      of cmdEnd: assert(false)
  if port.int == 0: port = 50232.Port
  if dir == "": dir = getCurrentDir() & "/" & "smartwatchstatic"
  let
    settings = newSettings(port = port, staticDir = dir)
  var jester = initJester(router, settings = settings)
  jester.serve()

when isMainModule:
  run()