import
  smartharvest,
  htmlgen,
  jester,
  tablegenerator,
  parseopt
from os import
  paramStr,
  commandLineParams,
  getCurrentDir
from strutils import
  parseInt
include
  depman

router mainRouter:
  get "/dashboard":
    redirect "/"
  get "/":
    let
      smart_all: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sda", "/dev/sdb"])
    resp """<!DOCTYPE html>
<head>
  <link rel="stylesheet" href="css/styles.css">
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

proc run() =
  let
    params = commandLineParams()
  var
    port: Port
    dir: string
  for kind, key, val in params.getopt():
    case kind
      of cmdArgument:
        discard
      of cmdLongOption, cmdShortOption:
        case key:
          of "port", "p": port = val.parseInt().Port
          of "directory", "dir", "d": dir = val
      of cmdEnd: assert(false)
  if port.int == 0: port = 50232.Port
  if dir == "": dir = getCurrentDir() & "/" & "public"
  let
    settings = newSettings(port = port, staticDir = dir)
  var jester = initJester(mainRouter, settings = settings)
  jester.serve()

when isMainModule:
  run()