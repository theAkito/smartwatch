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
    let
      smart_all: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sda", "/dev/sdb"])
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